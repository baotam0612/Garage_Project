package com.garage.model;

public class CustomerStatistics4 extends Customer4 {
    private Integer totalCustomers;
    private Integer newCustomers;

    public CustomerStatistics4() {
    }

    public CustomerStatistics4(Integer totalCustomers, Integer newCustomers) {
        this.totalCustomers = totalCustomers;
        this.newCustomers = newCustomers;
    }

    public Integer getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(Integer totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public Integer getNewCustomers() {
        return newCustomers;
    }

    public void setNewCustomers(Integer newCustomers) {
        this.newCustomers = newCustomers;
    }
}

