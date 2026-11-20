package qlst.model;

public class ProductStat5 {
    private String productName;
    private int stock;
    private int importedQuantity;
    private int soldQuantity;

    public ProductStat5() {}

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public int getImportedQuantity() { return importedQuantity; }
    public void setImportedQuantity(int importedQuantity) { this.importedQuantity = importedQuantity; }

    public int getSoldQuantity() { return soldQuantity; }
    public void setSoldQuantity(int soldQuantity) { this.soldQuantity = soldQuantity; }
}
