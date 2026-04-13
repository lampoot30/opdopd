package com.mycompany.opd;

import com.mycompany.opd.models.Doctor;
import com.mycompany.opd.models.User;
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

@WebServlet("/edit-doctor-profile")
public class EditDoctorProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM users u JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ? AND u.user_type = 'Doctor'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setContactNumber(rs.getString("contact_number"));

                        Doctor doctor = new Doctor();
                        doctor.setDoctorId(rs.getInt("profile_id"));
                        doctor.setSurname(rs.getString("surname"));
                        doctor.setGivenName(rs.getString("given_name"));
                        doctor.setMiddleName(rs.getString("middle_name"));
                        doctor.setDateOfBirth(rs.getDate("date_of_birth"));
                        doctor.setGender(rs.getString("gender"));
                        doctor.setAddress(rs.getString("permanent_address"));
                        doctor.setSpecialization(rs.getString("specialization"));
                        doctor.setLicenseNumber(rs.getString("license_number"));
                        doctor.setLicenseExpiryDate(rs.getDate("license_expiry_date"));
                        doctor.setProfilePicturePath(rs.getString("profile_picture_path"));
                        
                        request.setAttribute("user", user);
                        request.setAttribute("doctor", doctor);
                    } else {
                        throw new ServletException("Doctor profile not found for user ID: " + userId);
                    }
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/edit_doctor_profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor-dashboard?error=Could not load profile for editing.");
        }
    }
}