package com.garage.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class SparePartRequest4 {
    private String id;
    private Integer actualUsedQuantity;
    private BigDecimal unitPrice;
    private SparePart4 sparePart;

    // Additional fields for workflow and DAO support
    private Integer quantity;
    private String customerApprovalStatus;
    private String notes;
    private List<Technician4> technicians = new ArrayList<>();
    private ServiceReception4 serviceReception;

    public SparePartRequest4() {
    }

    public SparePartRequest4(String id, Integer actualUsedQuantity, BigDecimal unitPrice, SparePart4 sparePart) {
        this.id = id;
        this.actualUsedQuantity = actualUsedQuantity;
        this.unitPrice = unitPrice;
        this.sparePart = sparePart;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getActualUsedQuantity() {
        return actualUsedQuantity;
    }

    public void setActualUsedQuantity(Integer actualUsedQuantity) {
        this.actualUsedQuantity = actualUsedQuantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public SparePart4 getSparePart() {
        return sparePart;
    }

    public void setSparePart(SparePart4 sparePart) {
        this.sparePart = sparePart;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getCustomerApprovalStatus() {
        return customerApprovalStatus;
    }

    public void setCustomerApprovalStatus(String customerApprovalStatus) {
        this.customerApprovalStatus = customerApprovalStatus;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<Technician4> getTechnicians() {
        return technicians;
    }

    public void setTechnicians(List<Technician4> technicians) {
        this.technicians = technicians;
    }

    public ServiceReception4 getServiceReception() {
        return serviceReception;
    }

    public void setServiceReception(ServiceReception4 serviceReception) {
        this.serviceReception = serviceReception;
    }
}
