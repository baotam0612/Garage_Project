package com.garage.model;

import java.util.ArrayList;
import java.util.List;

public class Customer4 extends Person4 {
    private String customerCode;
    private List<Vehicle4> vehicles = new ArrayList<>();

    public Customer4() {
    }

    public Customer4(String customerCode) {
        this.customerCode = customerCode;
    }

    public Customer4(String id, String customerCode, String fullName, String phoneNumber, String address) {
        setId(id);
        setCustomerCode(customerCode);
        setFullName(fullName);
        setPhoneNumber(phoneNumber);
        setAddress(address);
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }

    public List<Vehicle4> getVehicles() {
        return vehicles;
    }

    public void setVehicles(List<Vehicle4> vehicles) {
        this.vehicles = vehicles == null ? new ArrayList<>() : vehicles;
    }
}
