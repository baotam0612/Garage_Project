package com.garage.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Invoice4 {
    private String id;
    private String invoiceNumber;
    private LocalDateTime issuedAt;
    private BigDecimal serviceTotal;
    private BigDecimal sparePartTotal;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;
    private String invoiceStatus;
    private String paymentStatus;
    private String paymentMethod;
    private LocalDateTime paidAt;
    private ServiceReception4 serviceReception;
    private SalesStaff4 salesStaff;

    public Invoice4() {
    }

    public Invoice4(String id, String invoiceNumber, LocalDateTime issuedAt, BigDecimal serviceTotal,
                    BigDecimal sparePartTotal, BigDecimal discountAmount, BigDecimal totalAmount,
                    String invoiceStatus, String paymentStatus, String paymentMethod, LocalDateTime paidAt,
                    ServiceReception4 serviceReception, SalesStaff4 salesStaff) {
        this.id = id;
        this.invoiceNumber = invoiceNumber;
        this.issuedAt = issuedAt;
        this.serviceTotal = serviceTotal;
        this.sparePartTotal = sparePartTotal;
        this.discountAmount = discountAmount;
        this.totalAmount = totalAmount;
        this.invoiceStatus = invoiceStatus;
        this.paymentStatus = paymentStatus;
        this.paymentMethod = paymentMethod;
        this.paidAt = paidAt;
        this.serviceReception = serviceReception;
        this.salesStaff = salesStaff;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
    }

    public BigDecimal getServiceTotal() {
        return serviceTotal;
    }

    public void setServiceTotal(BigDecimal serviceTotal) {
        this.serviceTotal = serviceTotal;
    }

    public BigDecimal getSparePartTotal() {
        return sparePartTotal;
    }

    public void setSparePartTotal(BigDecimal sparePartTotal) {
        this.sparePartTotal = sparePartTotal;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getInvoiceStatus() {
        return invoiceStatus;
    }

    public void setInvoiceStatus(String invoiceStatus) {
        this.invoiceStatus = invoiceStatus;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public ServiceReception4 getServiceReception() {
        return serviceReception;
    }

    public void setServiceReception(ServiceReception4 serviceReception) {
        this.serviceReception = serviceReception;
    }

    public SalesStaff4 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff4 salesStaff) {
        this.salesStaff = salesStaff;
    }
}
