package com.mycompany.opd.resources;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AuditLogger {

    public static void log(int userId, String username, String userType, String action) {
        String sql = "INSERT INTO audit_logs (user_id, username, user_type, action) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, username);
            ps.setString(3, userType);
            ps.setString(4, action);
            ps.executeUpdate();
            
        } catch (Exception e) {
            // Log the error to the console, but don't stop the user's action
            System.err.println("Audit logging failed: " + e.getMessage());
        }
    }
}