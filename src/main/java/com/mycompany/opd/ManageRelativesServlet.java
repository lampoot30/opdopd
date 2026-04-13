package com.mycompany.opd;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/manage-relatives")
public class ManageRelativesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userType") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        // Load appointed relatives
        Integer userId = (Integer) session.getAttribute("userId");
        List<Map<String, Object>> appointedRelatives = new ArrayList<>();
        String relativesSql = "SELECT u.user_id, u.username, up.given_name, up.surname, up.profile_picture_path " +
                             "FROM appointed_relatives ar " +
                             "JOIN users u ON ar.relative_user_id = u.user_id " +
                             "JOIN user_profiles up ON u.user_id = up.user_id " +
                             "WHERE ar.patient_user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(relativesSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> relative = new HashMap<>();
                    relative.put("userId", rs.getInt("user_id"));
                    relative.put("username", rs.getString("username"));
                    relative.put("givenName", rs.getString("given_name"));
                    relative.put("surname", rs.getString("surname"));
                    relative.put("profilePicturePath", rs.getString("profile_picture_path"));
                    appointedRelatives.add(relative);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load appointed relatives.");
        }

        request.setAttribute("appointedRelatives", appointedRelatives);
        // Forward to the appoint_relatives.jsp page (reused for manage)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/appoint_relatives.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userType") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        String action = request.getParameter("action");
        Integer patientUserId = (Integer) session.getAttribute("userId");

        if ("remove".equals(action)) {
            // Handle removal
            int relativeUserId = Integer.parseInt(request.getParameter("relativeUserId"));

            String deleteSql = "DELETE FROM appointed_relatives WHERE patient_user_id = ? AND relative_user_id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, patientUserId);
                ps.setInt(2, relativeUserId);
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("manage-relatives?success=Relative removed successfully.");
                } else {
                    response.sendRedirect("manage-relatives?error=Failed to remove relative.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("manage-relatives?error=Database error during removal.");
            }
        } else {
            response.sendRedirect("manage-relatives?error=Invalid action.");
        }
    }
}
