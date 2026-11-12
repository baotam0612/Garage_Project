package com.garage.model;

public class Manager4 extends User4 {
    private String managementLevel;

    public Manager4() {
    }

    public Manager4(String managementLevel) {
        this.managementLevel = managementLevel;
    }

    public String getManagementLevel() {
        return managementLevel;
    }

    public void setManagementLevel(String managementLevel) {
        this.managementLevel = managementLevel;
    }
}

