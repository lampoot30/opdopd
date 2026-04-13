package com.mycompany.opd;

import com.mycompany.opd.models.AdminProfile;
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
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.Period;

@WebServlet("/admin-profile")
public class AdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login if session is not valid or user is not logged in.
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please log in to view your profile.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = new User();
        AdminProfile adminProfile = new AdminProfile();

        try {
            String sql = "SELECT * FROM users u LEFT JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Populate User object
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setContactNumber(rs.getString("contact_number"));

                        // Populate AdminProfile object
                        adminProfile.setAdminProfileId(rs.getInt("profile_id"));
                        adminProfile.setSurname(rs.getString("surname"));
                        adminProfile.setGivenName(rs.getString("given_name"));
                        adminProfile.setMiddleName(rs.getString("middle_name"));
                        Date dateOfBirth = rs.getDate("date_of_birth");
                        adminProfile.setDateOfBirth(dateOfBirth);

                        // Calculate and set age
                        if (dateOfBirth != null) {
                            LocalDate dob = dateOfBirth.toLocalDate();
                            int age = Period.between(dob, LocalDate.now()).getYears();
                            adminProfile.setAge(age);
                        }
                        adminProfile.setGender(rs.getString("gender"));
                        adminProfile.setAddress(rs.getString("permanent_address"));
                        adminProfile.setProfilePicturePath(rs.getString("profile_picture_path"));
                        // Ensure a default picture is set if none exists
                        if (adminProfile.getProfilePicturePath() == null || adminProfile.getProfilePicturePath().isEmpty()) {
                            adminProfile.setProfilePicturePath("uploads/profile_pictures/default_avatar.png");
                        }
                        
                        // Pass the other address fields as separate attributes
                        request.setAttribute("currentAddress", rs.getString("current_address"));
                        request.setAttribute("city", rs.getString("city"));
                        request.setAttribute("postalCode", rs.getString("postal_code"));
                    } else {
                        throw new ServletException("Admin profile not found for user ID: " + userId);
                    }
                }
            }

            request.setAttribute("user", user);
            request.setAttribute("adminProfile", adminProfile);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_profile.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
           e.printStackTrace();
            String dashboardUrl = "/analytics-overview";
            response.sendRedirect(request.getContextPath() + dashboardUrl + "?error=Could not load profile.");
        }
    }
}