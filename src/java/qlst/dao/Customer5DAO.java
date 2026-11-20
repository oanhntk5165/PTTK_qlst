package qlst.dao;

import qlst.model.Customer5;
import qlst.model.DeliveryAddress5;

import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Customer5DAO extends DAO {
    public boolean addCustomer(Customer5 customer) throws SQLException {
        if (customer == null) throw new IllegalArgumentException("Thiếu thông tin khách hàng.");
        String passwordHash = hashPassword(customer.getPassword());
        try (Connection connection = getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement check = connection.prepareStatement("SELECT username, phone, email FROM tblUser5 WHERE username=? OR phone=? OR (email=? AND email<>'')")) {
                    check.setString(1, customer.getUsername()); check.setString(2, customer.getPhone()); check.setString(3, customer.getEmail());
                    try (ResultSet rows = check.executeQuery()) { if (rows.next()) throw new IllegalArgumentException("Email/số điện thoại/tên đăng nhập đã được đăng ký."); }
                }
                int userId;
                String sql = "INSERT INTO tblUser5(name, dateOfBirth, phone, email, username, password) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    statement.setString(1, customer.getName());
                    if (customer.getDateOfBirth() == null) statement.setNull(2, java.sql.Types.DATE);
                    else statement.setDate(2, java.sql.Date.valueOf(customer.getDateOfBirth()));
                    statement.setString(3, customer.getPhone());
                    if (customer.getEmail() == null || customer.getEmail().trim().isEmpty()) statement.setNull(4, java.sql.Types.VARCHAR);
                    else statement.setString(4, customer.getEmail().trim());
                    statement.setString(5, customer.getUsername());
                    statement.setString(6, passwordHash);
                    if (statement.executeUpdate() != 1) {
                        connection.rollback();
                        return false;
                    }
                    try (ResultSet keys = statement.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("Không lấy được mã thành viên vừa tạo.");
                        userId = keys.getInt(1);
                    }
                }
                try (PreparedStatement statement = connection.prepareStatement("INSERT INTO tblCustomer5(id) VALUES (?)")) {
                    statement.setInt(1, userId);
                    if (statement.executeUpdate() != 1) {
                        connection.rollback();
                        return false;
                    }
                }
                if (customer.getDeliveryAddresses() != null && !customer.getDeliveryAddresses().isEmpty()) {
                    sql = "INSERT INTO tblDeliveryAddress5 " + "(city, ward, addressDetail, tblCustomer5id) " + "VALUES (?, ?, ?, ?)";
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {

                        for (DeliveryAddress5 address : customer.getDeliveryAddresses()) {

                            statement.setString(1, address.getCity());
                            statement.setString(2, address.getWard());
                            statement.setString(3, address.getAddressDetail());
                            statement.setInt(4, userId);

                            statement.addBatch();
                        }

                        statement.executeBatch();
                    }
                }
                connection.commit();
                return true;
            } catch (SQLException | RuntimeException ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public boolean usernameExists(String username) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT 1 FROM tblUser5 WHERE username = ?")) {
            statement.setString(1, username);
            try (ResultSet result = statement.executeQuery()) { return result.next(); }
        }
    }

    private String hashPassword(String password) throws SQLException {
        if (password == null || password.isEmpty()) throw new IllegalArgumentException("Mật khẩu không được để trống.");
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 120000, 256);
        try {
            byte[] hash = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return "pbkdf2$120000$" + Base64.getEncoder().encodeToString(salt) + "$" + Base64.getEncoder().encodeToString(hash);
        } catch (GeneralSecurityException ex) {
            throw new SQLException("Không thể bảo vệ mật khẩu thành viên.", ex);
        } finally {
            spec.clearPassword();
        }
    }
}
