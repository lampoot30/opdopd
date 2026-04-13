package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "ArchiveStaffAccountServlet", urlPatterns = {"/archive-staff-account"})
public class ArchiveStaffAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String redirectURL = request.getContextPath() + "/archive_staff.jsp";

        try {
            int userId = Integer.parseInt(userIdStr);
            String sql = "UPDATE users SET status = 'inactive' WHERE user_id = ?";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    response.sendRedirect(redirectURL + "?success=Staff account archived successfully.");
                } else {
                    response.sendRedirect(redirectURL + "?error=Failed to archive staff account. User not found.");
                }
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(redirectURL + "?error=Invalid user ID.");
        }
    }
}
