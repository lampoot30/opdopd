package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.ScheduleValidator;
import com.mycompany.opd.resources.SmsService;
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
import java.text.SimpleDateFormat;

@WebServlet("/propose-reschedule")
public class ProposeRescheduleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Staff".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Access Denied.");
            return;
        }

        int appointmentId;
        java.sql.Date newDate;
        try {
            appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            newDate = java.sql.Date.valueOf(request.getParameter("newProposedDate"));
        } catch (IllegalArgumentException e) {
            response.sendRedirect("staff-dashboard?error=Invalid data provided for reschedule proposal.");
            return;
        }

        String patientContact = null;
        String redirectUrl = "view-appointment?id=" + appointmentId;

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // --- Weekend/Holiday Conflict Check ---
            String unavailableReason = ScheduleValidator.getUnavailableReason(newDate, conn);
            if (unavailableReason != null) {
                response.sendRedirect(redirectUrl + "&error=Cannot reschedule to " + newDate + " because it is " + unavailableReason + ".");
                return;
            }

            // 1. Get patient contact number
            String contactSql = "SELECT contact_number FROM appointments WHERE appointment_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(contactSql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        patientContact = rs.getString("contact_number");
                    }
                }
            }

            if (patientContact == null) {
                throw new SQLException("Could not find appointment to get contact number.");
            }

            // 2. Update the preferred_date
            String updateSql = "UPDATE appointments SET preferred_date = ? WHERE appointment_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setDate(1, newDate);
                ps.setInt(2, appointmentId);
                ps.executeUpdate();
            }

            // 3. Send SMS Notification
            String formattedDate = new SimpleDateFormat("MMMM dd, yyyy").format(newDate);
            String message = String.format("AMH Update: A staff member has proposed a new date for your appointment: %s. You will receive a final confirmation once a doctor is assigned.", formattedDate);
            SmsService.sendSms(patientContact, message);

            conn.commit();
            response.sendRedirect(redirectUrl + "&success=New date has been proposed and the patient has been notified via SMS.");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(redirectUrl + "&error=Database error while proposing new date.");
        }
    }
}