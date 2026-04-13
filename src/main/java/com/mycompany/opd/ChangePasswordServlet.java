package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.PasswordUtil;
import com.mycompany.opd.resources.SmsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Session expired. Please log in again.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Basic validation
        if (!newPassword.equals(confirmNewPassword)) {
            response.sendRedirect(getProfileRedirectUrl(session) + "?error=New passwords do not match.");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            String currentHashedPassword = null;
            String contactNumber = null;

            // 1. Fetch current password and contact number from DB
            String sql = "SELECT password, contact_number FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentHashedPassword = rs.getString("password");
                        contactNumber = rs.getString("contact_number");
                    }
                }
            }

            if (currentHashedPassword == null) {
                response.sendRedirect(getProfileRedirectUrl(session) + "?error=Could not find your user account.");
                return;
            }

            // 2. Verify the old password
            if (!PasswordUtil.verifyPassword(oldPassword, currentHashedPassword)) {
                response.sendRedirect(getProfileRedirectUrl(session) + "?error=Incorrect old password.");
                return;
            }

            // 3. OTP Rate Limiting
            Long lastOtpTime = (Long) session.getAttribute("lastOtpTime");
            long currentTime = System.currentTimeMillis();
            long fiveMinutesInMillis = 5 * 60 * 1000;

            if (lastOtpTime != null && (currentTime - lastOtpTime < fiveMinutesInMillis)) {
                long timeLeftSeconds = (fiveMinutesInMillis - (currentTime - lastOtpTime)) / 1000;
                String errorMessage = String.format("Please wait %d minutes and %d seconds before requesting a new OTP.", timeLeftSeconds / 60, timeLeftSeconds % 60);
                response.sendRedirect(getProfileRedirectUrl(session) + "?error=" + errorMessage);
                return;
            }

            // 4. Generate and send OTP
            SecureRandom random = new SecureRandom();
            String otp = String.format("%06d", random.nextInt(999999));

            // 5. Store new hashed password and OTP in session
            String newHashedPassword = PasswordUtil.hashPassword(newPassword);
            session.setAttribute("newHashedPassword", newHashedPassword);
            session.setAttribute("passwordChangeOtp", otp);
            session.setAttribute("otpContactNumber", contactNumber); // Store contact number for resend
            session.setAttribute("otpTimestamp", System.currentTimeMillis());

            // 5. Send SMS
            SmsService.sendSms(contactNumber, "Your AMH password change verification code is: " + otp + ". It will expire in 5 minutes.");
            session.setAttribute("lastOtpTime", currentTime); // Set the new timestamp

            // 7. Redirect to OTP verification page
            response.sendRedirect("verify_password_change.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(getProfileRedirectUrl(session) + "?error=Database error occurred.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(getProfileRedirectUrl(session) + "?error=An unexpected error occurred.");
        }
    }

    private String getProfileRedirectUrl(HttpSession session) {
        String userType = (String) session.getAttribute("userType");
        if ("Patient".equals(userType)) return "profile";
        if ("Doctor".equals(userType)) return "doctor-profile";
        if ("Staff".equals(userType)) return "staff-profile";
        if ("Admin".equals(userType)) return "admin-profile";
        if ("Super Admin".equals(userType)) return "super-admin-profile";
        return "login.jsp"; // Fallback
    }
}