package qlst.model;

import java.math.BigDecimal;

public class ImportInvoiceDetail5 {
    private int id;
    private int quantity;
    private BigDecimal importPrice;
    private BigDecimal unitAmount;
    private Product5 product;

    public ImportInvoiceDetail5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getImportPrice() { return importPrice; }
    public void setImportPrice(BigDecimal importPrice) { this.importPrice = importPrice; }

    public BigDecimal getUnitAmount() { return unitAmount; }
    public void setUnitAmount(BigDecimal unitAmount) { this.unitAmount = unitAmount; }

    public Product5 getProduct() { return product; }
    public void setProduct(Product5 product) { this.product = product; }
}
