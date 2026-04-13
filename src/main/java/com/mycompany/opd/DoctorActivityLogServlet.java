package com.mycompany.opd;

import com.mycompany.opd.models.AuditLog;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/doctor-activity-logs")
public class DoctorActivityLogServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Security check is handled by SecurityFilter

        List<AuditLog> activityLogs = new ArrayList<>();
        String doctorUsername = (String) session.getAttribute("displayUsername");
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int totalRecords = 0;

        try (Connection conn = DBUtil.getConnection()) {
            String countSql = "SELECT COUNT(*) FROM audit_logs WHERE username = ?";
            try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                ps.setString(1, doctorUsername);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalRecords = rs.getInt(1);
                }
            }

            String sql = "SELECT * FROM audit_logs WHERE username = ? ORDER BY timestamp DESC LIMIT ? OFFSET ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, doctorUsername);
                ps.setInt(2, RECORDS_PER_PAGE);
                ps.setInt(3, (currentPage - 1) * RECORDS_PER_PAGE);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        AuditLog log = new AuditLog();
                        log.setAction(rs.getString("action"));
                        log.setTimestamp(rs.getTimestamp("timestamp"));
                        activityLogs.add(log);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load activity logs.");
        }
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

        request.setAttribute("activityLogs", activityLogs);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor_activity_logs.jsp");
        dispatcher.forward(request, response);
    }
}