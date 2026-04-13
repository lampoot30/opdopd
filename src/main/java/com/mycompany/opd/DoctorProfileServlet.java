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
import java.sql.SQLException;

@WebServlet("/doctor-profile")
public class DoctorProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session expired. Please log in again.");
            return;
        }

        Doctor doctor = null;
        User user = null;
        String sql = "SELECT up.*, u.username, u.contact_number FROM user_profiles up JOIN users u ON up.user_id = u.user_id WHERE up.user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(userId);
                    user.setUsername(rs.getString("username"));
                    user.setContactNumber(rs.getString("contact_number"));
                    doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("profile_id"));
                    doctor.setGivenName(rs.getString("given_name"));
                    doctor.setMiddleName(rs.getString("middle_name"));
                    doctor.setSurname(rs.getString("surname"));
                    doctor.setDateOfBirth(rs.getDate("date_of_birth"));
                    doctor.setAge(rs.getInt("age"));
                    doctor.setGender(rs.getString("gender"));
                    // The Doctor model has a general 'address' field, which we'll populate with the permanent address.
                    doctor.setAddress(rs.getString("permanent_address"));
                    doctor.setSpecialization(rs.getString("specialization"));
                    doctor.setLicenseNumber(rs.getString("license_number"));
                    doctor.setLicenseExpiryDate(rs.getDate("license_expiry_date"));
                    doctor.setProfilePicturePath(rs.getString("profile_picture_path"));
                    
                    // Pass new address fields separately as the model doesn't support them yet
                    request.setAttribute("currentAddress", rs.getString("current_address"));
                    request.setAttribute("city", rs.getString("city"));
                    request.setAttribute("postalCode", rs.getString("postal_code"));
                    // The JSP can access these directly from the 'doctor' object even without explicit setters in the model,
                    // as long as the model has corresponding getter methods.
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Redirect with a generic error if the database query fails
            response.sendRedirect(request.getContextPath() + "/doctor-dashboard?error=Could not load profile.");
            return;
        }

        request.setAttribute("doctor", doctor);
        request.setAttribute("user", user); // Pass user object for consistency

        RequestDispatcher dispatcher = request.getRequestDispatcher("doctor_profile.jsp");
        dispatcher.forward(request, response);
    }
}