package com.mycompany.opd;

import com.mycompany.opd.models.Designation;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddStaffServlet")
@MultipartConfig
public class AddStaffServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Designation> designations = new ArrayList<>();
        String sql = "SELECT * FROM designations ORDER BY designation_name ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                designations.add(new Designation(rs.getInt("designation_id"), rs.getString("designation_name")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load designations.");
        }

        request.setAttribute("designations", designations);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/add_staff.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int adminId = (int) session.getAttribute("userId");
        String adminUsername = (String) session.getAttribute("username");

        String username = request.getParameter("username");
        String contactNumber = request.getParameter("contactNumber");
        String designation = request.getParameter("designation");
        String employeeId = request.getParameter("employeeId");
        String generatedPassword = PasswordUtil.generateRandomPassword(10);
        String hashedPassword = PasswordUtil.hashPassword(generatedPassword);
        String profilePicPath = null;

        // Calculate age from date of birth
        java.sql.Date dob = Date.valueOf(request.getParameter("dateOfBirth"));
        java.time.LocalDate birthDate = dob.toLocalDate();
        java.time.LocalDate currentDate = java.time.LocalDate.now();
        int age = Math.max(0, java.time.Period.between(birthDate, currentDate).getYears());

        // --- Handle File Upload ---
        Part filePart = request.getPart("profile_picture");
        String fileName = filePart.getSubmittedFileName();

        if (fileName != null && !fileName.isEmpty()) {
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String uniqueFileName = "staff_" + username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            profilePicPath = (UPLOAD_DIR + File.separator + uniqueFileName).replace(File.separator, "/");
        }

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Insert into users table
            String userSql = "INSERT INTO users (username, password, contact_number, user_type, status) VALUES (?, ?, ?, ?, ?)";
            int newStaffId = -1;
            try (PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, username);
                userPs.setString(2, hashedPassword);
                userPs.setString(3, contactNumber);
                userPs.setString(4, "Staff");
                userPs.setString(5, "active"); // Set the status
                userPs.executeUpdate();

                try (ResultSet generatedKeys = userPs.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newStaffId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating staff user failed, no ID obtained.");
                    }
                }
            }

            // 2. Insert into user_profiles table
            String profileSql = "INSERT INTO user_profiles (user_id, surname, given_name, middle_name, date_of_birth, age, gender, permanent_address, current_address, city, postal_code, employee_id, designation, profile_picture_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement profilePs = conn.prepareStatement(profileSql)) {
                profilePs.setInt(1, newStaffId);
                profilePs.setString(2, request.getParameter("surname"));
                profilePs.setString(3, request.getParameter("givenName"));
                profilePs.setString(4, request.getParameter("middleName"));
                profilePs.setDate(5, Date.valueOf(request.getParameter("dateOfBirth")));
                profilePs.setInt(6, age);
                profilePs.setString(7, request.getParameter("gender"));
                profilePs.setString(8, request.getParameter("permanentAddress"));
                profilePs.setString(9, request.getParameter("currentAddress"));
                profilePs.setString(10, request.getParameter("city"));
                profilePs.setString(11, request.getParameter("postalCode"));
                profilePs.setString(12, employeeId);
                profilePs.setString(13, designation);
                profilePs.setString(14, profilePicPath);
                profilePs.executeUpdate();
            }

            conn.commit();

            // 3. Send SMS notification to the new staff
            try {
                String message = String.format(
                    "Welcome to AMH OPD. You are registered as Staff. Username: %s, Password: %s.",
                    username,
                    generatedPassword
                );
                SmsService.sendSms(contactNumber, message);
            } catch (Exception e) {
                System.err.println("SMS notification failed for new staff " + username + ": " + e.getMessage());
                response.sendRedirect("AddStaffServlet?success=Staff created, but SMS notification failed.&error=" + e.getMessage());
                return;
            }

            AuditLogger.log(adminId, adminUsername, "Admin", "Created new staff account: " + username);
            response.sendRedirect("AddStaffServlet?success=New staff account created successfully and notification sent.");

        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getSQLState().equals("23000")) { // Duplicate entry
                response.sendRedirect("AddStaffServlet?error=Username, contact number, or employee ID already exists.");
            } else {
                response.sendRedirect("AddStaffServlet?error=Database error during staff creation.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddStaffServlet?error=An unexpected error occurred: " + e.getMessage());
        }
    }
}