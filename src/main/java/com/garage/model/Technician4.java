package com.garage.model;

public class Technician4 extends User4 {
    private String specialization;
    private String skillLevel;

    public Technician4() {
    }

    public Technician4(String specialization, String skillLevel) {
        this.specialization = specialization;
        this.skillLevel = skillLevel;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getSkillLevel() {
        return skillLevel;
    }

    public void setSkillLevel(String skillLevel) {
        this.skillLevel = skillLevel;
    }
}

