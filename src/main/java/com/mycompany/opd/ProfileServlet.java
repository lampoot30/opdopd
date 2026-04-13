package com.mycompany.opd;

import com.mycompany.opd.models.Patient;
import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String contextPath = request.getContextPath();
        
        int userId = (int) session.getAttribute("userId");
        Patient patient = new Patient();

        try (Connection conn = DBUtil.getConnection()) {
            // The SecurityFilter handles access, so we just need to fetch the profile.
            // This query joins users and user_profiles to get all patient information.
            String sql = "SELECT * FROM users u JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Populate the patient bean
                        patient.setUserId(userId);
                        patient.setUsername(rs.getString("username")); // from users table
                        patient.setContactNumber(rs.getString("contact_number")); // from users table
                        patient.setCreatedAt(rs.getTimestamp("created_at")); // from users table
                        patient.setPatientId(rs.getInt("profile_id")); // from user_profiles table
                        patient.setSurname(rs.getString("surname")); // from user_profiles table
                        patient.setGivenName(rs.getString("given_name")); // from user_profiles table
                        patient.setMiddleName(rs.getString("middle_name")); // from user_profiles table
                        patient.setDateOfBirth(rs.getDate("date_of_birth")); // from user_profiles table
                        patient.setGender(rs.getString("gender")); // from user_profiles table
                        patient.setPermanentAddress(rs.getString("permanent_address"));
                        patient.setCurrentAddress(rs.getString("current_address"));
                        patient.setCity(rs.getString("city"));
                        patient.setPostalCode(rs.getString("postal_code"));
                        patient.setProfilePicturePath(rs.getString("profile_picture_path")); // from user_profiles table
                    }
                }
            }

            // Set the patient bean as a request attribute
            request.setAttribute("patient", patient);

            // Forward to the JSP for display
            RequestDispatcher dispatcher = request.getRequestDispatcher("/patient_profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions, maybe forward to an error page
            response.sendRedirect(request.getContextPath() + "/patient_dashboard.jsp?error=Could not load profile.");
        }
    }
}