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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/print-staff-appointment-details")
public class PrintStaffAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Staff".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        String appointmentIdStr = request.getParameter("appointmentId");
        if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
            response.sendRedirect("staff-dashboard?error=Missing appointment ID.");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("staff-dashboard?error=Invalid appointment ID.");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT a.*, d.given_name as doctor_given_name, d.surname as doctor_surname, r.room_name " +
                         "FROM appointments a " +
                         "LEFT JOIN user_profiles d ON a.assigned_doctor_id = d.user_id " +
                         "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                         "WHERE a.appointment_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        com.mycompany.opd.models.Appointment appointment = new com.mycompany.opd.models.Appointment();
                        appointment.setAppointmentId(rs.getInt("appointment_id"));
                        appointment.setGivenName(rs.getString("given_name"));
                        appointment.setMiddleName(rs.getString("middle_name"));
                        appointment.setLastName(rs.getString("last_name"));
                        appointment.setPatientType(rs.getString("patient_type"));
                        
                        Timestamp preferredDateTimestamp = rs.getTimestamp("preferred_date");
                        if (preferredDateTimestamp != null) {
                            appointment.setPreferredDate(new java.sql.Date(preferredDateTimestamp.getTime()));
                        }
                        appointment.setReasonForVisit(rs.getString("reason_for_visit"));
                        appointment.setServicesClinic(rs.getString("service_name"));
                        appointment.setStatus(rs.getString("status"));
                        appointment.setCreatedAt(rs.getTimestamp("created_at"));
                        appointment.setBookedByUserId(rs.getInt("booked_by_user_id"));
                        appointment.setAttachmentPath(rs.getString("attachment_path"));
                        appointment.setBirthday(rs.getDate("birthday"));
                        appointment.setPatientGender(rs.getString("gender"));
                        appointment.setPatientAddress(rs.getString("address"));
                        appointment.setPatientContactNumber(rs.getString("contact_number"));

                        String doctorName = rs.getString("doctor_given_name");
                        if (doctorName != null) {
                            doctorName += " " + rs.getString("doctor_surname");
                        }
                        appointment.setAssignedDoctorName(doctorName);
                        appointment.setAssignedRoomName(rs.getString("room_name"));

                        request.setAttribute("appointment", appointment);
                        request.getRequestDispatcher("/print_staff_appointment_details.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("staff-dashboard?error=Appointment not found.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("staff-dashboard?error=Database error.");
        }
    }
}
