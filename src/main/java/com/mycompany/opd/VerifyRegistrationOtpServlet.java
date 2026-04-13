package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.OtpService;
import com.mycompany.opd.resources.SmsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

@WebServlet("/VerifyRegistrationOtpServlet")
public class VerifyRegistrationOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String submittedOtp = request.getParameter("otp");

        if (session == null || session.getAttribute("registrationData") == null || !OtpService.verifyOtp(session, submittedOtp)) {
            String redirectUrl = "verify_registration_otp.jsp?error=Invalid or expired OTP. Please try again.";
            if (session == null || session.getAttribute("registrationData") == null) {
                redirectUrl = "register.jsp?error=Your session has expired. Please start the registration process over.";
            }
            response.sendRedirect(redirectUrl);
            return;
        }

        // OTP is valid, proceed with registration
        Map<String, Object> regData = (Map<String, Object>) session.getAttribute("registrationData");
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert into users table
            String userSql = "INSERT INTO users (username, password, contact_number, user_type) VALUES (?, ?, ?, ?)";
            int userId = -1;
            try (PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, (String) regData.get("username"));
                userPs.setString(2, (String) regData.get("hashedPassword"));
                userPs.setString(3, (String) regData.get("contactNumber"));
                userPs.setString(4, (String) regData.get("userType")); // Use the userType from session
                userPs.executeUpdate();

                // 2. Get the generated user_id
                try (ResultSet generatedKeys = userPs.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        userId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating user failed, no ID obtained.");
                    }
                }
            }

            // 3. Insert into user_profiles table

            String profileSql = "INSERT INTO user_profiles (user_id, surname, given_name, middle_name, date_of_birth, gender, age, religion, permanent_address, current_address, city, postal_code, profile_picture_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement profilePs = conn.prepareStatement(profileSql)) {
                profilePs.setInt(1, userId);
                profilePs.setString(2, (String) regData.get("surname"));
                profilePs.setString(3, (String) regData.get("givenName"));
                profilePs.setString(4, (String) regData.get("middleName"));
                profilePs.setDate(5, Date.valueOf((String) regData.get("dateOfBirth")));
                profilePs.setString(6, (String) regData.get("gender"));
                profilePs.setInt(7, (Integer) regData.get("age"));
                profilePs.setString(8, (String) regData.get("religion"));
                profilePs.setString(9, (String) regData.get("permanentAddress"));
                profilePs.setString(10, (String) regData.get("currentAddress"));
                profilePs.setString(11, (String) regData.get("city"));
                profilePs.setString(12, (String) regData.get("postalCode"));
                
                String profilePicPath = (String) regData.get("profilePicPath");
                if (profilePicPath != null && !profilePicPath.isEmpty()) {
                    profilePs.setString(13, profilePicPath);
                } else {
                    // Explicitly set to null if no picture was uploaded. The DB has a default value.
                    profilePs.setNull(13, java.sql.Types.VARCHAR);
                }
                profilePs.executeUpdate();
            }

            conn.commit(); // Commit transaction

            // Notify admins via SMS about the new registration
            String newUsername = (String) regData.get("username");
            String message = "A new user has registered on the OPD website. Username: " + newUsername;
            SmsService.sendSmsToAdmins(message);

            // Clean up session
            session.removeAttribute("otp");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("registrationData");

            response.sendRedirect("login.jsp?success=Registration successful! You may now log in.");

        } catch (SQLException e) {
            // If any SQL error occurs, roll back the entire transaction
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace(); // Log rollback failure
                }
            }
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=A database error occurred. Please try again.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=An unexpected error occurred. Please try again.");
        } finally {
            // Ensure the connection is always closed
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}