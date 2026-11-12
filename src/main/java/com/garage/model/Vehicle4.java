package com.garage.model;

public class Vehicle4 {
    private String id;
    private String licensePlate;
    private String chassisNumber;
    private String make;
    private String model;
    private Integer manufactureYear;
    private String color;
    private Customer4 customer;

    public Vehicle4() { }
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public String getChassisNumber() { return chassisNumber; }
    public void setChassisNumber(String chassisNumber) { this.chassisNumber = chassisNumber; }
    public String getMake() { return make; }
    public void setMake(String make) { this.make = make; }
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    public Integer getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(Integer manufactureYear) { this.manufactureYear = manufactureYear; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public Customer4 getCustomer() { return customer; }
    public void setCustomer(Customer4 customer) { this.customer = customer; }
}
