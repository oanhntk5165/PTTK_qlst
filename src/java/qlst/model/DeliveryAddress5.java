package qlst.model;

public class DeliveryAddress5 {
    private int id;
    private String city;
    private String ward;
    private String addressDetail;
    private Customer5 customer;

    public DeliveryAddress5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

    public Customer5 getCustomer() { return customer; }
    public void setCustomer(Customer5 customer) { this.customer = customer; }
}
