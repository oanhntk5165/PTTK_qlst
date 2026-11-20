package qlst.model;

import java.math.BigDecimal;

public class RevenueStat5 {
    private String period;
    private BigDecimal revenue;

    public RevenueStat5() {}

    public String getPeriod() { return period; }
    public void setPeriod(String period) { this.period = period; }

    public BigDecimal getRevenue() { return revenue; }
    public void setRevenue(BigDecimal revenue) { this.revenue = revenue; }
}
