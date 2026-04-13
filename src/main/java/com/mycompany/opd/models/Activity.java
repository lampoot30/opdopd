package com.mycompany.opd.models;

import java.sql.Timestamp;

public class Activity {
    private String activity;
    private String description;
    private Timestamp activityDate;

    // Getters and Setters
    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(Timestamp activityDate) {
        this.activityDate = activityDate;
    }
}