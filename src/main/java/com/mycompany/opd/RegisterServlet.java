package com.mycompany.opd;

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
import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/RegisterServlet")
@MultipartConfig
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contactNumber = request.getParameter("contactNumber");
        String username = request.getParameter("username");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        // --- Server-side validation for contact number format ---
        String contactNumberPattern = "^(09|\\+639)\\d{9}$";
        if (!contactNumber.matches(contactNumberPattern)) {
            response.sendRedirect("register.jsp?error=Invalid contact number format. Please use 09xxxxxxxxx or +639xxxxxxxxx.");
            return;
        }

        // --- Server-side validation for date of birth ---
        LocalDate dob = LocalDate.parse(dateOfBirthStr);
        if (dob.isAfter(LocalDate.now())) {
            response.sendRedirect("register.jsp?error=Date of birth cannot be in the future.");
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(request.getParameter("password"));

        // --- Handle File Upload ---
        Part filePart = request.getPart("profile_picture");
        String fileName = filePart.getSubmittedFileName();
        String profilePicPath = null;

        if (fileName != null && !fileName.isEmpty()) {
            // Define the upload directory relative to the web application root
            String uploadDirRelative = "uploads" + File.separator + "profile_pictures";
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + uploadDirRelative;

            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Create a unique file name to prevent overwriting
            String usernameForFile = username.replaceAll("[^a-zA-Z0-9.-]", "_");
            String uniqueFileName = usernameForFile + "_" + System.currentTimeMillis() + "_" + fileName;
            
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            
            // Store the relative path to be saved in the database
            profilePicPath = uploadDirRelative + File.separator + uniqueFileName;
            profilePicPath = (uploadDirRelative + File.separator + uniqueFileName).replace(File.separator, "/");
        }

        // Use try-with-resources to ensure the connection is always closed
        try (Connection conn = DBUtil.getConnection()) {
            // Check for duplicate username or contact number before proceeding
            String checkSql = "SELECT user_id FROM users WHERE username = ? OR contact_number = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setString(1, username);
                ps.setString(2, contactNumber);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect("register.jsp?error=Username or contact number already exists.");
                        return;
                    }
                }
            }

            // Store data in session and send OTP
            HttpSession session = request.getSession();

            // --- OTP Rate Limiting ---
            Long lastOtpTime = (Long) session.getAttribute("lastOtpTime");
            long currentTime = System.currentTimeMillis();
            long fiveMinutesInMillis = 5 * 60 * 1000;

            if (lastOtpTime != null && (currentTime - lastOtpTime < fiveMinutesInMillis)) {
                long timeLeftSeconds = (fiveMinutesInMillis - (currentTime - lastOtpTime)) / 1000;
                String errorMessage = String.format("Please wait %d minutes and %d seconds before requesting a new OTP.", timeLeftSeconds / 60, timeLeftSeconds % 60);
                response.sendRedirect("register.jsp?error=" + errorMessage);
                return;
            }

            storeRegistrationDataInSession(session, request, hashedPassword, profilePicPath, dob);

            OtpService.generateAndSendOtp(session, contactNumber);
            session.setAttribute("lastOtpTime", currentTime); // Set the new timestamp

            response.sendRedirect("verify_registration_otp.jsp");

        } catch (SQLException e) {
            e.printStackTrace(); // Log the full error for debugging
            response.sendRedirect("register.jsp?error=Database error during validation.");
        } catch (Exception e) {
            // Catch other potential errors, like a bad date format
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Invalid data submitted. Please check all fields.");
        }
    }

    private void storeRegistrationDataInSession(HttpSession session, HttpServletRequest request, String hashedPassword, String profilePicPath, LocalDate dob) {
        Map<String, Object> registrationData = new HashMap<>();

        // Calculate age on the server for data integrity
        int age = Period.between(dob, LocalDate.now()).getYears();

        registrationData.put("username", request.getParameter("username"));
        registrationData.put("hashedPassword", hashedPassword);
        registrationData.put("contactNumber", request.getParameter("contactNumber"));
        registrationData.put("surname", request.getParameter("surname"));
        registrationData.put("givenName", request.getParameter("givenName"));
        registrationData.put("middleName", request.getParameter("middleName"));
        registrationData.put("dateOfBirth", dob.toString());
        registrationData.put("gender", request.getParameter("gender"));
        registrationData.put("age", age);
        registrationData.put("religion", request.getParameter("religion"));
        registrationData.put("permanentAddress", request.getParameter("permanentAddress"));
        registrationData.put("currentAddress", request.getParameter("currentAddress"));
        registrationData.put("city", request.getParameter("city"));
        registrationData.put("postalCode", request.getParameter("postalCode"));
        registrationData.put("userType", "Patient"); // Set the user type to Patient
        registrationData.put("profilePicPath", profilePicPath); // Can be null

        session.setAttribute("registrationData", registrationData);
    }
}