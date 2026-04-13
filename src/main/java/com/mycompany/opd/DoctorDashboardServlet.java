package com.mycompany.opd;

import com.mycompany.opd.models.Appointment;
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
import java.util.List;

@WebServlet("/doctor-dashboard")
public class DoctorDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        int doctorUserId = (int) session.getAttribute("userId");
        List<Appointment> todayAppointments = new ArrayList<>();
        List<Appointment> futureAppointments = new ArrayList<>();

        String todaySql = "SELECT a.appointment_id, a.given_name, a.last_name, a.reason_for_visit, r.room_name " +
                          "FROM appointments a " +
                          "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                          "WHERE a.assigned_doctor_id = ? AND a.preferred_date = CURDATE() AND a.status IN ('Accepted', 'Assigned') " +
                          "ORDER BY a.appointment_id ASC";

        String futureSql = "SELECT a.appointment_id, a.given_name, a.last_name, a.reason_for_visit, a.preferred_date, r.room_name " +
                           "FROM appointments a " +
                           "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                           "WHERE a.assigned_doctor_id = ? AND a.preferred_date > CURDATE() AND a.status IN ('Accepted', 'Assigned') " +
                           "ORDER BY a.preferred_date ASC";

        try (Connection conn = DBUtil.getConnection()) {
            // Fetch today's appointments
            try (PreparedStatement ps = conn.prepareStatement(todaySql)) {
                ps.setInt(1, doctorUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Appointment appt = new Appointment();
                        appt.setAppointmentId(rs.getInt("appointment_id"));
                        appt.setGivenName(rs.getString("given_name"));
                        appt.setLastName(rs.getString("last_name"));
                        appt.setReasonForVisit(rs.getString("reason_for_visit"));
                        appt.setRoomName(rs.getString("room_name"));
                        todayAppointments.add(appt);
                    }
                }
            }

            // Fetch future appointments
            try (PreparedStatement ps = conn.prepareStatement(futureSql)) {
                ps.setInt(1, doctorUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Appointment appt = new Appointment();
                        appt.setAppointmentId(rs.getInt("appointment_id"));
                        appt.setGivenName(rs.getString("given_name"));
                        appt.setLastName(rs.getString("last_name"));
                        appt.setReasonForVisit(rs.getString("reason_for_visit"));
                        appt.setPreferredDate(rs.getDate("preferred_date"));
                        appt.setRoomName(rs.getString("room_name"));
                        futureAppointments.add(appt);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error while fetching appointments.");
        }

        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("futureAppointments", futureAppointments);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor_dashboard.jsp");
        dispatcher.forward(request, response);
    }
}