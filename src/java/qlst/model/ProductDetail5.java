package qlst.model;

public class ProductDetail5 {
    private int id;
    private String sku;
    private String color;
    private Integer pYear;
    private int warranty;
    private int stock;
    private Product5 product;

    public ProductDetail5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public Integer getPYear() { return pYear; }
    public void setPYear(Integer pYear) { this.pYear = pYear; }

    public int getWarranty() { return warranty; }
    public void setWarranty(int warranty) { this.warranty = warranty; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public Product5 getProduct() { return product; }
    public void setProduct(Product5 product) { this.product = product; }
}
