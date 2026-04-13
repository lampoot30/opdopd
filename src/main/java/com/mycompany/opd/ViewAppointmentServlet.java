package com.mycompany.opd;

import com.mycompany.opd.models.Appointment;
import com.mycompany.opd.models.Doctor;
import com.mycompany.opd.models.Room;
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

@WebServlet("/view-appointment")
public class ViewAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is staff
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        if (!"Staff".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = new Appointment();
        List<Doctor> doctors = new ArrayList<>();
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // 1. Fetch appointment details
            String apptSql = "SELECT a.*, CONCAT(up.given_name, ' ', up.surname) AS assigned_doctor_name, r.room_number AS assigned_room_name " +
                             "FROM appointments a " +
                             "LEFT JOIN user_profiles up ON a.assigned_doctor_id = up.user_id " +
                             "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                             "WHERE a.appointment_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(apptSql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        appointment.setAppointmentId(rs.getInt("appointment_id"));
                        appointment.setPatientType(rs.getString("patient_type"));
                        appointment.setLastName(rs.getString("last_name"));
                        appointment.setGivenName(rs.getString("given_name"));
                        appointment.setMiddleName(rs.getString("middle_name"));
                        appointment.setPreferredDate(rs.getDate("preferred_date"));
                        appointment.setReasonForVisit(rs.getString("reason_for_visit"));
                        appointment.setStatus(rs.getString("status"));
                        appointment.setAssignedDoctorName(rs.getString("assigned_doctor_name"));
                        appointment.setAssignedRoomName(rs.getString("assigned_room_name"));
                    }
                }
            }

            // 2. Fetch all doctors
            String doctorsSql = "SELECT u.user_id, up.surname, up.given_name, up.specialization FROM users u JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_type = 'Doctor' ORDER BY up.surname, up.given_name";
            try (PreparedStatement ps = conn.prepareStatement(doctorsSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor doc = new Doctor();
                    doc.setDoctorId(rs.getInt("user_id")); // Using doctorId to store user_id for the model
                    doc.setSurname(rs.getString("surname"));
                    doc.setGivenName(rs.getString("given_name"));
                    doc.setSpecialization(rs.getString("specialization"));
                    doctors.add(doc);
                }
            }

            // 3. Fetch all rooms
            String roomsSql = "SELECT * FROM rooms ORDER BY room_number";
            try (PreparedStatement ps = conn.prepareStatement(roomsSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    rooms.add(room);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load appointment details.");
        }

        request.setAttribute("appointment", appointment);
        request.setAttribute("doctors", doctors);
        request.setAttribute("rooms", rooms);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/view_appointment.jsp");
        dispatcher.forward(request, response);
    }
}