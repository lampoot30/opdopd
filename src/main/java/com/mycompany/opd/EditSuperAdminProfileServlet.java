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

@WebServlet("/edit-super-admin-profile")
public class EditSuperAdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT u.user_id, u.username, u.contact_number, " +
                        "up.profile_id, up.surname, up.given_name, up.middle_name, up.date_of_birth, up.gender, " +
                        "up.permanent_address, up.current_address, up.city, up.postal_code, up.profile_picture_path " +
                        "FROM users u LEFT JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id")); // from users table
                        user.setUsername(rs.getString("username")); // from users table
                        user.setContactNumber(rs.getString("contact_number")); // from users table

                        AdminProfile adminProfile = new AdminProfile();
                        if (rs.getObject("profile_id") != null) {
                            adminProfile.setAdminProfileId(rs.getInt("profile_id")); // from user_profiles table
                            adminProfile.setSurname(rs.getString("surname")); // from user_profiles table
                            adminProfile.setGivenName(rs.getString("given_name")); // from user_profiles table
                            adminProfile.setMiddleName(rs.getString("middle_name")); // from user_profiles table
                            adminProfile.setDateOfBirth(rs.getDate("date_of_birth")); // from user_profiles table
                            adminProfile.setGender(rs.getString("gender")); // from user_profiles table
                            adminProfile.setAddress(rs.getString("permanent_address")); // from user_profiles table
                            adminProfile.setProfilePicturePath(rs.getString("profile_picture_path")); // from user_profiles table
                            
                            // Pass other address fields as separate request attributes
                            request.setAttribute("currentAddress", rs.getString("current_address"));
                            request.setAttribute("city", rs.getString("city"));
                            request.setAttribute("postalCode", rs.getString("postal_code"));
                        }
                        request.setAttribute("user", user);
                        request.setAttribute("adminProfile", adminProfile);
                    } else {
                        throw new ServletException("Super Admin profile not found for user ID: " + userId);
                    }
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/edit_super_admin_profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/super-admin-profile?error=Could not load profile for editing.");
        }
    }
}
