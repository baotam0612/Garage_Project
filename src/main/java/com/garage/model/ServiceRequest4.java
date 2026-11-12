package com.garage.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ServiceRequest4 {
    private String id;
    private Integer quantity;
    private BigDecimal unitPrice;
    private String customerApprovalStatus;
    private String fulfillmentStatus;
    private String notes;
    private Service4 service;
    private List<Technician4> technicians = new ArrayList<>();
    private ServiceReception4 serviceReception;

    public ServiceRequest4() {
    }

    public ServiceRequest4(String id, Integer quantity, BigDecimal unitPrice, String customerApprovalStatus,
            String fulfillmentStatus, String notes, Service4 service, List<Technician4> technicians) {
        this.id = id;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.customerApprovalStatus = customerApprovalStatus;
        this.fulfillmentStatus = fulfillmentStatus;
        this.notes = notes;
        this.service = service;
        this.technicians = technicians;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getCustomerApprovalStatus() {
        return customerApprovalStatus;
    }

    public void setCustomerApprovalStatus(String customerApprovalStatus) {
        this.customerApprovalStatus = customerApprovalStatus;
    }

    public String getFulfillmentStatus() {
        return fulfillmentStatus;
    }

    public void setFulfillmentStatus(String fulfillmentStatus) {
        this.fulfillmentStatus = fulfillmentStatus;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Service4 getService() {
        return service;
    }

    public void setService(Service4 service) {
        this.service = service;
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
