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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/super-admin-dashboard")
public class SuperAdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied.");
            return;
        }

        List<AdminProfile> adminList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT u.user_id, u.username, u.contact_number, up.profile_id, up.surname, up.given_name, up.middle_name, up.profile_picture_path " +
                         "FROM users u " +
                         "JOIN user_profiles up ON u.user_id = up.user_id " +
                         "WHERE u.user_type = 'Admin' AND u.status = 'active' " +
                         "ORDER BY up.surname, up.given_name";
            
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setContactNumber(rs.getString("contact_number"));

                    AdminProfile admin = new AdminProfile();
                    admin.setAdminProfileId(rs.getInt("profile_id"));
                    admin.setUserId(rs.getInt("user_id"));
                    admin.setSurname(rs.getString("surname"));
                    admin.setGivenName(rs.getString("given_name"));
                    admin.setMiddleName(rs.getString("middle_name"));
                    admin.setProfilePicturePath(rs.getString("profile_picture_path"));
                    admin.setUser(user); // Set the User object within AdminProfile
                    
                    adminList.add(admin);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load admin accounts.");
        }

        request.setAttribute("adminList", adminList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/super_admin_dashboard.jsp");
        dispatcher.forward(request, response);
    }
}