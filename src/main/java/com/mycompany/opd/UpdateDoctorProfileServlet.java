package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.OtpService;
import com.mycompany.opd.resources.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/update-doctor-profile")
@MultipartConfig
public class UpdateDoctorProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String username = (String) session.getAttribute("displayUsername");
        String newContactNumber = request.getParameter("contactNumber");
        String profilePicPath = null;
        String newHashedPassword = null;

        // --- Handle Password Change ---
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        boolean isPasswordChanging = currentPassword != null && !currentPassword.isEmpty();

        if (isPasswordChanging) {
            if (newPassword == null || newPassword.isEmpty() || !newPassword.equals(confirmPassword)) {
                response.sendRedirect("edit-doctor-profile?error=New passwords do not match or are empty.");
                return;
            }

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT password FROM users WHERE user_id = ?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        if (PasswordUtil.verifyPassword(currentPassword, rs.getString("password"))) {
                            newHashedPassword = PasswordUtil.hashPassword(newPassword);
                        } else {
                            response.sendRedirect("edit-doctor-profile?error=Current password is incorrect.");
                            return;
                        }
                    }
                }
            } catch (SQLException e) {
                response.sendRedirect("edit-doctor-profile?error=Database error verifying password.");
                return;
            }
        }

        // --- Handle File Upload ---
        Part filePart = request.getPart("profile_picture");
        String fileName = filePart.getSubmittedFileName();

        if (fileName != null && !fileName.isEmpty()) {
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String uniqueFileName = "doc_" + username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            profilePicPath = UPLOAD_DIR + File.separator + uniqueFileName;
        }
        
        // --- Check if Contact Number Changed ---
        String currentContactNumber = "";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT contact_number FROM users WHERE user_id = ?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    currentContactNumber = rs.getString("contact_number");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctor-profile?error=Could not verify current contact number.");
            return;
        }

        boolean contactNumberChanged = !newContactNumber.equals(currentContactNumber);

        if (contactNumberChanged || isPasswordChanging) {
            // --- OTP Rate Limiting ---
            Long lastOtpTime = (Long) session.getAttribute("lastOtpTime");
            long currentTime = System.currentTimeMillis();
            long fiveMinutesInMillis = 5 * 60 * 1000;

            if (lastOtpTime != null && (currentTime - lastOtpTime < fiveMinutesInMillis)) {
                long timeLeftSeconds = (fiveMinutesInMillis - (currentTime - lastOtpTime)) / 1000;
                String errorMessage = String.format("Please wait %d minutes and %d seconds before requesting a new OTP.", timeLeftSeconds / 60, timeLeftSeconds % 60);
                response.sendRedirect("doctor-profile?error=" + errorMessage);
                return;
            }

            // Store all form data in session and redirect to OTP verification
            storeProfileDataInSession(session, request, newContactNumber, newPassword, profilePicPath);
            OtpService.generateAndSendOtp(session, newContactNumber);
            session.setAttribute("lastOtpTime", currentTime); // Set the new timestamp
            response.sendRedirect("verify_otp.jsp");
            return;
        }

        // --- Update Database ---
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Update user_profiles table
            StringBuilder profileSql = new StringBuilder("UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, permanent_address=?, current_address=?, city=?, postal_code=?, specialization=?, license_number=?, license_expiry_date=?");
            if (profilePicPath != null) {
                profileSql.append(", profile_picture_path=?");
            }
            profileSql.append(" WHERE user_id=?");

            try (PreparedStatement psProfile = conn.prepareStatement(profileSql.toString())) {
                psProfile.setString(1, request.getParameter("surname"));
                psProfile.setString(2, request.getParameter("givenName"));
                psProfile.setString(3, request.getParameter("middleName"));
                psProfile.setDate(4, Date.valueOf(request.getParameter("dateOfBirth")));
                psProfile.setString(5, request.getParameter("gender"));
                psProfile.setString(6, request.getParameter("permanentAddress"));
                psProfile.setString(7, request.getParameter("currentAddress"));
                psProfile.setString(8, request.getParameter("city"));
                psProfile.setString(9, request.getParameter("postalCode"));
                psProfile.setString(10, request.getParameter("specialization"));
                psProfile.setString(11, request.getParameter("licenseNumber"));
                psProfile.setDate(12, Date.valueOf(request.getParameter("licenseExpiryDate")));
                
                int paramIndex = 13;
                if (profilePicPath != null) {
                    psProfile.setString(paramIndex++, profilePicPath.replace(File.separator, "/"));
                }
                psProfile.setInt(paramIndex, userId);
                psProfile.executeUpdate();
            }

            // 2. Update users table (contact number and password if changed)
            StringBuilder userSql = new StringBuilder("UPDATE users SET contact_number=?");
            if (newHashedPassword != null) {
                userSql.append(", password=?");
            }
            userSql.append(" WHERE user_id=?");
            try (PreparedStatement psUser = conn.prepareStatement(userSql.toString())) {
                psUser.setString(1, request.getParameter("contactNumber"));
                int paramIndex = 2;
                if (newHashedPassword != null) {
                    psUser.setString(paramIndex++, newHashedPassword);
                }
                psUser.setInt(paramIndex, userId);
                psUser.executeUpdate();
            }

            conn.commit();

            AuditLogger.log(userId, username, "Doctor", "Updated own profile information");
            response.sendRedirect("doctor-profile?success=Profile updated successfully!");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("edit-doctor-profile?error=Database error: " + e.getMessage());
        }
    }
    
    private void storeProfileDataInSession(HttpSession session, HttpServletRequest request, String newContactNumber, String newPassword, String profilePicPath) {
        Map<String, String> profileData = new HashMap<>();
        profileData.put("surname", request.getParameter("surname"));
        profileData.put("givenName", request.getParameter("givenName"));
        profileData.put("middleName", request.getParameter("middleName"));
        profileData.put("dateOfBirth", request.getParameter("dateOfBirth"));
        profileData.put("gender", request.getParameter("gender"));
        profileData.put("permanentAddress", request.getParameter("permanentAddress"));
        profileData.put("currentAddress", request.getParameter("currentAddress"));
        profileData.put("specialization", request.getParameter("specialization"));
        profileData.put("licenseNumber", request.getParameter("licenseNumber"));
        profileData.put("licenseExpiryDate", request.getParameter("licenseExpiryDate"));
        profileData.put("contactNumber", newContactNumber);
        profileData.put("newPassword", newPassword); // Can be null or empty if not changing
        
        session.setAttribute("profileUpdateData", profileData);
        session.setAttribute("profileUpdatePicPath", profilePicPath); // Can be null
    }
}