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
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/edit-admin-profile")
public class EditAdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM users u LEFT JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setContactNumber(rs.getString("contact_number"));

                        AdminProfile adminProfile = new AdminProfile();
                        // Check for null profile_id in case of a new profile
                        Integer profileId = (Integer) rs.getObject("profile_id");
                        if (profileId != null) {
                            adminProfile.setAdminProfileId(profileId);
                        }
                        adminProfile.setSurname(rs.getString("surname"));
                        adminProfile.setGivenName(rs.getString("given_name"));
                        adminProfile.setMiddleName(rs.getString("middle_name"));
                        adminProfile.setDateOfBirth(rs.getDate("date_of_birth"));
                        adminProfile.setGender(rs.getString("gender"));
                        adminProfile.setAddress(rs.getString("permanent_address"));
                        adminProfile.setProfilePicturePath(rs.getString("profile_picture_path")); // This can be null
                        
                        request.setAttribute("user", user);
                        request.setAttribute("adminProfile", adminProfile);
                    } else {
                        throw new ServletException("Admin profile not found for user ID: " + userId);
                    }
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/edit_admin_profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // If an error occurs, redirect the Admin back to their dashboard.
            String dashboardUrl = "/analytics-overview"; 
            response.sendRedirect(request.getContextPath() + dashboardUrl + "?error=Could not load profile for editing.");
        }
    }
}