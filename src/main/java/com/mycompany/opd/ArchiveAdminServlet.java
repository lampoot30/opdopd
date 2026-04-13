package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/archive-admin")
public class ArchiveAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        int userIdToDelete = Integer.parseInt(request.getParameter("userId"));
        int superAdminId = (int) session.getAttribute("userId");
        String superAdminUsername = (String) session.getAttribute("displayUsername");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE users SET status = 'inactive' WHERE user_id = ? AND user_type = 'Admin'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userIdToDelete);
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    AuditLogger.log(superAdminId, superAdminUsername, "Super Admin", "Archived Admin user with ID: " + userIdToDelete);
                    response.sendRedirect("admin-dashboard?success=Admin user has been archived.");
                } else {
                    response.sendRedirect("admin-dashboard?error=Admin user not found or could not be archived.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin-dashboard?error=Database error while archiving admin user.");
        }
    }
}