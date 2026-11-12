package com.garage.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class GoodsReceipt4 {
    private String id;
    private String receiptCode;
    private LocalDateTime confirmedAt;
    private String deliveryNoteNumber;
    private ReceiptStatus receiptStatus;
    private BigDecimal totalAmount;
    private String notes;
    private List<GoodsReceiptDetail4> goodsReceiptDetail = new ArrayList<>();
    private Supplier4 supplier;
    private WarehouseStaff4 warehouseStaff;

    public GoodsReceipt4() {
    }

    public GoodsReceipt4(String id, String receiptCode, LocalDateTime confirmedAt, String deliveryNoteNumber,
                         ReceiptStatus receiptStatus, BigDecimal totalAmount, String notes,
                         List<GoodsReceiptDetail4> goodsReceiptDetail, Supplier4 supplier, WarehouseStaff4 warehouseStaff) {
        this.id = id;
        this.receiptCode = receiptCode;
        this.confirmedAt = confirmedAt;
        this.deliveryNoteNumber = deliveryNoteNumber;
        this.receiptStatus = receiptStatus;
        this.totalAmount = totalAmount;
        this.notes = notes;
        this.goodsReceiptDetail = goodsReceiptDetail;
        this.supplier = supplier;
        this.warehouseStaff = warehouseStaff;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public LocalDateTime getConfirmedAt() {
        return confirmedAt;
    }

    public void setConfirmedAt(LocalDateTime confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public String getDeliveryNoteNumber() {
        return deliveryNoteNumber;
    }

    public void setDeliveryNoteNumber(String deliveryNoteNumber) {
        this.deliveryNoteNumber = deliveryNoteNumber;
    }

    public ReceiptStatus getReceiptStatus() {
        return receiptStatus;
    }

    public void setReceiptStatus(ReceiptStatus receiptStatus) {
        this.receiptStatus = receiptStatus;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<GoodsReceiptDetail4> getGoodsReceiptDetail() {
        return goodsReceiptDetail;
    }

    public void setGoodsReceiptDetail(List<GoodsReceiptDetail4> goodsReceiptDetail) {
        this.goodsReceiptDetail = goodsReceiptDetail;
    }

    public Supplier4 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier4 supplier) {
        this.supplier = supplier;
    }

    public WarehouseStaff4 getWarehouseStaff() {
        return warehouseStaff;
    }

    public void setWarehouseStaff(WarehouseStaff4 warehouseStaff) {
        this.warehouseStaff = warehouseStaff;
    }
}

