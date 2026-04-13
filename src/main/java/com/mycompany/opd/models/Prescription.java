package com.mycompany.opd.models;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class Prescription {
    private int prescriptionId;
    private int appointmentId;
    private String medicationName;
    private String dosage;
    private String frequency;
    private String duration;
    private String notes;
    private Timestamp createdAt;

    public Prescription() {}

    // Convenience constructor to create from a ResultSet
    public Prescription(ResultSet rs) throws SQLException {
        this.prescriptionId = rs.getInt("prescription_id");
        this.appointmentId = rs.getInt("appointment_id");
        this.medicationName = rs.getString("medication_name");
        this.dosage = rs.getString("dosage");
        this.frequency = rs.getString("frequency");
        this.duration = rs.getString("duration");
        this.notes = rs.getString("notes");
        this.createdAt = rs.getTimestamp("created_at");
    }

    // Getters and Setters
    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public String getMedicationName() { return medicationName; }
    public void setMedicationName(String medicationName) { this.medicationName = medicationName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}