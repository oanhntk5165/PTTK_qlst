package qlst.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OnlineOrder5 {
    private int id;
    private String status;
    private BigDecimal deliveryFee;
    private LocalDateTime date;
    private BigDecimal totalAmount;
    private Customer5 customer;
    private DeliveryAddress5 deliveryAddress;
    private WarehouseStaff5 warehouseStaff;
    private List<OnlineOrderDetail5> details;

    public OnlineOrder5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public LocalDateTime getDate() { return date; }
    public void setDatet(LocalDateTime date) { this.date = date; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Customer5 getCustomer() { return customer; }
    public void setCustomer(Customer5 customer) { this.customer = customer; }

    public DeliveryAddress5 getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(DeliveryAddress5 deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public WarehouseStaff5 getWarehouseStaff() { return warehouseStaff; }
    public void setWarehouseStaff(WarehouseStaff5 warehouseStaff) { this.warehouseStaff = warehouseStaff; }

    public List<OnlineOrderDetail5> getDetails() { return details; }
    public void setDetails(List<OnlineOrderDetail5> details) { this.details = details; }
}
