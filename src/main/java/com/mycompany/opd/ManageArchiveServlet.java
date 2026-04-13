package com.mycompany.opd;

import com.mycompany.opd.models.User;
import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/manage-archive")
public class ManageArchiveServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> archivedUsers = new ArrayList<>();
        String sql = "SELECT user_id, username, user_type, contact_number, updated_at FROM users WHERE status = 'inactive' ORDER BY updated_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setUserType(rs.getString("user_type"));
                user.setContactNumber(rs.getString("contact_number"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                archivedUsers.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load archived users from the database.");
        }

        request.setAttribute("archivedUsers", archivedUsers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manage_archive.jsp");
        dispatcher.forward(request, response);
    }
}