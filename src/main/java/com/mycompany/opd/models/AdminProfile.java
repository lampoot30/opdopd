package com.mycompany.opd.models;

import java.sql.Date;

public class AdminProfile {
    private int adminProfileId;
    private int userId; // Link to users table
    private String surname;
    private String givenName;
    private String middleName;
    private Date dateOfBirth;
    private int age;
    private String gender;
    private String address; // permanent_address
    private String profilePicturePath;
    private User user; // To hold user details like username, contactNumber

    // Constructors
    public AdminProfile() {
    }

    // Getters and Setters
    public int getAdminProfileId() {
        return adminProfileId;
    }

    public void setAdminProfileId(int adminProfileId) {
        this.adminProfileId = adminProfileId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getProfilePicturePath() {
        return profilePicturePath;
    }

    public void setProfilePicturePath(String profilePicturePath) {
        this.profilePicturePath = profilePicturePath;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}