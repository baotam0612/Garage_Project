package com.garage.model;

import java.math.BigDecimal;

public class GoodsReceiptDetail4 {
    private String id;
    private Integer receivedQuantity;
    private BigDecimal purchaseUnitPrice;
    private BigDecimal lineTotal;
    private SparePart4 sparePart;

    public GoodsReceiptDetail4() {
    }

    public GoodsReceiptDetail4(String id, Integer receivedQuantity, BigDecimal purchaseUnitPrice, BigDecimal lineTotal, SparePart4 sparePart) {
        this.id = id;
        this.receivedQuantity = receivedQuantity;
        this.purchaseUnitPrice = purchaseUnitPrice;
        this.lineTotal = lineTotal;
        this.sparePart = sparePart;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getReceivedQuantity() {
        return receivedQuantity;
    }

    public void setReceivedQuantity(Integer receivedQuantity) {
        this.receivedQuantity = receivedQuantity;
    }

    public BigDecimal getPurchaseUnitPrice() {
        return purchaseUnitPrice;
    }

    public void setPurchaseUnitPrice(BigDecimal purchaseUnitPrice) {
        this.purchaseUnitPrice = purchaseUnitPrice;
    }

    public BigDecimal getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(BigDecimal lineTotal) {
        this.lineTotal = lineTotal;
    }

    public SparePart4 getSparePart() {
        return sparePart;
    }

    public void setSparePart(SparePart4 sparePart) {
        this.sparePart = sparePart;
    }
}

