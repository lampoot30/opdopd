package com.mycompany.opd;

import com.mycompany.opd.models.Appointment;
import com.mycompany.opd.models.Notification;
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

@WebServlet("/staff-dashboard")
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Staff".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        List<Appointment> pendingAppointments = new ArrayList<>();
        List<Notification> notifications = new ArrayList<>();

        // Fetch pending appointments
        String sql = "SELECT * FROM appointments WHERE status = 'Pending' ORDER BY preferred_date ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
                pendingAppointments.add(appt);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load pending appointments.");
        }
        
        // Fetch unread notifications for staff
        String notificationSql = "SELECT * FROM notifications WHERE user_type_target = 'Staff' AND is_read = FALSE ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(notificationSql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Notification notif = new Notification();
                notif.setNotificationId(rs.getInt("notification_id"));
                notif.setMessage(rs.getString("message"));
                notifications.add(notif);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Don't overwrite the main error message if it exists
            if (request.getAttribute("error") == null) {
                request.setAttribute("error", "Failed to load notifications.");
            }
        }

        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("notifications", notifications);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/staff_dashboard.jsp");
        dispatcher.forward(request, response);
    }
}