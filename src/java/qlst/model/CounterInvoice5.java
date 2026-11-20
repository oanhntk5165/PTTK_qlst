package qlst.model;

import java.util.List;

public class CounterInvoice5 extends SalesInvoice5 {
    private Customer5 customer;
    private SaleStaff5 saleStaff;
    private List<CounterInvoiceDetail5> details;

    public CounterInvoice5() {}

    public Customer5 getCustomer() { return customer; }
    public void setCustomer(Customer5 customer) { this.customer = customer; }

    public SaleStaff5 getSaleStaff() { return saleStaff; }
    public void setSaleStaff(SaleStaff5 saleStaff) { this.saleStaff = saleStaff; }

    public List<CounterInvoiceDetail5> getDetails() { return details; }
    public void setDetails(List<CounterInvoiceDetail5> details) { this.details = details; }
}
