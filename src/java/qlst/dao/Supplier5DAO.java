package qlst.dao;

import qlst.model.Supplier5;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Supplier5DAO extends DAO {
    public List<Supplier5> searchSupplier(String keyword) throws SQLException {
        List<Supplier5> suppliers = new ArrayList<>();
        String sql = "SELECT id, name, address, phone, email FROM tblSupplier5 WHERE (? = '' OR name LIKE ?) ORDER BY name";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            String term = keyword == null ? "" : keyword.trim();
            statement.setString(1, term);
            statement.setString(2, "%" + term + "%");
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) suppliers.add(readSupplier(rs));
            }
        }
        return suppliers;
    }

    public Supplier5 getSupplier(int id) throws SQLException {
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(
                "SELECT id, name, address, phone, email FROM tblSupplier5 WHERE id = ?")) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) { return rs.next() ? readSupplier(rs) : null; }
        }
    }

    public boolean addSupplier(Supplier5 supplier) throws SQLException {
        String sql = "INSERT INTO tblSupplier5(name, address, phone, email) VALUES (?, ?, ?, ?)";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, supplier.getName().trim());
            statement.setString(2, supplier.getAddress());
            statement.setString(3, supplier.getPhone());
            statement.setString(4, supplier.getEmail());
            return statement.executeUpdate() == 1;
        }
    }

    private Supplier5 readSupplier(ResultSet rs) throws SQLException {
        Supplier5 supplier = new Supplier5();
        supplier.setId(rs.getInt("id")); supplier.setName(rs.getString("name"));
        supplier.setAddress(rs.getString("address")); supplier.setPhone(rs.getString("phone")); supplier.setEmail(rs.getString("email"));
        return supplier;
    }
}
