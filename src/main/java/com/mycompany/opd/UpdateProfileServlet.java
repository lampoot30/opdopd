package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import com.mycompany.opd.resources.PasswordUtil;
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

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String username = (String) session.getAttribute("displayUsername"); // Needed for unique filename
        String profilePicPath = null;
        String newHashedPassword = null;

        // --- Handle Password Change ---
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword != null && !currentPassword.isEmpty()) {
            if (newPassword == null || newPassword.isEmpty() || !newPassword.equals(confirmPassword)) {
                response.sendRedirect("profile?error=New passwords do not match or are empty.");
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
                            response.sendRedirect("profile?error=Current password is incorrect.");
                            return;
                        }
                    }
                }
            } catch (SQLException e) {
                response.sendRedirect("profile?error=Database error verifying password.");
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
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Create a unique file name
            String uniqueFileName = username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            profilePicPath = UPLOAD_DIR + File.separator + uniqueFileName;
        }

        // --- Update Database ---
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // Update user_profiles table
            StringBuilder profileSql = new StringBuilder("UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, permanent_address=?, current_address=?, city=?, postal_code=?");
            if (profilePicPath != null) {
                profileSql.append(", profile_picture_path=?");
            }
            profileSql.append(" WHERE user_id = ?");

            try (PreparedStatement psProfile = conn.prepareStatement(profileSql.toString())) {
                psProfile.setString(1, request.getParameter("surname"));
                psProfile.setString(2, request.getParameter("given_name"));
                psProfile.setString(3, request.getParameter("middle_name"));
                psProfile.setDate(4, Date.valueOf(request.getParameter("date_of_birth")));
                psProfile.setString(5, request.getParameter("gender"));
                psProfile.setString(6, request.getParameter("permanent_address"));
                psProfile.setString(7, request.getParameter("current_address"));
                psProfile.setString(8, request.getParameter("city"));
                psProfile.setString(9, request.getParameter("postal_code"));
                
                int paramIndex = 10;
                if (profilePicPath != null) {
                    psProfile.setString(paramIndex++, profilePicPath.replace(File.separator, "/"));
                }
                psProfile.setInt(paramIndex, userId);
                psProfile.executeUpdate();
            }
            // Update users table (contact_number and password if changed)
            StringBuilder userSql = new StringBuilder("UPDATE users SET contact_number=?");
            if (newHashedPassword != null) {
                userSql.append(", password=?");
            }
            userSql.append(" WHERE user_id=?");

            try (PreparedStatement psUser = conn.prepareStatement(userSql.toString())) {
                psUser.setString(1, request.getParameter("contact_number"));
                int paramIndex = 2;
                if (newHashedPassword != null) {
                    psUser.setString(paramIndex++, newHashedPassword);
                }
                psUser.setInt(paramIndex, userId);
                psUser.executeUpdate();
            }

            conn.commit();
            response.sendRedirect("profile?success=Profile updated successfully!");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile?error=Database error: " + e.getMessage());
        }
    }
}