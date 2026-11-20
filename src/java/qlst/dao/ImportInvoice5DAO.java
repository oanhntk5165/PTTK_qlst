package qlst.dao;

import qlst.model.ImportInvoice5;
import qlst.model.ImportInvoiceDetail5;
import qlst.model.Product5;
import qlst.model.ProductDetail5;
import qlst.model.Supplier5;
import qlst.model.WarehouseStaff5;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ImportInvoice5DAO extends DAO {
    public boolean addImportInvoice(ImportInvoice5 invoice) throws SQLException {
        if (invoice == null || invoice.getDetails() == null || invoice.getDetails().isEmpty()) throw new IllegalArgumentException("Hóa đơn cần có ít nhất một mặt hàng.");
        BigDecimal total = BigDecimal.ZERO;
        for (ImportInvoiceDetail5 detail : invoice.getDetails()) {
            if (detail.getProduct() == null || detail.getProduct().getId() <= 0 || detail.getQuantity() <= 0 || detail.getImportPrice() == null || detail.getImportPrice().signum() <= 0)
                throw new IllegalArgumentException("Số lượng, mặt hàng hoặc đơn giá nhập không hợp lệ.");
            BigDecimal unitAmount = detail.getImportPrice().multiply(BigDecimal.valueOf(detail.getQuantity())).setScale(2, java.math.RoundingMode.HALF_UP);
            detail.setUnitAmount(unitAmount); total = total.add(unitAmount);
        }
        invoice.setTotalAmount(total.setScale(2, java.math.RoundingMode.HALF_UP));
        if (invoice.getDate() == null) invoice.setDate(LocalDateTime.now());

        try (Connection connection = getConnection()) {
            connection.setAutoCommit(false);
            try {
                int invoiceId;
                String sql = "INSERT INTO tblImportInvoice5(date, totalAmount, tblWarehouseStaff5id, tblSupplier5id) VALUES (?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    statement.setTimestamp(1, Timestamp.valueOf(invoice.getDate())); statement.setBigDecimal(2, invoice.getTotalAmount());
                    statement.setInt(3, invoice.getWarehouseStaff().getId()); statement.setInt(4, invoice.getSupplier().getId());
                    if (statement.executeUpdate() != 1) {
                        connection.rollback();
                        return false;
                    }
                    try (ResultSet keys = statement.getGeneratedKeys()) { if (!keys.next()) throw new SQLException("Không lấy được mã hóa đơn nhập."); invoiceId = keys.getInt(1); }
                }
                String detailSql = "INSERT INTO tblImportInvoiceDetail5(quantity, importPrice, unitAmount, tblImportInvoice5id, tblProduct5id) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement detailStatement = connection.prepareStatement(detailSql);
                     PreparedStatement stockStatement = connection.prepareStatement("UPDATE tblProductDetail5 SET stock = stock + ? WHERE id = (SELECT stockDetailId FROM (SELECT MIN(id) AS stockDetailId FROM tblProductDetail5 WHERE tblProduct5id = ?) selectedDetail)")) {
                    for (ImportInvoiceDetail5 detail : invoice.getDetails()) {
                        detailStatement.setInt(1, detail.getQuantity()); detailStatement.setBigDecimal(2, detail.getImportPrice());
                        detailStatement.setBigDecimal(3, detail.getUnitAmount()); detailStatement.setInt(4, invoiceId);
                        detailStatement.setInt(5, detail.getProduct().getId()); detailStatement.addBatch();
                        stockStatement.setInt(1, detail.getQuantity()); stockStatement.setInt(2, detail.getProduct().getId());
                        if (stockStatement.executeUpdate() == 0) throw new SQLException("Không tìm thấy tồn kho cho mặt hàng " + detail.getProduct().getId());
                    }
                    detailStatement.executeBatch();
                }
                connection.commit(); invoice.setId(invoiceId); return true;
            } catch (SQLException | RuntimeException ex) { connection.rollback(); throw ex; }
            finally { connection.setAutoCommit(true); }
        }
    }

    public ImportInvoice5 getImportInvoice(int id) throws SQLException {
        ImportInvoice5 invoice = null;
        String sql = "SELECT i.id, i.date, i.totalAmount, s.id AS supplierId, s.name AS supplierName, s.address AS supplierAddress, s.phone AS supplierPhone, s.email AS supplierEmail, u.id AS staffId, u.name AS staffName "
                + "FROM tblImportInvoice5 i JOIN tblSupplier5 s ON s.id=i.tblSupplier5id JOIN tblUser5 u ON u.id=i.tblWarehouseStaff5id WHERE i.id=?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    invoice = new ImportInvoice5(); invoice.setId(rs.getInt("id")); invoice.setDate(rs.getTimestamp("date").toLocalDateTime()); invoice.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    Supplier5 supplier = new Supplier5(); supplier.setId(rs.getInt("supplierId")); supplier.setName(rs.getString("supplierName")); supplier.setAddress(rs.getString("supplierAddress")); supplier.setPhone(rs.getString("supplierPhone")); supplier.setEmail(rs.getString("supplierEmail")); invoice.setSupplier(supplier);
                    WarehouseStaff5 staff = new WarehouseStaff5(); staff.setId(rs.getInt("staffId")); staff.setName(rs.getString("staffName")); invoice.setWarehouseStaff(staff);
                }
            }
            if (invoice != null) invoice.setDetails(loadDetails(connection, id));
        }
        return invoice;
    }

    private List<ImportInvoiceDetail5> loadDetails(Connection connection, int invoiceId) throws SQLException {
        List<ImportInvoiceDetail5> details = new ArrayList<>();
        String sql ="SELECT d.id, d.quantity, d.importPrice, d.unitAmount, " + "p.id AS productId, p.name AS productName, p.model, p.unit, " + "pd.sku " + "FROM tblImportInvoiceDetail5 d " + "JOIN tblProduct5 p ON p.id = d.tblProduct5id " + "LEFT JOIN tblProductDetail5 pd ON pd.id = (" + "    SELECT MIN(pd2.id) " + "    FROM tblProductDetail5 pd2 " + "    WHERE pd2.tblProduct5id = p.id" + ") " + "WHERE d.tblImportInvoice5id = ? " + "ORDER BY d.id";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, invoiceId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    ImportInvoiceDetail5 d = new ImportInvoiceDetail5();
                    d.setId(rs.getInt("id"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setImportPrice(rs.getBigDecimal("importPrice"));
                    d.setUnitAmount(rs.getBigDecimal("unitAmount"));
                    Product5 p = new Product5();
                    p.setId(rs.getInt("productId"));
                    p.setName(rs.getString("productName"));
                    p.setModel(rs.getString("model"));
                    p.setUnit(rs.getString("unit"));
                    List<ProductDetail5> productDetails = new ArrayList<>();
                    String sku = rs.getString("sku");
                    if (sku != null) {
                        ProductDetail5 pd = new ProductDetail5();
                        pd.setSku(sku);
                        productDetails.add(pd);
                    }
                    p.setDetails(productDetails);
                    d.setProduct(p);
                    details.add(d);
                }
            }
        }

        return details;
    }
}
