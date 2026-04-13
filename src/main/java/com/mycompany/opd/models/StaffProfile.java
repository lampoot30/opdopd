package com.mycompany.opd.models;

import java.sql.Date;

public class StaffProfile {
    private int staffProfileId;
    private int userId;
    private String surname;
    private String givenName;
    private String middleName;
    private Date dateOfBirth;
    private int age;
    private String gender;
    private String name;
    private String employeeId;
    private String contactNumber;
    private String address;
    private String profilePicturePath;
    private User user;

    // Getters and Setters
    public int getStaffProfileId() { return staffProfileId; }
    public void setStaffProfileId(int staffProfileId) { this.staffProfileId = staffProfileId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    // Convenience getter for JSP to access userId as 'id'
    public int getId() {
        return userId;
    }

    public void setId(int id) {
        this.userId = id;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getSurname() { return surname; }
    public void setSurname(String surname) { this.surname = surname; }

    public String getGivenName() { return givenName; }
    public void setGivenName(String givenName) { this.givenName = givenName; }

    public String getMiddleName() { return middleName; }
    public void setMiddleName(String middleName) { this.middleName = middleName; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getProfilePicturePath() { return profilePicturePath; }
    public void setProfilePicturePath(String profilePicturePath) { this.profilePicturePath = profilePicturePath; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
