package qlst.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/qlst?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";

    public static Connection getConnection() throws SQLException {
        String url = setting("qlst.db.url", "QLST_DB_URL", DEFAULT_URL);
        String user = setting("qlst.db.user", "QLST_DB_USER", "root");
        String password = setting("qlst.db.password", "QLST_DB_PASSWORD", "123456");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Chưa tìm thấy MySQL Connector/J. Hãy thêm mysql-connector-j vào WEB-INF/lib.", ex);
        }
        return DriverManager.getConnection(url, user, password);
    }

    private static String setting(String property, String environment, String fallback) {
        String value = System.getProperty(property);
        if (value == null || value.trim().isEmpty()) value = System.getenv(environment);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
