package com.garage.model;

public class WarehouseStaff4 extends User4 {
    private String assignedWarehouseArea;

    public WarehouseStaff4() {
    }

    public WarehouseStaff4(String assignedWarehouseArea) {
        this.assignedWarehouseArea = assignedWarehouseArea;
    }

    public String getAssignedWarehouseArea() {
        return assignedWarehouseArea;
    }

    public void setAssignedWarehouseArea(String assignedWarehouseArea) {
        this.assignedWarehouseArea = assignedWarehouseArea;
    }
}

