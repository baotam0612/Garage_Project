package com.garage.model;

import java.time.LocalDate;

public class User4 extends Person4 {
    private LocalDate startDate;
    private String workShift;
    private String employmentStatus;
    private Account4 account;

    public User4() {
    }

    public User4(String id, String fullName, LocalDate dateOfBirth, String gender, String phoneNumber, String email, String address,
                 LocalDate startDate, String workShift, String employmentStatus, Account4 account) {
        super(id, fullName, dateOfBirth, gender, phoneNumber, email, address);
        this.startDate = startDate;
        this.workShift = workShift;
        this.employmentStatus = employmentStatus;
        this.account = account;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public String getWorkShift() {
        return workShift;
    }

    public void setWorkShift(String workShift) {
        this.workShift = workShift;
    }

    public String getEmploymentStatus() {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus) {
        this.employmentStatus = employmentStatus;
    }

    public Account4 getAccount() {
        return account;
    }

    public void setAccount(Account4 account) {
        this.account = account;
    }
}

