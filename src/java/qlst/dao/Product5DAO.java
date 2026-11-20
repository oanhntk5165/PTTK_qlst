package qlst.dao;

import qlst.model.Category5;
import qlst.model.Product5;
import qlst.model.ProductDetail5;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.text.Normalizer;
import java.util.Locale;

public class Product5DAO extends DAO {
    public List<Product5> searchProduct(String keyword) throws SQLException {
        List<Product5> products = new ArrayList<>();

        String sql = "SELECT p.id, p.name, p.model, p.brand, p.origin, "
                + "p.unit, p.description, "
                + "c.id AS categoryId, c.name AS categoryName "
                + "FROM tblProduct5 p "
                + "JOIN tblCategory5 c ON c.id = p.tblCategory5id "
                + "WHERE (? = '' OR p.name LIKE ? OR p.model LIKE ? OR p.brand LIKE ?) "
                + "ORDER BY p.name";

        try (Connection connection = getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            String term = keyword == null ? "" : keyword.trim();

            statement.setString(1, term);
            statement.setString(2, "%" + term + "%");
            statement.setString(3, "%" + term + "%");
            statement.setString(4, "%" + term + "%");

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    products.add(readProduct(rs));
                }
            }
        }

        return products;
    }

    public Product5 getProduct(int id) throws SQLException {
        String sql = "SELECT p.id, p.name, p.model, p.brand, p.origin, "
                + "p.unit, p.description, "
                + "c.id AS categoryId, c.name AS categoryName "
                + "FROM tblProduct5 p "
                + "JOIN tblCategory5 c ON c.id = p.tblCategory5id "
                + "WHERE p.id = ?";

        try (Connection connection = getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);

            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? readProduct(rs) : null;
            }
        }
}

    private List<ProductDetail5> getProductDetails(int productId) throws SQLException {

        List<ProductDetail5> details = new ArrayList<>();

        String sql = "SELECT * FROM tblProductDetail5 WHERE tblProduct5id = ?";

        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, productId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    ProductDetail5 detail = new ProductDetail5();

                    detail.setId(rs.getInt("id"));
                    detail.setSku(rs.getString("sku"));
                    detail.setColor(rs.getString("color"));

                    int year = rs.getInt("pYear");
                    detail.setPYear(rs.wasNull() ? null : year);

                    detail.setWarranty(rs.getInt("warranty"));
                    detail.setStock(rs.getInt("stock"));

                    details.add(detail);
                }
            }
        }

        return details;
    }

    public List<Category5> getCategories() throws SQLException {
        List<Category5> categories = new ArrayList<>();
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement("SELECT id, name, description FROM tblCategory5 ORDER BY name"); ResultSet rs = statement.executeQuery()) {
            while (rs.next()) { Category5 c = new Category5(); c.setId(rs.getInt("id")); c.setName(rs.getString("name")); c.setDescription(rs.getString("description")); categories.add(c); }
        }
        return categories;
    }

    public boolean addProduct(Product5 product) throws SQLException {
    try (Connection connection = getConnection()) {
        connection.setAutoCommit(false);

        try {
            try (PreparedStatement check = connection.prepareStatement("SELECT 1 FROM tblProduct5 WHERE model=?")) {
                check.setString(1, product.getModel());
                try (ResultSet rows = check.executeQuery()) { if (rows.next()) throw new IllegalArgumentException("Mặt hàng đã tồn tại trong hệ thống."); }
            }
            int productId;

            String sql = "INSERT INTO tblProduct5"
                    + "(name, model, brand, origin, unit, description, tblCategory5id) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement = connection.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS)) {

                statement.setString(1, product.getName().trim());
                statement.setString(2, product.getModel());
                statement.setString(3, product.getBrand());
                statement.setString(4, product.getOrigin());
                statement.setString(5, product.getUnit());
                statement.setString(6, product.getDescription());
                statement.setInt(7, product.getCategory().getId());

                if (statement.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }

                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Không lấy được mã mặt hàng.");
                    }
                    productId = keys.getInt(1);
                }
            }

            String detailSql = "INSERT INTO tblProductDetail5"
                    + "(sku, color, pYear, warranty, stock, tblProduct5id) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement = connection.prepareStatement(detailSql)) {

                if (product.getDetails() != null) {
                    for (ProductDetail5 detail : product.getDetails()) {

                        String sku = buildSku(product, detail, productId);

                        statement.setString(1, sku);
                        statement.setString(2, detail.getColor());

                        if (detail.getPYear() == null) {
                            statement.setNull(3, java.sql.Types.INTEGER);
                        } else {
                            statement.setInt(3, detail.getPYear());
                        }

                        statement.setInt(4, detail.getWarranty());
                        statement.setInt(5, detail.getStock());
                        statement.setInt(6, productId);

                        statement.addBatch();

                        detail.setProduct(product);
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

    private String buildSku(Product5 product, ProductDetail5 detail, int productId) {
        String base = normalizeSkuPart(product.getName());
        String brand = normalizeSkuPart(product.getBrand());
        String feature = normalizeSkuPart(product.getModel());
        if (feature.isEmpty()) feature = normalizeSkuPart(detail.getColor());
        StringBuilder sku = new StringBuilder("SKU-").append(base);
        if (!brand.isEmpty()) sku.append("-").append(brand);
        if (!feature.isEmpty()) sku.append("-").append(feature);
        return sku.append("-").append(productId).toString();
    }

    private String normalizeSkuPart(String value) {
        if (value == null) return "";
        String normalized = Normalizer.normalize(value.trim(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toUpperCase(Locale.ROOT)
                .replaceAll("[^A-Z0-9]+", "-")
                .replaceAll("(^-|-$)", "");
        return normalized.length() > 18 ? normalized.substring(0, 18) : normalized;
    }

    private Product5 readProduct(ResultSet rs) throws SQLException {

        Product5 p = new Product5();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setModel(rs.getString("model"));
        p.setBrand(rs.getString("brand"));
        p.setOrigin(rs.getString("origin"));
        p.setUnit(rs.getString("unit"));
        p.setDescription(rs.getString("description"));

        Category5 category = new Category5();
        category.setId(rs.getInt("categoryId"));
        category.setName(rs.getString("categoryName"));

        p.setCategory(category);

        List<ProductDetail5> details = getProductDetails(p.getId());

        for (ProductDetail5 detail : details) {
            detail.setProduct(p);
        }

        p.setDetails(details);
        return p;
    }
}
