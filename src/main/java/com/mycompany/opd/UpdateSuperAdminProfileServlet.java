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

@WebServlet("/update-super-admin-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UpdateSuperAdminProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String username = (String) session.getAttribute("displayUsername");

        // Retrieve form data
        String profilePicPath = null;
        String surname = request.getParameter("surname");
        String givenName = request.getParameter("givenName");
        String middleName = request.getParameter("middleName");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender"); 
        String permanentAddress = request.getParameter("permanentAddress");
        String currentAddress = request.getParameter("currentAddress");
        String city = request.getParameter("city");
        String postalCode = request.getParameter("postalCode");
        String newContactNumber = request.getParameter("contactNumber");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword"); 
        String newHashedPassword = null;
        boolean isPasswordChanging = currentPassword != null && !currentPassword.isEmpty();

        // Handle profile picture upload
        Part filePart = request.getPart("profile_picture");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) uploadDirFile.mkdirs();
            
            String uniqueFileName = username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadDir + File.separator + uniqueFileName);
            profilePicPath = (UPLOAD_DIR + File.separator + uniqueFileName).replace(File.separator, "/");
        }

        // Validate password change
        if (isPasswordChanging) {
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("edit-super-admin-profile?error=New passwords do not match.");
                return;
            }
            if (newPassword == null || newPassword.isEmpty()) {
                response.sendRedirect("edit-super-admin-profile?error=New password cannot be empty.");
                return;
            }
            // Verify current password
            try (Connection conn = DBUtil.getConnection()) {
                String passwordSql = "SELECT password FROM users WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(passwordSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && PasswordUtil.verifyPassword(currentPassword, rs.getString("password"))) {
                            newHashedPassword = PasswordUtil.hashPassword(newPassword);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/edit-super-admin-profile?error=Current password is incorrect.");
                            return;
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/edit-super-admin-profile?error=Database error verifying password.");
                return;
            }
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
            response.sendRedirect("super-admin-profile?error=Could not verify current contact number.");
            return;
        }

        boolean contactNumberChanged = !newContactNumber.equals(currentContactNumber);

        // If sensitive info changed, trigger OTP flow
        if (contactNumberChanged || isPasswordChanging) {
            // --- OTP Rate Limiting ---
            Long lastOtpTime = (Long) session.getAttribute("lastOtpTime");
            long currentTime = System.currentTimeMillis();
            long fiveMinutesInMillis = 5 * 60 * 1000;

            if (lastOtpTime != null && (currentTime - lastOtpTime < fiveMinutesInMillis)) {
                long timeLeftSeconds = (fiveMinutesInMillis - (currentTime - lastOtpTime)) / 1000;
                String errorMessage = String.format("Please wait %d minutes and %d seconds before requesting a new OTP.", timeLeftSeconds / 60, timeLeftSeconds % 60);
                response.sendRedirect("edit-super-admin-profile?error=" + errorMessage);
                return;
            }
            storeProfileDataInSession(session, request, newContactNumber, newPassword, profilePicPath);
            OtpService.generateAndSendOtp(session, newContactNumber);
            session.setAttribute("lastOtpTime", currentTime); // Set the new timestamp
            response.sendRedirect("verify_otp.jsp");
            return;
        }


        // Update database
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            
            // Update user_profiles table
            String profileSql;
            // Check if profile exists
            boolean profileExists = false;
            try (PreparedStatement psCheck = conn.prepareStatement("SELECT 1 FROM user_profiles WHERE user_id = ?")) {
                psCheck.setInt(1, userId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    profileExists = rs.next();
                }
            }

            if (profileExists) {
                profileSql = "UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, permanent_address=?, current_address=?, city=?, postal_code=?" + (profilePicPath != null ? ", profile_picture_path=?" : "") + " WHERE user_id=?";
            } else {
                profileSql = "INSERT INTO user_profiles (surname, given_name, middle_name, date_of_birth, gender, permanent_address, profile_picture_path, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            }

            try (PreparedStatement ps = conn.prepareStatement(profileSql)) {
                ps.setString(1, surname);
                ps.setString(2, givenName);
                ps.setString(3, middleName);
                ps.setDate(4, Date.valueOf(dateOfBirthStr));
                ps.setString(5, gender);
                ps.setString(6, permanentAddress);

                if (profileExists) {
                    ps.setString(7, currentAddress);
                    ps.setString(8, city);
                    ps.setString(9, postalCode);
                    int paramIndex = 10;
                    if (profilePicPath != null) {
                        ps.setString(paramIndex++, profilePicPath);
                    }
                    ps.setInt(paramIndex, userId);
                } else { // This is for the less likely case of a Super Admin creating their profile for the first time.
                    int paramIndex = 7;
                    if (profilePicPath != null) {
                        ps.setString(paramIndex++, profilePicPath);
                    } else {
                        ps.setNull(paramIndex++, java.sql.Types.VARCHAR);
                    }
                    ps.setInt(paramIndex, userId);
                }

                ps.executeUpdate();
            }

            // Update users table
            String userSql = "UPDATE users SET contact_number = ?" + (newHashedPassword != null ? ", password = ?" : "") + " WHERE user_id = ?";
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) { // This block is never reached if OTP is not triggered
                int userParamIndex = 1;
                psUser.setString(userParamIndex++, newContactNumber);
                if (newHashedPassword != null) {
                    psUser.setString(userParamIndex++, newHashedPassword);
                }
                psUser.setInt(userParamIndex, userId);
                psUser.executeUpdate();
            }

            conn.commit();
            AuditLogger.log(userId, username, "Super Admin", "Updated own profile information");
            response.sendRedirect(request.getContextPath() + "/super-admin-profile?success=Profile updated successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/edit-super-admin-profile?error=Failed to update profile.");
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
        profileData.put("city", request.getParameter("city"));
        profileData.put("postalCode", request.getParameter("postalCode"));
        profileData.put("contactNumber", newContactNumber);
        profileData.put("newPassword", newPassword); // Can be null or empty if not changing
        
        session.setAttribute("profileUpdateData", profileData);
        session.setAttribute("profileUpdatePicPath", profilePicPath); // Can be null
    }
}
