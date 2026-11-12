package com.garage.model;

import java.math.BigDecimal;

public class Service4 {
    private String id;
    private String serviceCode;
    private String serviceName;
    private String imageUrl;
    private String description;
    private BigDecimal price;
    private AvailabilityStatus availabilityStatus;
    private ServiceCategory4 serviceCategory;
    private Integer estimatedMinutes;

    public Service4() {
    }

    public Service4(String id, String serviceCode, String serviceName, String imageUrl, String description,
                    BigDecimal price, AvailabilityStatus availabilityStatus, ServiceCategory4 serviceCategory) {
        this.id = id;
        this.serviceCode = serviceCode;
        this.serviceName = serviceName;
        this.imageUrl = imageUrl;
        this.description = description;
        this.price = price;
        this.availabilityStatus = availabilityStatus;
        this.serviceCategory = serviceCategory;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public AvailabilityStatus getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(AvailabilityStatus availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }

    public ServiceCategory4 getServiceCategory() {
        return serviceCategory;
    }

    public void setServiceCategory(ServiceCategory4 serviceCategory) {
        this.serviceCategory = serviceCategory;
    }

    public Integer getEstimatedMinutes() {
        return estimatedMinutes;
    }

    public void setEstimatedMinutes(Integer estimatedMinutes) {
        this.estimatedMinutes = estimatedMinutes;
    }
}
