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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patient-dashboard")
public class PatientDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Patient".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=User ID not found");
            return;
        }

        List<Appointment> futureAppointments = new ArrayList<>();

        // Fetch future appointments for the patient
        String sql = "SELECT a.*, CONCAT(up.given_name, ' ', up.surname) AS assigned_doctor_name, r.room_name AS assigned_room_name " +
                     "FROM appointments a " +
                     "LEFT JOIN user_profiles up ON a.assigned_doctor_id = up.user_id " +
                     "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                     "WHERE a.booked_by_user_id = ? AND a.preferred_date >= CURDATE() AND a.status IN ('Accepted', 'Assigned') " +
                     "ORDER BY a.preferred_date ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setAppointmentId(rs.getInt("appointment_id"));
                    appt.setPatientType(rs.getString("patient_type"));
                    appt.setLastName(rs.getString("last_name"));
                    appt.setGivenName(rs.getString("given_name"));
                    appt.setMiddleName(rs.getString("middle_name"));
                    appt.setPreferredDate(rs.getDate("preferred_date"));
                    appt.setReasonForVisit(rs.getString("reason_for_visit"));
                    appt.setServicesClinic(rs.getString("service_name"));
                    appt.setAttachmentPath(rs.getString("attachment_path"));
                    appt.setStatus(rs.getString("status"));
                    appt.setCreatedAt(rs.getTimestamp("created_at"));
                    appt.setAssignedDoctorName(rs.getString("assigned_doctor_name"));
                    appt.setAssignedRoomName(rs.getString("assigned_room_name"));
                    futureAppointments.add(appt);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load future appointments.");
        }

        request.setAttribute("appointments", futureAppointments);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/patient_dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
