package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.OtpService;
import com.mycompany.opd.resources.PasswordUtil;
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
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/verify-otp-and-update")
public class VerifyOtpAndUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String submittedOtp = request.getParameter("otp");

        if (session == null || !OtpService.verifyOtp(session, submittedOtp)) {
            String redirectUrl = "verify_otp.jsp?error=Invalid or expired OTP. Please try again.";
            if (session == null || session.getAttribute("profileUpdateData") == null) {
                redirectUrl = "login.jsp?error=Your session has expired. Please start over.";
            }
            response.sendRedirect(redirectUrl);
            return;
        }

        // OTP is valid, proceed with update
        int userId = (int) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        String userType = (String) session.getAttribute("userType");
        Map<String, String> profileData = (Map<String, String>) session.getAttribute("profileUpdateData");
        String profilePicPath = (String) session.getAttribute("profileUpdatePicPath");

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Update user_profiles table
            switch (userType) {
                case "Super Admin":
                case "Admin":
                    updateAdminProfile(conn, userId, profileData, profilePicPath);
                    break;
                case "Doctor":
                    updateDoctorProfile(conn, userId, profileData, profilePicPath);
                    break;
                case "Staff":
                    updateStaffProfile(conn, userId, profileData, profilePicPath);
                    break;
            }

            // 2. Update users table (contact number and password if provided)
            String newPassword = profileData.get("newPassword");
            StringBuilder userSql = new StringBuilder("UPDATE users SET contact_number=?");
            if (newPassword != null && !newPassword.isEmpty()) {
                userSql.append(", password=?");
            }
            userSql.append(" WHERE user_id=?");

            try (PreparedStatement psUser = conn.prepareStatement(userSql.toString())) {
                psUser.setString(1, profileData.get("contactNumber"));
                int paramIndex = 2;
                if (newPassword != null && !newPassword.isEmpty()) {
                    psUser.setString(paramIndex++, PasswordUtil.hashPassword(newPassword));
                }
                psUser.setInt(paramIndex, userId);
                psUser.executeUpdate();
            }

            conn.commit();

            // Clean up session attributes
            session.removeAttribute("otp");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("newContactNumber");
            session.removeAttribute("profileUpdateData");
            session.removeAttribute("profileUpdatePicPath");

            AuditLogger.log(userId, username, userType, "Updated own profile with new contact number/password");
            
            String redirectURL = getRedirectURL(userType);
            response.sendRedirect(redirectURL + "?success=Profile updated successfully!");

        } catch (SQLException e) {
            e.printStackTrace();
            String redirectURL = getRedirectURL(userType);
            response.sendRedirect(redirectURL + "?error=Database error: " + e.getMessage());
        }
    }
    
    private void updateAdminProfile(Connection conn, int userId, Map<String, String> data, String picPath) throws SQLException {
        StringBuilder sql = new StringBuilder("UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, permanent_address=?");
        if (picPath != null) sql.append(", profile_picture_path=?");
        sql.append(" WHERE user_id=?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, data.get("surname"));
            ps.setString(2, data.get("givenName"));
            ps.setString(3, data.get("middleName"));
            ps.setDate(4, Date.valueOf(data.get("dateOfBirth")));
            ps.setString(5, data.get("gender"));
            ps.setString(6, data.getOrDefault("permanent_address", data.get("address"))); // Handle both keys
            
            int paramIndex = 7;
            if (picPath != null) ps.setString(paramIndex++, picPath.replace(File.separator, "/"));
            ps.setInt(paramIndex, userId);
            ps.executeUpdate();
        }
    }

    private void updateDoctorProfile(Connection conn, int userId, Map<String, String> data, String picPath) throws SQLException {
        StringBuilder sql = new StringBuilder("UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, permanent_address=?, specialization=?, license_number=?, license_expiry_date=?");
        if (picPath != null) sql.append(", profile_picture_path=?");
        sql.append(" WHERE user_id=?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, data.get("surname"));
            ps.setString(2, data.get("givenName"));
            ps.setString(3, data.get("middleName"));
            ps.setDate(4, Date.valueOf(data.get("dateOfBirth")));
            ps.setString(5, data.get("gender"));
            ps.setString(6, data.get("permanent_address"));
            ps.setString(7, data.get("specialization"));
            ps.setString(8, data.get("licenseNumber"));
            ps.setDate(9, Date.valueOf(data.get("licenseExpiryDate")));
            
            int paramIndex = 10;
            if (picPath != null) ps.setString(paramIndex++, picPath.replace(File.separator, "/"));
            ps.setInt(paramIndex, userId);
            ps.executeUpdate();
        }
    }

    private void updateStaffProfile(Connection conn, int userId, Map<String, String> data, String picPath) throws SQLException {
        StringBuilder sql = new StringBuilder("UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, permanent_address=?");
        if (picPath != null) sql.append(", profile_picture_path=?");
        sql.append(" WHERE user_id=?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, data.get("surname"));
            ps.setString(2, data.get("givenName"));
            ps.setString(3, data.get("middleName"));
            ps.setDate(4, Date.valueOf(data.get("dateOfBirth")));
            ps.setString(5, data.get("gender"));
            ps.setString(6, data.get("address")); // Staff uses 'address'
            
            int paramIndex = 7;
            if (picPath != null) ps.setString(paramIndex++, picPath.replace(File.separator, "/"));
            ps.setInt(paramIndex, userId);
            ps.executeUpdate();
        }
    }
    
    private String getRedirectURL(String userType) {
        switch (userType) {
            case "Super Admin": return "super-admin-profile";
            case "Admin": return "admin-profile";
            case "Doctor": return "doctor-profile";
            case "Staff": return "staff-profile";
            default: return "login.jsp";
        }
    }
}