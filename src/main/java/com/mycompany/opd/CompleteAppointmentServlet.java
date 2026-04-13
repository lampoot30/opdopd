package com.mycompany.opd;

import com.mycompany.opd.resources.AuditLogger;
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

@WebServlet("/complete-appointment")
public class CompleteAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String patientName = request.getParameter("patientName");
            int doctorUserId = (int) session.getAttribute("userId");
            String doctorUsername = (String) session.getAttribute("displayUsername");

            try (Connection conn = DBUtil.getConnection()) {
                conn.setAutoCommit(false); // Start transaction

                // 1. Update appointment status to 'Completed'
                String updateSql = "UPDATE appointments SET status = 'Completed' WHERE appointment_id = ? AND assigned_doctor_id = ? AND status = 'Assigned'";
                int rowsAffected;
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setInt(1, appointmentId);
                    psUpdate.setInt(2, doctorUserId);
                    rowsAffected = psUpdate.executeUpdate();
                }

                if (rowsAffected > 0) {
                    // 2. Create a notification for the staff
                    String notificationSql = "INSERT INTO notifications (user_type_target, message, link) VALUES ('Staff', ?, ?)";
                    try (PreparedStatement psNotify = conn.prepareStatement(notificationSql)) {
                        String message = "Appointment #" + appointmentId + " for patient '" + patientName + "' has been marked as completed.";
                        psNotify.setString(1, message);
                        psNotify.setString(2, "staff-patient-records"); // Link to patient records page
                        psNotify.executeUpdate();
                    }

                    conn.commit(); // Commit both operations

                    AuditLogger.log(doctorUserId, doctorUsername, "Doctor", "Completed appointment #" + appointmentId);
                    response.sendRedirect("doctor-dashboard?success=Appointment marked as completed.");
                } else {
                    conn.rollback(); // Rollback if no rows were affected
                    response.sendRedirect("doctor-dashboard?error=Could not complete appointment. It may not be assigned to you or is not in 'Assigned' status.");
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("doctor-dashboard?error=Invalid appointment ID.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctor-dashboard?error=Database error occurred while completing the appointment.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctor-dashboard?error=An unexpected error occurred.");
        }
    }
}