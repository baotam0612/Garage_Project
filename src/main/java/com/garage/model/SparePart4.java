package com.garage.model;

import java.math.BigDecimal;

public class SparePart4 {
    private String id;
    private String partCode;
    private String partName;
    private String imageUrl;
    private String brand;
    private String origin;
    private String specifications;
    private String unit;
    private String description;
    private BigDecimal sellingPrice;
    private Integer stockQuantity;
    private Integer warrantyPeriod;
    private BusinessStatus businessStatus;
    private SparePartCategory4 sparePartCategory;

    public SparePart4() {
    }

    public SparePart4(String id, String partCode, String partName, String imageUrl, String brand, String origin,
                      String specifications, String unit, String description, BigDecimal sellingPrice,
                      Integer stockQuantity, Integer warrantyPeriod, BusinessStatus businessStatus,
                      SparePartCategory4 sparePartCategory) {
        this.id = id;
        this.partCode = partCode;
        this.partName = partName;
        this.imageUrl = imageUrl;
        this.brand = brand;
        this.origin = origin;
        this.specifications = specifications;
        this.unit = unit;
        this.description = description;
        this.sellingPrice = sellingPrice;
        this.stockQuantity = stockQuantity;
        this.warrantyPeriod = warrantyPeriod;
        this.businessStatus = businessStatus;
        this.sparePartCategory = sparePartCategory;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getPartName() {
        return partName;
    }

    public void setPartName(String partName) {
        this.partName = partName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getSpecifications() {
        return specifications;
    }

    public void setSpecifications(String specifications) {
        this.specifications = specifications;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public Integer getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(Integer stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public Integer getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(Integer warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    public BusinessStatus getBusinessStatus() {
        return businessStatus;
    }

    public void setBusinessStatus(BusinessStatus businessStatus) {
        this.businessStatus = businessStatus;
    }

    public SparePartCategory4 getSparePartCategory() {
        return sparePartCategory;
    }

    public void setSparePartCategory(SparePartCategory4 sparePartCategory) {
        this.sparePartCategory = sparePartCategory;
    }
}
