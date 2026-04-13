package com.mycompany.opd;

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

@WebServlet("/edit-room")
public class EditRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Staff".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String roomNumber = request.getParameter("roomNumber");
        String roomName = request.getParameter("roomName");
        String sql = "UPDATE rooms SET room_number = ?, room_name = ? WHERE room_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ps.setString(2, roomName);
            ps.setInt(3, roomId);
            ps.executeUpdate();
            response.sendRedirect("manage-rooms?success=Room updated successfully!");
        } catch (SQLException e) {
            if (e.getSQLState().equals("23000")) {
                response.sendRedirect("manage-rooms?error=A room with that number already exists.");
            } else {
                e.printStackTrace();
                response.sendRedirect("manage-rooms?error=Database error while updating room.");
            }
        }
    }
}