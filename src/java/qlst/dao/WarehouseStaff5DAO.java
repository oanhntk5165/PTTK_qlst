package qlst.dao;

import qlst.model.WarehouseStaff5;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WarehouseStaff5DAO extends DAO {
    public List<WarehouseStaff5> getAll() throws SQLException {
        List<WarehouseStaff5> staff = new ArrayList<>();
        String sql = "SELECT u.id, u.name, s.position FROM tblWarehouseStaff5 w JOIN tblStaff5 s ON s.id=w.id JOIN tblUser5 u ON u.id=w.id ORDER BY u.name";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {
            while (rs.next()) { WarehouseStaff5 person = new WarehouseStaff5(); person.setId(rs.getInt("id")); person.setName(rs.getString("name")); person.setPosition(rs.getString("position")); staff.add(person); }
        }
        return staff;
    }
}
