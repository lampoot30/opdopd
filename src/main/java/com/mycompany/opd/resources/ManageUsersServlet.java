package com.mycompany.opd.resources;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/manage-users")
public class ManageUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied.");
            return;
        }

        List<Map<String, Object>> userList = new ArrayList<>();

        String sql = "SELECT u.user_id, u.username, u.user_type, up.surname, up.given_name, up.profile_picture_path " +
                     "FROM users u JOIN user_profiles up ON u.user_id = up.user_id " +
                     "WHERE u.status = 'active' AND u.user_type IN ('Doctor', 'Staff', 'Patient') " +
                     "ORDER BY u.user_type, up.surname, up.given_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("userType", rs.getString("user_type"));
                user.put("surname", rs.getString("surname"));
                user.put("givenName", rs.getString("given_name"));
                user.put("profilePicturePath", rs.getString("profile_picture_path"));
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load user accounts.");
        }

        request.setAttribute("userList", userList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manage_users.jsp");
        dispatcher.forward(request, response);
    }
}