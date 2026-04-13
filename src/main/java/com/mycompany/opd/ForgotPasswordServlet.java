package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.OtpService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contactNumber = request.getParameter("contactNumber");
        HttpSession session = request.getSession();

        // --- OTP Rate Limiting ---
        Long lastOtpTime = (Long) session.getAttribute("lastOtpTime");
        long currentTime = System.currentTimeMillis();
        long fiveMinutesInMillis = 5 * 60 * 1000;

        if (lastOtpTime != null && (currentTime - lastOtpTime < fiveMinutesInMillis)) {
            long timeLeftSeconds = (fiveMinutesInMillis - (currentTime - lastOtpTime)) / 1000;
            String errorMessage = String.format("Please wait %d minutes and %d seconds before requesting a new OTP.", timeLeftSeconds / 60, timeLeftSeconds % 60);
            response.sendRedirect("forgot_password.jsp?error=" + errorMessage);
            return;
        }

        // --- Validate if contact number exists ---
        boolean userExists = false;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM users WHERE contact_number = ?")) {
            ps.setString(1, contactNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    userExists = true;
                    // Store user_id for the reset process
                    session.setAttribute("resetUserId", rs.getInt("user_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("forgot_password.jsp?error=Database error. Please try again later.");
            return;
        }

        if (!userExists) {
            response.sendRedirect("forgot_password.jsp?error=No account found with that contact number.");
            return;
        }

        // --- Generate and Send OTP ---
        try {
            OtpService.generateAndSendOtp(session, contactNumber);
            session.setAttribute("lastOtpTime", currentTime); // Set the new timestamp
            session.setAttribute("contactForReset", contactNumber); // Store number for the reset page
            
            // Redirect to the page where the user enters the OTP and new password
            response.sendRedirect("reset_password.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot_password.jsp?error=Failed to send OTP. Please try again.");
        }
    }
}