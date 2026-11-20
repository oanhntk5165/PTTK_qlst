package qlst.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class ImportInvoice5 {
    private int id;
    private LocalDateTime date;
    private BigDecimal totalAmount;
    private Supplier5 supplier;
    private WarehouseStaff5 warehouseStaff;
    private List<ImportInvoiceDetail5> details;

    public ImportInvoice5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Supplier5 getSupplier() { return supplier; }
    public void setSupplier(Supplier5 supplier) { this.supplier = supplier; }

    public WarehouseStaff5 getWarehouseStaff() { return warehouseStaff; }
    public void setWarehouseStaff(WarehouseStaff5 warehouseStaff) { this.warehouseStaff = warehouseStaff; }

    public List<ImportInvoiceDetail5> getDetails() { return details; }
    public void setDetails(List<ImportInvoiceDetail5> details) { this.details = details; }
}
