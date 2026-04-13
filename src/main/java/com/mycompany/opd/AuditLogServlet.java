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

@WebServlet("/audit-logs")
public class AuditLogServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        List<AuditLog> myLogs = new ArrayList<>();
        String superAdminUsername = (String) session.getAttribute("displayUsername");
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int totalRecords = 0;

        try (Connection conn = DBUtil.getConnection()) {
            // For Super Admin, show all audit logs
            String countSql = "SELECT COUNT(*) FROM audit_logs";
            try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalRecords = rs.getInt(1);
                    }
                }
            }

            // Then, fetch all logs for the current page
            String myLogsSql = "SELECT * FROM audit_logs ORDER BY timestamp DESC LIMIT ? OFFSET ?";
            try (PreparedStatement ps = conn.prepareStatement(myLogsSql)) {
                ps.setInt(1, RECORDS_PER_PAGE);
                ps.setInt(2, (currentPage - 1) * RECORDS_PER_PAGE);
                myLogs = executeQuery(ps); // Using your existing helper method
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load audit logs.");
        }
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);
        request.setAttribute("myLogs", myLogs);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/audit_logs.jsp");
        dispatcher.forward(request, response);
    }

    private List<AuditLog> executeQuery(PreparedStatement ps) throws Exception {
        List<AuditLog> logs = new ArrayList<>();
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setUsername(rs.getString("username"));
                log.setUserType(rs.getString("user_type"));
                log.setAction(rs.getString("action"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                logs.add(log);
            }
        }
        return logs;
    }
}