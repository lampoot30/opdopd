package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
import com.mycompany.opd.models.Specialization;
import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.PasswordUtil;
import com.mycompany.opd.resources.SmsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
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

@WebServlet("/AddDoctorServlet")
@MultipartConfig
public class AddDoctorServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "profile_pictures";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Specialization> specializations = new ArrayList<>();
        String sql = "SELECT * FROM specializations ORDER BY specialization_name ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                specializations.add(new Specialization(rs.getInt("specialization_id"), rs.getString("specialization_name")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load specializations.");
        }

        request.setAttribute("specializations", specializations);
        RequestDispatcher dispatcher = request.getRequestDispatcher("add_doctor.jsp");
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
        String specialization = request.getParameter("specialization");
        String specialization2 = request.getParameter("specialization2");
        String licenseNumber = request.getParameter("licenseNumber");
        String licenseExpiryDate = request.getParameter("licenseExpiryDate");
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

            String uniqueFileName = "doc_" + username + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            profilePicPath = (UPLOAD_DIR + File.separator + uniqueFileName).replace(File.separator, "/");
        }
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert into users table
            String userSql = "INSERT INTO users (username, password, contact_number, user_type, status) VALUES (?, ?, ?, ?, ?)";
            int newDoctorId = -1;
            try (PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, username);
                userPs.setString(2, hashedPassword);
                userPs.setString(3, contactNumber);
                userPs.setString(4, "Doctor");
                userPs.setString(5, "active"); // Set the status
                userPs.executeUpdate();

                try (ResultSet generatedKeys = userPs.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newDoctorId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating doctor user failed, no ID obtained.");
                    }
                }
            }

            // 2. Insert into user_profiles table
            String profileSql = "INSERT INTO user_profiles (user_id, surname, given_name, middle_name, date_of_birth, age, gender, permanent_address, current_address, city, postal_code, specialization, secondary_specialization, license_number, license_expiry_date, profile_picture_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement profilePs = conn.prepareStatement(profileSql)) {
                profilePs.setInt(1, newDoctorId);
                profilePs.setString(2, request.getParameter("surname"));
                profilePs.setString(3, request.getParameter("givenName"));
                profilePs.setString(4, request.getParameter("middleName"));
                profilePs.setDate(5, Date.valueOf(request.getParameter("dateOfBirth")));
                profilePs.setInt(6, age);
                profilePs.setString(7, request.getParameter("gender"));
                profilePs.setString(8, request.getParameter("permanentAddress"));
                profilePs.setString(9, request.getParameter("currentAddress")); // This was already correct
                profilePs.setString(10, request.getParameter("city"));
                profilePs.setString(11, request.getParameter("postalCode"));
                profilePs.setString(12, specialization);
                if (specialization2 != null && !specialization2.isEmpty()) {
                    profilePs.setString(13, specialization2);
                } else {
                    profilePs.setNull(13, java.sql.Types.VARCHAR);
                }
                profilePs.setString(14, licenseNumber);
                profilePs.setDate(15, Date.valueOf(licenseExpiryDate));

                if (profilePicPath != null) {
                    profilePs.setString(16, profilePicPath);
                } else {
                    profilePs.setNull(16, java.sql.Types.VARCHAR);
                }
                profilePs.executeUpdate();
            }

            conn.commit();

            // 3. Send SMS notification to the new doctor
            try {
                String message = String.format(
                    "Welcome to AMH OPD. You are registered as a Doctor. Username: %s, Password: %s.",
                    username,
                    generatedPassword
                );
                SmsService.sendSms(contactNumber, message);
            } catch (Exception e) {
                session.setAttribute("successMessage", "Doctor created, but SMS notification failed.");
                session.setAttribute("errorMessage", "SMS Error: " + e.getMessage());
                System.err.println("SMS notification failed for new doctor " + username + ": " + e.getMessage());
                response.sendRedirect("AddDoctorServlet");
                return;
            }

            AuditLogger.log(adminId, adminUsername, "Admin", "Created new doctor account: " + username);
            session.setAttribute("successMessage", "New doctor account created successfully and notification sent.");
            response.sendRedirect("AddDoctorServlet");

        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getSQLState().equals("23000")) { // Duplicate entry
                session.setAttribute("errorMessage", "Username, contact number, or license number already exists.");
            } else {
                session.setAttribute("errorMessage", "Database error during doctor creation.");
            }
            response.sendRedirect("AddDoctorServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect("AddDoctorServlet");
        }
    }
}