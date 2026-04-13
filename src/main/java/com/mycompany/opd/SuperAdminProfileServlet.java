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

@WebServlet("/super-admin-profile")
public class SuperAdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        int userId = (int) session.getAttribute("userId");
        User user = new User();
        AdminProfile adminProfile = new AdminProfile();

        try {
            String sql = "SELECT * FROM users u LEFT JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_id = ? AND u.user_type = 'Super Admin'";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setContactNumber(rs.getString("contact_number"));

                        // Handle nullable profile fields
                        Integer profileId = (Integer) rs.getObject("profile_id");
                        if (profileId != null) {
                            adminProfile.setAdminProfileId(profileId);
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
                            
                            // Pass other address fields as separate request attributes
                            request.setAttribute("currentAddress", rs.getString("current_address"));
                            request.setAttribute("city", rs.getString("city"));
                            request.setAttribute("postalCode", rs.getString("postal_code"));

                            String profilePicPath = rs.getString("profile_picture_path");
                            if (profilePicPath == null || profilePicPath.isEmpty()) {
                                adminProfile.setProfilePicturePath("uploads/profile_pictures/default_avatar.png");
                                // update database to set default
                                try (Connection conn2 = DBUtil.getConnection();
                                     PreparedStatement ps2 = conn2.prepareStatement("UPDATE user_profiles SET profile_picture_path = ? WHERE user_id = ?")) {
                                    ps2.setString(1, "uploads/profile_pictures/default_avatar.png");
                                    ps2.setInt(2, userId);
                                    ps2.executeUpdate();
                                }
                            } else {
                                adminProfile.setProfilePicturePath(profilePicPath);
                            }
                        } else {
                            // Profile not found, set default values
                            adminProfile.setSurname("Super");
                            adminProfile.setGivenName("Admin");
                            adminProfile.setMiddleName("A");
                            adminProfile.setAddress("Hospital Main Office");
                            adminProfile.setProfilePicturePath("uploads/profile_pictures/default_avatar.png");
                        }
                    } else {
                        throw new ServletException("Super Admin user not found for user ID: " + userId);
                    }
                }
            }
            request.setAttribute("user", user);
            request.setAttribute("adminProfile", adminProfile);
            request.setAttribute("userType", "Super Admin");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/super_admin_profile.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/super_admin_dashboard.jsp?error=Could not load profile.");
        }
    }
}