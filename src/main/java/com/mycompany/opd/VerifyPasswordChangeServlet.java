package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/verify-password-change")
public class VerifyPasswordChangeServlet extends HttpServlet {

    private static final long OTP_EXPIRATION_MS = 5 * 60 * 1000; // 5 minutes

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String submittedOtp = request.getParameter("otp");

        if (session == null || session.getAttribute("passwordChangeOtp") == null) {
            response.sendRedirect("login.jsp?error=Session expired. Please try changing your password again.");
            return;
        }

        String sessionOtp = (String) session.getAttribute("passwordChangeOtp");
        long otpTimestamp = (long) session.getAttribute("otpTimestamp");
        String newHashedPassword = (String) session.getAttribute("newHashedPassword");
        int userId = (int) session.getAttribute("userId");

        // Check if OTP has expired
        if (System.currentTimeMillis() - otpTimestamp > OTP_EXPIRATION_MS) {
            clearSessionAttributes(session);
            response.sendRedirect("verify_password_change.jsp?error=OTP has expired. Please try again.");
            return;
        }

        // Check if OTP is correct
        if (submittedOtp.equals(sessionOtp)) {
            // OTP is correct, update the password in the database
            try (Connection conn = DBUtil.getConnection()) {
                String sql = "UPDATE users SET password = ? WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, newHashedPassword);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
                clearSessionAttributes(session);
                response.sendRedirect(getProfileRedirectUrl(session) + "?success=Password changed successfully.");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("verify_password_change.jsp?error=Database error occurred.");
            }
        } else {
            // OTP is incorrect
            response.sendRedirect("verify_password_change.jsp?error=Invalid OTP. Please try again.");
        }
    }

    private void clearSessionAttributes(HttpSession session) {
        session.removeAttribute("newHashedPassword");
        session.removeAttribute("passwordChangeOtp");
        session.removeAttribute("otpTimestamp");
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