package com.mycompany.opd;

import com.mycompany.opd.models.Room;
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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/manage-rooms")
public class ManageRoomsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_number ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomName(rs.getString("room_name"));
                rooms.add(room);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load rooms.");
        }

        request.setAttribute("rooms", rooms);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manage_rooms.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addRoom(request, response);
        } else {
            response.sendRedirect("manage-rooms?error=Invalid action.");
        }
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String roomNumber = request.getParameter("roomNumber");
        String roomName = request.getParameter("roomName");

        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            response.sendRedirect("manage-rooms?error=Room Number cannot be empty.");
            return;
        }

        String sql = "INSERT INTO rooms (room_number, room_name) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ps.setString(2, roomName);
            ps.executeUpdate();
            response.sendRedirect("manage-rooms?success=Room added successfully.");
        } catch (SQLException e) {
            if (e.getSQLState().equals("23000")) { // Unique constraint violation
                response.sendRedirect("manage-rooms?error=A room with that number already exists.");
            } else {
                e.printStackTrace();
                response.sendRedirect("manage-rooms?error=Database error occurred while adding room.");
            }
        }
    }
}