package com.garage.model;

import java.math.BigDecimal;

public class ServiceStatistics4 extends Service4 {
    private Integer totalServiceRequests;
    private BigDecimal totalServiceRevenue;

    public ServiceStatistics4() {
    }

    public ServiceStatistics4(Integer totalServiceRequests, BigDecimal totalServiceRevenue) {
        this.totalServiceRequests = totalServiceRequests;
        this.totalServiceRevenue = totalServiceRevenue;
    }

    public Integer getTotalServiceRequests() {
        return totalServiceRequests;
    }

    public void setTotalServiceRequests(Integer totalServiceRequests) {
        this.totalServiceRequests = totalServiceRequests;
    }

    public BigDecimal getTotalServiceRevenue() {
        return totalServiceRevenue;
    }

    public void setTotalServiceRevenue(BigDecimal totalServiceRevenue) {
        this.totalServiceRevenue = totalServiceRevenue;
    }
}

