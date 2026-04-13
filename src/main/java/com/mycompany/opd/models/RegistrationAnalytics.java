package com.mycompany.opd.models;

public class RegistrationAnalytics {

    private String monthName;
    private int year;
    private int count;

    // Default constructor
    public RegistrationAnalytics() {
    }

    // Getters and Setters
    public String getMonthName() {
        return monthName;
    }

    public void setMonthName(String monthName) {
        this.monthName = monthName;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}