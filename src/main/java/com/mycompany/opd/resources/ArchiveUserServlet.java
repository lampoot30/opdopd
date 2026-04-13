package com.mycompany.opd.resources;

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

@WebServlet("/archive-user")
public class ArchiveUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        try {
            int userIdToArchive = Integer.parseInt(request.getParameter("userId"));
            int adminUserId = (int) session.getAttribute("userId");
            String adminUsername = (String) session.getAttribute("username");

            // Prevent an admin from archiving themselves
            if (userIdToArchive == adminUserId) {
                response.sendRedirect("manage-users?error=You cannot archive your own account.");
                return;
            }

            String sql = "UPDATE users SET status = 'inactive' WHERE user_id = ?";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userIdToArchive);
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    AuditLogger.log(adminUserId, adminUsername, "Admin", "Archived user account with ID: " + userIdToArchive);
                    response.sendRedirect("manage-users?success=User has been archived successfully.");
                } else {
                    response.sendRedirect("manage-users?error=Could not archive user. They may already be archived or do not exist.");
                }
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage-users?error=An error occurred while archiving the user.");
        }
    }
}