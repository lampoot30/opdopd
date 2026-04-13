package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.PasswordUtil;
import com.mycompany.opd.resources.SmsService;
import jakarta.servlet.RequestDispatcher;
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
import java.sql.Statement;

@WebServlet("/AddAdminServlet")
@MultipartConfig
public class AddAdminServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // A GET request to this servlet should just show the form page.
        RequestDispatcher dispatcher = request.getRequestDispatcher("/add_admin.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int superAdminId = (int) session.getAttribute("userId");
        String superAdminUsername = (String) session.getAttribute("username");

        String username = request.getParameter("username");
        String contactNumber = request.getParameter("contactNumber");
        String generatedPassword = PasswordUtil.generateRandomPassword(10);
        String hashedPassword = PasswordUtil.hashPassword(generatedPassword);
        String profilePicPath = null;

        // --- Handle File Upload ---
        Part filePart = request.getPart("profile_picture");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String uniqueFileName = "admin_" + username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            profilePicPath = (UPLOAD_DIR + File.separator + uniqueFileName).replace(File.separator, "/");
        }

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Insert into users table
            String userSql = "INSERT INTO users (username, password, contact_number, user_type, status) VALUES (?, ?, ?, 'Admin', 'active')";
            int newAdminId = -1;
            try (PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, username);
                userPs.setString(2, hashedPassword);
                userPs.setString(3, contactNumber);
                userPs.executeUpdate();

                try (ResultSet generatedKeys = userPs.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newAdminId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating admin user failed, no ID obtained.");
                    }
                }
            }

            // 2. Insert into user_profiles table
            String profileSql = "INSERT INTO user_profiles (user_id, surname, given_name, middle_name, date_of_birth, gender, permanent_address, current_address, city, postal_code, profile_picture_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement profilePs = conn.prepareStatement(profileSql)) {
                profilePs.setInt(1, newAdminId);
                profilePs.setString(2, request.getParameter("surname"));
                profilePs.setString(3, request.getParameter("givenName"));
                profilePs.setString(4, request.getParameter("middleName"));
                profilePs.setDate(5, Date.valueOf(request.getParameter("dateOfBirth")));
                profilePs.setString(6, request.getParameter("gender"));
                profilePs.setString(7, request.getParameter("permanentAddress"));
                profilePs.setString(8, request.getParameter("currentAddress"));
                profilePs.setString(9, request.getParameter("city"));
                profilePs.setString(10, request.getParameter("postalCode"));
                profilePs.setString(11, profilePicPath);
                profilePs.executeUpdate();
            }

            conn.commit();

            // 3. Send SMS notification
            String message = String.format("Welcome to AMH OPD. You are registered as an Admin. Username: %s, Password: %s.", username, generatedPassword);
            SmsService.sendSms(contactNumber, message);

            AuditLogger.log(superAdminId, superAdminUsername, "Super Admin", "Created new admin account: " + username);
            response.sendRedirect("add_admin.jsp?success=New admin account created successfully and notification sent.");

        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getSQLState().equals("23000")) { // Duplicate entry
                response.sendRedirect("add_admin.jsp?error=Username or contact number already exists.");
            } else {
                response.sendRedirect("add_admin.jsp?error=Database error during admin creation.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_admin.jsp?error=An unexpected error occurred: " + e.getMessage());
        }
    }
}