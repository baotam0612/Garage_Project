package com.garage.model;

import java.math.BigDecimal;

public class SparePartStatistics4 extends SparePart4 {
    private Integer totalPartsSold;
    private BigDecimal totalSparePartRevenue;

    public SparePartStatistics4() {
    }

    public SparePartStatistics4(Integer totalPartsSold, BigDecimal totalSparePartRevenue) {
        this.totalPartsSold = totalPartsSold;
        this.totalSparePartRevenue = totalSparePartRevenue;
    }

    public Integer getTotalPartsSold() {
        return totalPartsSold;
    }

    public void setTotalPartsSold(Integer totalPartsSold) {
        this.totalPartsSold = totalPartsSold;
    }

    public BigDecimal getTotalSparePartRevenue() {
        return totalSparePartRevenue;
    }

    public void setTotalSparePartRevenue(BigDecimal totalSparePartRevenue) {
        this.totalSparePartRevenue = totalSparePartRevenue;
    }
}

