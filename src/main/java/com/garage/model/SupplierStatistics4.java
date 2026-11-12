package com.garage.model;

import java.math.BigDecimal;

public class SupplierStatistics4 extends Supplier4 {
    private Integer totalReceipts;
    private BigDecimal totalPurchaseAmount;

    public SupplierStatistics4() {
    }

    public SupplierStatistics4(Integer totalReceipts, BigDecimal totalPurchaseAmount) {
        this.totalReceipts = totalReceipts;
        this.totalPurchaseAmount = totalPurchaseAmount;
    }

    public Integer getTotalReceipts() {
        return totalReceipts;
    }

    public void setTotalReceipts(Integer totalReceipts) {
        this.totalReceipts = totalReceipts;
    }

    public BigDecimal getTotalPurchaseAmount() {
        return totalPurchaseAmount;
    }

    public void setTotalPurchaseAmount(BigDecimal totalPurchaseAmount) {
        this.totalPurchaseAmount = totalPurchaseAmount;
    }
}

