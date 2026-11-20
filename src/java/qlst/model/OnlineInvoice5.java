package qlst.model;

public class OnlineInvoice5 extends SalesInvoice5 {
    private OnlineOrder5 onlineOrder;
    private DeliveryStaff5 deliveryStaff;

    public OnlineInvoice5() {}

    public OnlineOrder5 getOnlineOrder() { return onlineOrder; }
    public void setOnlineOrder(OnlineOrder5 onlineOrder) { this.onlineOrder = onlineOrder; }

    public DeliveryStaff5 getDeliveryStaff() { return deliveryStaff; }
    public void setDeliveryStaff(DeliveryStaff5 deliveryStaff) { this.deliveryStaff = deliveryStaff; }
}
