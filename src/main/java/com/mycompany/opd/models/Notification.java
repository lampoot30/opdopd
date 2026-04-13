package com.mycompany.opd.models;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private String userTypeTarget;
    private String message;
    private boolean isRead;
    private String link;
    private Timestamp createdAt;

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getUserTypeTarget() {
        return userTypeTarget;
    }

    public void setUserTypeTarget(String userTypeTarget) {
        this.userTypeTarget = userTypeTarget;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}