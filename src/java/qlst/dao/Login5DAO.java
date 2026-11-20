package qlst.dao;

import qlst.model.Customer5;
import qlst.model.Manager5;
import qlst.model.SaleStaff5;
import qlst.model.User5;
import qlst.model.WarehouseStaff5;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Login5DAO extends DAO {
    private static final String QUERY = "SELECT u.id, u.name, u.dateOfBirth, u.phone, u.email, u.username, u.password, "
            + "c.id AS customerId, s.position, m.id AS managerId, w.id AS warehouseId, ss.id AS saleStaffId "
            + "FROM tblUser5 u LEFT JOIN tblCustomer5 c ON c.id=u.id "
            + "LEFT JOIN tblStaff5 s ON s.id=u.id LEFT JOIN tblManager5 m ON m.id=u.id "
            + "LEFT JOIN tblWarehouseStaff5 w ON w.id=u.id LEFT JOIN tblSaleStaff5 ss ON ss.id=u.id "
            + "WHERE u.username=?";

    public User5 authenticate(String username, String password) throws SQLException {
        if (username == null || password == null || username.trim().isEmpty()) return null;
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(QUERY)) {
            statement.setString(1, username.trim());
            try (ResultSet rs = statement.executeQuery()) {
                if (!rs.next() || !verifyPassword(password, rs.getString("password"))) return null;
                User5 user;
                if (rs.getObject("warehouseId") != null) user = new WarehouseStaff5();
                else if (rs.getObject("customerId") != null) user = new Customer5();
                else if (rs.getObject("managerId") != null) user = new Manager5();
                else if (rs.getObject("saleStaffId") != null) user = new SaleStaff5();
                else return null;
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                java.sql.Date dob = rs.getDate("dateOfBirth");
                if (dob != null) user.setDateOfBirth(dob.toLocalDate());
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setUsername(rs.getString("username"));
                if (user instanceof qlst.model.Staff5) ((qlst.model.Staff5) user).setPosition(rs.getString("position"));
                return user;
            }
        }
    }

    private boolean verifyPassword(String password, String stored) throws SQLException {
        if (stored == null) return false;
        String[] parts = stored.split("\\$", -1);
        if (parts.length != 4 || !"pbkdf2".equals(parts[0])) return false;
        PBEKeySpec spec = null;
        try {
            int iterations = Integer.parseInt(parts[1]);
            if (iterations < 10000 || iterations > 1000000) return false;
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            spec = new PBEKeySpec(password.toCharArray(), salt, iterations, expected.length * 8);
            byte[] actual = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return MessageDigest.isEqual(expected, actual);
        } catch (IllegalArgumentException | GeneralSecurityException ex) {
            throw new SQLException("Password verification failed.", ex);
        } finally {
            if (spec != null) spec.clearPassword();
        }
    }
}
