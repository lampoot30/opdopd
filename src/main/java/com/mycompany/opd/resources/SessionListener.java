package com.mycompany.opd.resources;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebListener
public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // No action needed when a session is created.
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        String username = (String) session.getAttribute("displayUsername");

        if (username != null) {
            // When a session is destroyed (by timeout or logout),
            // clear the session_id from the database to allow a new login.
            String sql = "UPDATE users SET session_id = NULL WHERE username = ?";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.executeUpdate();
                System.out.println("Session cleared from DB for user: " + username);

            } catch (Exception e) {
                System.err.println("Error clearing session_id from DB for user: " + username);
                e.printStackTrace();
            }
        }
    }
}