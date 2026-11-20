package qlst.model;

import java.math.BigDecimal;

public class SupplierStat5 {
    private String supplierName;
    private int invoiceCount;
    private BigDecimal importTotal;

    public SupplierStat5() {}

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public int getInvoiceCount() { return invoiceCount; }
    public void setInvoiceCount(int invoiceCount) { this.invoiceCount = invoiceCount; }

    public BigDecimal getImportTotal() { return importTotal; }
    public void setImportTotal(BigDecimal importTotal) { this.importTotal = importTotal; }
}
