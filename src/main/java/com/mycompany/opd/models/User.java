package com.mycompany.opd.models;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String contactNumber;
    private String userType;
    private Timestamp updatedAt;

    public User() {
    }

    public User(int userId, String username, String contactNumber, String userType) {
        this.userId = userId;
        this.username = username;
        this.contactNumber = contactNumber;
        this.userType = userType;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}