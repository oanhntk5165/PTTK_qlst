package qlst.model;

import java.util.List;

public class Customer5 extends User5 {
    private List<DeliveryAddress5> addresses;

    public Customer5() {}

    public List<DeliveryAddress5> getDeliveryAddresses() {
        return addresses;
    }

    public void setDeliveryAddresses(List<DeliveryAddress5> addresses) {
        this.addresses = addresses;
    }
}
