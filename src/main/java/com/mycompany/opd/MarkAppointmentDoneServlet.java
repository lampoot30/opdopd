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
import java.time.LocalDate;

@WebServlet("/mark-appointment-done")
public class MarkAppointmentDoneServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Security check: Only Doctors can perform this action.
        if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp?error=Access Denied.");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid appointment ID.");
            response.sendRedirect("doctor-dashboard");
            return;
        }

        int doctorId = (int) session.getAttribute("userId");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement psCheck = conn.prepareStatement("SELECT preferred_date FROM appointments WHERE appointment_id = ? AND assigned_doctor_id = ?")) {
            
            psCheck.setInt(1, appointmentId);
            psCheck.setInt(2, doctorId);
            
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    java.sql.Date appointmentDate = rs.getDate("preferred_date");
                    // --- Date Validation ---
                    if (appointmentDate.toLocalDate().isAfter(LocalDate.now())) {
                        session.setAttribute("errorMessage", "Cannot mark a future appointment as completed.");
                        response.sendRedirect("doctor-dashboard");
                        return;
                    }
                } else {
                    session.setAttribute("errorMessage", "Appointment not found or not assigned to you.");
                    response.sendRedirect("doctor-dashboard");
                    return;
                }
            }

            // If validation passes, proceed with the update
            String updateSql = "UPDATE appointments SET status = 'Completed' WHERE appointment_id = ? AND assigned_doctor_id = ? AND status IN ('Accepted', 'Assigned')";
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setInt(1, appointmentId);
                psUpdate.setInt(2, doctorId);
                int rowsAffected = psUpdate.executeUpdate();
                if (rowsAffected > 0) {
                    session.setAttribute("successMessage", "Appointment #" + appointmentId + " marked as completed.");
                } else {
                    session.setAttribute("errorMessage", "Could not complete appointment. It may not be assigned to you or is already completed.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error occurred while updating the appointment.");
        }
        response.sendRedirect("doctor-dashboard");
    }
}