package com.garage.model;

import java.time.LocalDate;

public class Appointment4 {
    private String id;
    private LocalDate scheduledAt;
    private String requestDescription;
    private String bookingChannel;
    private String appointmentStatus;
    private Vehicle4 vehicle;

    public Appointment4() {
    }

    public Appointment4(String id, LocalDate scheduledAt, String requestDescription, String bookingChannel,
                        String appointmentStatus, Vehicle4 vehicle) {
        this.id = id;
        this.scheduledAt = scheduledAt;
        this.requestDescription = requestDescription;
        this.bookingChannel = bookingChannel;
        this.appointmentStatus = appointmentStatus;
        this.vehicle = vehicle;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDate getScheduledAt() {
        return scheduledAt;
    }

    public void setScheduledAt(LocalDate scheduledAt) {
        this.scheduledAt = scheduledAt;
    }

    public String getRequestDescription() {
        return requestDescription;
    }

    public void setRequestDescription(String requestDescription) {
        this.requestDescription = requestDescription;
    }

    public String getBookingChannel() {
        return bookingChannel;
    }

    public void setBookingChannel(String bookingChannel) {
        this.bookingChannel = bookingChannel;
    }

    public String getAppointmentStatus() {
        return appointmentStatus;
    }

    public void setAppointmentStatus(String appointmentStatus) {
        this.appointmentStatus = appointmentStatus;
    }

    public Vehicle4 getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle4 vehicle) {
        this.vehicle = vehicle;
    }

}
