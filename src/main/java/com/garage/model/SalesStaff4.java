package com.garage.model;

public class SalesStaff4 extends User4 {
    private String salesStaffCode;

    public SalesStaff4() {
    }

    public SalesStaff4(String salesStaffCode) {
        this.salesStaffCode = salesStaffCode;
    }

    public SalesStaff4(String id, String salesStaffCode, String fullName) {
        setId(id);
        setSalesStaffCode(salesStaffCode);
        setFullName(fullName);
    }

    public String getSalesStaffCode() {
        return salesStaffCode;
    }

    public void setSalesStaffCode(String salesStaffCode) {
        this.salesStaffCode = salesStaffCode;
    }
}
