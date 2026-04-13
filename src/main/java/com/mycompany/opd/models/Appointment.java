package com.mycompany.opd.models;

import java.sql.Date;
import java.sql.Timestamp;

public class Appointment {
    private int appointmentId;
    private String patientType;
    private String lastName;
    private String givenName;
    private String middleName;
    private Date preferredDate;
    private String reasonForVisit;
    private String servicesClinic;
    private String attachmentPath;
    private String status;
    private Timestamp createdAt;
    
    // Fields to hold patient details from JOIN
    private int bookedByUserId;
    private java.util.Date patientDateOfBirth;
    private java.sql.Date birthday;
    private String patientGender;
    private String patientAddress;
    private String patientContactNumber;

    // Room details
    private String roomName;

    // Assigned details
    private String assignedDoctorName;
    private String assignedRoomName;

    // Getters and Setters
    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getPatientType() {
        return patientType;
    }

    public void setPatientType(String patientType) {
        this.patientType = patientType;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
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

    public Date getPreferredDate() {
        return preferredDate;
    }

    public void setPreferredDate(Date preferredDate) {
        this.preferredDate = preferredDate;
    }

    public String getReasonForVisit() {
        return reasonForVisit;
    }

    public void setReasonForVisit(String reasonForVisit) {
        this.reasonForVisit = reasonForVisit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getBookedByUserId() {
        return bookedByUserId;
    }

    public void setBookedByUserId(int bookedByUserId) {
        this.bookedByUserId = bookedByUserId;
    }

    public java.util.Date getPatientDateOfBirth() {
        return patientDateOfBirth;
    }

    public void setPatientDateOfBirth(java.util.Date patientDateOfBirth) {
        this.patientDateOfBirth = patientDateOfBirth;
    }

    public String getPatientGender() {
        return patientGender;
    }

    public void setPatientGender(String patientGender) {
        this.patientGender = patientGender;
    }

    public String getPatientAddress() {
        return patientAddress;
    }

    public void setPatientAddress(String patientAddress) {
        this.patientAddress = patientAddress;
    }

    public String getPatientContactNumber() {
        return patientContactNumber;
    }

    public void setPatientContactNumber(String patientContactNumber) {
        this.patientContactNumber = patientContactNumber;
    }

    public java.sql.Date getBirthday() {
        return birthday;
    }

    public void setBirthday(java.sql.Date birthday) {
        this.birthday = birthday;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getServicesClinic() {
        return servicesClinic;
    }

    public void setServicesClinic(String servicesClinic) {
        this.servicesClinic = servicesClinic;
    }

    public String getAttachmentPath() {
        return attachmentPath;
    }

    public void setAttachmentPath(String attachmentPath) {
        this.attachmentPath = attachmentPath;
    }

    public String getAssignedDoctorName() {
        return assignedDoctorName;
    }

    public void setAssignedDoctorName(String assignedDoctorName) {
        this.assignedDoctorName = assignedDoctorName;
    }

    public String getAssignedRoomName() {
        return assignedRoomName;
    }

    public void setAssignedRoomName(String assignedRoomName) {
        this.assignedRoomName = assignedRoomName;
    }
}
