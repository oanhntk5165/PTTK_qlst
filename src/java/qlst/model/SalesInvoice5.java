package qlst.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public abstract class SalesInvoice5 {
    private int id;
    private LocalDateTime date;
    private BigDecimal totalAmount;

    public SalesInvoice5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDateTime getDate() { return date; }
    public void setDate(LocalDateTime date) { this.date = date; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}
