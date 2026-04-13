package com.mycompany.opd;

import com.google.gson.Gson;
import com.mycompany.opd.resources.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("getTodaysCompletedCount".equals(action)) {
            getTodaysCompletedCount(response);
        } else {
            loadDashboard(request, response);
        }
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> adminList = new ArrayList<>();
        String sql = "SELECT user_id, username, contact_number, status, created_at FROM users WHERE user_type = 'Admin' AND status = 'active'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> admin = new HashMap<>();
                admin.put("userId", rs.getInt("user_id"));
                admin.put("username", rs.getString("username"));
                admin.put("contactNumber", rs.getString("contact_number"));
                admin.put("status", rs.getString("status"));
                admin.put("createdAt", rs.getTimestamp("created_at"));
                adminList.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle error appropriately
        }

        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }

    private void getTodaysCompletedCount(HttpServletResponse response) throws IOException {
        int completedCount = 0;
        String sql = "SELECT COUNT(*) as count FROM appointments WHERE status = 'Completed' AND DATE(appointment_date) = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    completedCount = rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error fetching appointment count.");
            return;
        }

        Map<String, Integer> data = new HashMap<>();
        data.put("completedCount", completedCount);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(data));
    }
}