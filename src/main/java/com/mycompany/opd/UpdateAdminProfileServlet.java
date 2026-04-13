package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
import com.mycompany.opd.resources.DBUtil;
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
import java.sql.SQLException;

@WebServlet("/update-admin-profile")
@MultipartConfig
public class UpdateAdminProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || (!"Admin".equals(session.getAttribute("userType")) && !"Super Admin".equals(session.getAttribute("userType")))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");

        // --- Retrieve form data ---
        String givenName = request.getParameter("givenName");
        String middleName = request.getParameter("middleName");
        String surname = request.getParameter("surname");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String permanentAddress = request.getParameter("permanentAddress");
        String currentAddress = request.getParameter("currentAddress");
        String city = request.getParameter("city");
        String postalCode = request.getParameter("postalCode");
        String contactNumber = request.getParameter("contactNumber");

        String profilePicPath = null;
        Part filePart = request.getPart("profile_picture");

        // --- Handle File Upload ---
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String uniqueFileName = "admin_" + username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            profilePicPath = (UPLOAD_DIR + File.separator + uniqueFileName).replace(File.separator, "/");
        }

        String profileUpdateSql = "UPDATE user_profiles SET given_name=?, middle_name=?, surname=?, date_of_birth=?, gender=?, permanent_address=?, current_address=?, city=?, postal_code=?"
                + (profilePicPath != null ? ", profile_picture_path=?" : "") + " WHERE user_id=?";
        String userUpdateSql = "UPDATE users SET contact_number=? WHERE user_id=?";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // Update user_profiles table
            try (PreparedStatement psProfile = conn.prepareStatement(profileUpdateSql)) {
                psProfile.setString(1, givenName);
                psProfile.setString(2, middleName);
                psProfile.setString(3, surname);
                psProfile.setDate(4, Date.valueOf(dateOfBirth));
                psProfile.setString(5, gender);
                psProfile.setString(6, permanentAddress);
                psProfile.setString(7, currentAddress);
                psProfile.setString(8, city);
                psProfile.setString(9, postalCode);
                int paramIndex = 10;
                if (profilePicPath != null) {
                    psProfile.setString(paramIndex++, profilePicPath);
                }
                psProfile.setInt(paramIndex, userId);
                psProfile.executeUpdate();
            }

            // Update users table
            try (PreparedStatement psUser = conn.prepareStatement(userUpdateSql)) {
                psUser.setString(1, contactNumber);
                psUser.setInt(2, userId);
                psUser.executeUpdate();
            }

            conn.commit();
            AuditLogger.log(userId, username, (String) session.getAttribute("userType"), "Updated own profile.");
            response.sendRedirect("admin-profile?success=Profile updated successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("edit-admin-profile?error=Database error: " + e.getMessage());
        }
    }
}