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

@WebServlet("/staff-view-appointment-details")
public class StaffViewAppointmentDetailsServlet extends HttpServlet {

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

        try (Connection conn = DBUtil.getConnection()) {
            // Fetch appointment details with assigned doctor and room
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
                        appointment.setCreatedAt(rs.getTimestamp("created_at"));
                        appointment.setBookedByUserId(rs.getInt("booked_by_user_id")); // Add this line
                        appointment.setServicesClinic(rs.getString("service_name"));
                        appointment.setAttachmentPath(rs.getString("attachment_path"));
                    } else {
                        response.sendRedirect("staff-patient-records?error=Appointment not found.");
                        return;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load appointment details.");
        }

        request.setAttribute("appointment", appointment);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/staff_view_appointment_details.jsp");
        dispatcher.forward(request, response);
    }
}
