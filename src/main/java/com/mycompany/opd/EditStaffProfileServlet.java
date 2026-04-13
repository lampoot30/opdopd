package com.mycompany.opd;

import com.mycompany.opd.models.StaffProfile;
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

@WebServlet("/edit-staff-profile")
public class EditStaffProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM users u JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ? AND u.user_type = 'Staff'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setContactNumber(rs.getString("contact_number"));

                        StaffProfile staffProfile = new StaffProfile();
                        staffProfile.setStaffProfileId(rs.getInt("profile_id"));
                        staffProfile.setSurname(rs.getString("surname"));
                        staffProfile.setGivenName(rs.getString("given_name"));
                        staffProfile.setMiddleName(rs.getString("middle_name"));
                        staffProfile.setDateOfBirth(rs.getDate("date_of_birth"));
                        staffProfile.setGender(rs.getString("gender"));
                        staffProfile.setAddress(rs.getString("permanent_address"));
                        staffProfile.setProfilePicturePath(rs.getString("profile_picture_path"));
                        staffProfile.setUser(user);

                        request.setAttribute("staffProfile", staffProfile);
                        // Pass new address fields separately as the model doesn't support them yet
                        request.setAttribute("currentAddress", rs.getString("current_address"));
                        request.setAttribute("city", rs.getString("city"));
                        request.setAttribute("postalCode", rs.getString("postal_code"));
                    } else {
                        throw new ServletException("Staff profile not found for user ID: " + userId);
                    }
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/edit_staff_profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff-dashboard?error=Could not load profile for editing.");
        }
    }
}