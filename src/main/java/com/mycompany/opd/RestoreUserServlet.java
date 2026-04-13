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

@WebServlet("/restore-user")
public class RestoreUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        int userIdToRestore = Integer.parseInt(request.getParameter("userId"));
        int superAdminId = (int) session.getAttribute("userId");
        String superAdminUsername = (String) session.getAttribute("displayUsername");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE users SET status = 'active' WHERE user_id = ? AND status = 'inactive'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userIdToRestore);
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    AuditLogger.log(superAdminId, superAdminUsername, "Super Admin", "Restored user with ID: " + userIdToRestore);
                    response.sendRedirect("manage-archive?success=User restored successfully.");
                } else {
                    response.sendRedirect("manage-archive?error=User not found in archive or could not be restored.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage-archive?error=Database error while restoring user.");
        }
    }
}