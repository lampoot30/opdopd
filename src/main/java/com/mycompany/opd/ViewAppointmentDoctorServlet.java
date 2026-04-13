package com.mycompany.opd;

import com.mycompany.opd.models.Appointment;
import com.mycompany.opd.models.Room;
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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/view-appointment-doctor")
public class ViewAppointmentDoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Robust check for session and userId. SecurityFilter should handle most cases, but this adds a layer of defense.
        if (session == null || session.getAttribute("userId") == null || !"Doctor".equals(session.getAttribute("userType"))) {
            // Log this unexpected state if it happens, as SecurityFilter should ideally prevent it.
            getServletContext().log("ViewAppointmentDoctorServlet: Access denied or missing userId. Session ID: " + (session != null ? session.getId() : "null") + ", UserType: " + (session != null ? session.getAttribute("userType") : "null") + ", UserId: " + (session != null ? session.getAttribute("userId") : "null"));
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session expired or unauthorized access.");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            int doctorUserId = (int) session.getAttribute("userId");

            Appointment appointment = null;
            Room room = null;

            try (Connection conn = DBUtil.getConnection()) {
                // 1. Fetch Appointment Details
                String apptSql = "SELECT a.*, " +
                                 "up.given_name AS patient_given_name, up.surname AS patient_last_name, " +
                                 "up.date_of_birth AS patient_dob, up.gender, up.permanent_address, u.contact_number AS patient_contact_number " +
                                 "FROM appointments a " +
                                 "LEFT JOIN user_profiles up ON a.booked_by_user_id = up.user_id " +
                                 "LEFT JOIN users u ON a.booked_by_user_id = u.user_id " +
                                 "WHERE a.appointment_id = ? AND a.assigned_doctor_id = ?";

                try (PreparedStatement ps = conn.prepareStatement(apptSql)) {
                    ps.setInt(1, appointmentId);
                    ps.setInt(2, doctorUserId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            appointment = new Appointment();
                            appointment.setAppointmentId(rs.getInt("appointment_id"));
                            appointment.setPatientType(rs.getString("patient_type"));
                            appointment.setMiddleName(rs.getString("middle_name"));
                            appointment.setGivenName(rs.getString("patient_given_name") != null ? rs.getString("patient_given_name") : rs.getString("given_name"));
                            appointment.setLastName(rs.getString("patient_last_name") != null ? rs.getString("patient_last_name") : rs.getString("last_name"));
                            appointment.setReasonForVisit(rs.getString("reason_for_visit"));
                            appointment.setStatus(rs.getString("status"));
                            appointment.setPreferredDate(rs.getDate("preferred_date"));
                            appointment.setCreatedAt(rs.getTimestamp("created_at"));

                            // Patient details from LEFT JOIN
                            Integer bookedByUserId = rs.getObject("booked_by_user_id", Integer.class);
                            appointment.setBookedByUserId(bookedByUserId != null ? bookedByUserId : 0);
                            // Set birthday from appointment (input from book appointment)
                            java.sql.Date birthday = rs.getDate("birthday");
                            appointment.setBirthday(birthday);
                            // Set date of birth from appointment birthday (input from book appointment), fallback to user profile DOB
                            java.sql.Date dob = birthday;
                            if (dob == null) {
                                dob = rs.getDate("patient_dob");
                            }
                            appointment.setPatientDateOfBirth(dob);
                            appointment.setPatientGender(rs.getString("gender"));
                            appointment.setPatientAddress(rs.getString("permanent_address"));
                            appointment.setPatientContactNumber(rs.getString("patient_contact_number"));

                            // Fetch room details if assigned_room_id is present
                            Integer assignedRoomId = rs.getObject("assigned_room_id", Integer.class);
                            if (assignedRoomId != null) {
                                String roomSql = "SELECT room_number, room_name FROM rooms WHERE room_id = ?";
                                try (PreparedStatement roomPs = conn.prepareStatement(roomSql)) {
                                    roomPs.setInt(1, assignedRoomId);
                                    try (ResultSet roomRs = roomPs.executeQuery()) {
                                        if (roomRs.next()) {
                                            room = new Room();
                                            room.setRoomNumber(roomRs.getString("room_number"));
                                            room.setRoomName(roomRs.getString("room_name"));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (appointment == null) {
                   response.sendRedirect("doctor-dashboard?error=Appointment not found or you do not have access.");
                    return;
                }
            }

            // Add a flag to indicate if the appointment is in the future
            boolean isFutureAppointment = appointment.getPreferredDate().toLocalDate().isAfter(LocalDate.now());
            request.setAttribute("isFutureAppointment", isFutureAppointment);

            request.setAttribute("appointment", appointment);
            request.setAttribute("room", room);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view_appointment_doctor.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            getServletContext().log("Invalid appointment ID format received in ViewAppointmentDoctorServlet: " + request.getParameter("id"), e);
            response.sendRedirect("doctor-dashboard?error=Invalid appointment ID format.");
        } catch (java.sql.SQLException e) {
            getServletContext().log("Database error in ViewAppointmentDoctorServlet for appointment ID: " + request.getParameter("id") + " and doctor ID: " + session.getAttribute("userId"), e);
            response.sendRedirect("doctor-dashboard?error=A database error occurred while loading appointment details.");
        } catch (Exception e) {
            getServletContext().log("An unexpected error occurred in ViewAppointmentDoctorServlet for appointment ID: " + request.getParameter("id") + " and doctor ID: " + session.getAttribute("userId"), e);
            response.sendRedirect("doctor-dashboard?error=An unexpected error occurred while loading appointment details.");
        }
    }
}