package com.garage.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ServiceReception4 {
    private String id;
    private LocalDate receiveAt;
    private LocalDate actualDeliveryAt;
    private String status;
    private List<SparePartRequest4> spareParts = new ArrayList<>();
    private Vehicle4 vehicle;
    private List<ServiceRequest4> serviceRequests = new ArrayList<>();
    private Appointment4 appointment;
    private String description;
    private SalesStaff4 salesStaff;

    public ServiceReception4() {
    }

    public ServiceReception4(String id, LocalDate receiveAt, LocalDate actualDeliveryAt, String status,
                             List<SparePartRequest4> spareParts, Vehicle4 vehicle,
                             List<ServiceRequest4> serviceRequests, Appointment4 appointment, String description) {
        this.id = id;
        this.receiveAt = receiveAt;
        this.actualDeliveryAt = actualDeliveryAt;
        this.status = status;
        this.spareParts = spareParts;
        this.vehicle = vehicle;
        this.serviceRequests = serviceRequests;
        this.appointment = appointment;
        this.description = description;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDate getReceiveAt() {
        return receiveAt;
    }

    public void setReceiveAt(LocalDate receiveAt) {
        this.receiveAt = receiveAt;
    }

    // Compatibility alias for receivedAt
    public LocalDate getReceivedAt() {
        return receiveAt;
    }

    public void setReceivedAt(LocalDate receivedAt) {
        this.receiveAt = receivedAt;
    }

    public LocalDate getActualDeliveryAt() {
        return actualDeliveryAt;
    }

    public void setActualDeliveryAt(LocalDate actualDeliveryAt) {
        this.actualDeliveryAt = actualDeliveryAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<SparePartRequest4> getSpareParts() {
        return spareParts;
    }

    public void setSpareParts(List<SparePartRequest4> spareParts) {
        this.spareParts = spareParts;
    }

    // Compatibility alias for sparePartRequests
    public List<SparePartRequest4> getSparePartRequests() {
        return spareParts;
    }

    public void setSparePartRequests(List<SparePartRequest4> sparePartRequests) {
        this.spareParts = sparePartRequests;
    }

    public Vehicle4 getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle4 vehicle) {
        this.vehicle = vehicle;
    }

    public List<ServiceRequest4> getServiceRequests() {
        return serviceRequests;
    }

    public void setServiceRequests(List<ServiceRequest4> serviceRequests) {
        this.serviceRequests = serviceRequests;
    }

    public Appointment4 getAppointment() {
        return appointment;
    }

    public void setAppointment(Appointment4 appointment) {
        this.appointment = appointment;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public SalesStaff4 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff4 salesStaff) {
        this.salesStaff = salesStaff;
    }
}
