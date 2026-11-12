package com.garage.model;

public class Supplier4 {
    private String id;
    private String supplierName;
    private String taxCode;
    private String address;
    private String phoneNumber;
    private String email;
    private String contactPerson;
    private String cooperationStatus;

    public Supplier4() {
    }

    public Supplier4(String id, String supplierName, String taxCode, String address, String phoneNumber, String email, String contactPerson, String cooperationStatus) {
        this.id = id;
        this.supplierName = supplierName;
        this.taxCode = taxCode;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.contactPerson = contactPerson;
        this.cooperationStatus = cooperationStatus;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getCooperationStatus() {
        return cooperationStatus;
    }

    public void setCooperationStatus(String cooperationStatus) {
        this.cooperationStatus = cooperationStatus;
    }
}
