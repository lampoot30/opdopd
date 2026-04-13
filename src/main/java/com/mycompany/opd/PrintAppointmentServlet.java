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

@WebServlet("/print-appointment")
public class PrintAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            int userId = (int) session.getAttribute("userId");

            Appointment appointment = new Appointment();
            Doctor doctor = new Doctor();
            Room room = new Room();
            boolean appointmentFound = false;

            String sql = "SELECT a.*, up.surname AS doc_surname, up.given_name AS doc_given_name, up.specialization, r.room_number, r.room_name " +
                         "FROM appointments a " +
                         "LEFT JOIN user_profiles up ON a.assigned_doctor_id = up.user_id " +
                         "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                         "WHERE a.appointment_id = ? AND a.booked_by_user_id = ?";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, appointmentId);
                ps.setInt(2, userId); // Security check: ensure this appointment belongs to the logged-in user

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        appointmentFound = true;
                        // Populate Appointment object
                        appointment.setAppointmentId(rs.getInt("appointment_id"));
                        appointment.setPatientType(rs.getString("patient_type"));
                        appointment.setLastName(rs.getString("last_name"));
                        appointment.setGivenName(rs.getString("given_name"));
                        appointment.setMiddleName(rs.getString("middle_name"));
                        appointment.setPreferredDate(rs.getDate("preferred_date"));
                        appointment.setReasonForVisit(rs.getString("reason_for_visit"));
                        appointment.setStatus(rs.getString("status"));
                        
                        // Security/Logic check: Only allow printing for 'Accepted' appointments.
                        if (!"Accepted".equalsIgnoreCase(appointment.getStatus())) {
                            response.sendRedirect(request.getContextPath() + "/medical-records?error=Only accepted appointments can be printed.");
                            return;
                        }
                        
                        // Populate Doctor object
                        doctor.setSurname(rs.getString("doc_surname"));
                        doctor.setGivenName(rs.getString("doc_given_name"));
                        doctor.setSpecialization(rs.getString("specialization"));
                        
                        // Populate Room object
                        room.setRoomNumber(rs.getString("room_number"));
                        room.setRoomName(rs.getString("room_name"));
                    }
                }
            }

            if (appointmentFound) {
                request.setAttribute("appointment", appointment);
                request.setAttribute("doctor", doctor);
                request.setAttribute("room", room);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/print_appointment.jsp");
                dispatcher.forward(request, response);
            } else {
                // Appointment not found or does not belong to the user
                response.sendRedirect(request.getContextPath() + "/medical-records?error=Appointment not found.");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medical-records?error=Invalid appointment ID.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching appointment details.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/medical_records.jsp");
            dispatcher.forward(request, response);
        }
    }
}