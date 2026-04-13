package com.mycompany.opd;

import com.mycompany.opd.resources.ScheduleValidator;
import com.mycompany.opd.resources.DBUtil;
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
import java.util.ArrayList;
import java.text.SimpleDateFormat;
import java.util.List;
import java.sql.SQLException;
@WebServlet("/assign-appointment")
public class AssignAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Security check: Only Staff can accept appointments.
        if (session == null || !"Staff".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied.");
            return;
        }

        String appointmentIdStr = request.getParameter("appointmentId");
        String doctorUserIdStr = request.getParameter("doctorUserId");
        String roomIdStr = request.getParameter("roomId");

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

        if (doctorUserIdStr == null || doctorUserIdStr.trim().isEmpty()) {
            response.sendRedirect("staff-dashboard?error=Doctor must be selected.");
            return;
        }
        int doctorUserId;
        try {
            doctorUserId = Integer.parseInt(doctorUserIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("staff-dashboard?error=Invalid doctor selection.");
            return;
        }

        Integer roomId = null;
        if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
            try {
                roomId = Integer.parseInt(roomIdStr.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect("staff-dashboard?error=Invalid room selection.");
                return;
            }
        }

        try (Connection conn = DBUtil.getConnection()) {
            // --- Start Transaction ---
            conn.setAutoCommit(false);

            String doctorName = "";
            String doctorContact = "";

            // Validate doctor exists and is a doctor
            String checkDoctorSql = "SELECT user_type FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkDoctorSql)) {
                ps.setInt(1, doctorUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !"Doctor".equals(rs.getString("user_type"))) {
                        response.sendRedirect("staff-dashboard?error=Selected doctor is not valid.");
                        return;
                    }
                }
            }

            // Fetch doctor's name and contact number for SMS notification
            String doctorInfoSql = "SELECT up.given_name, up.surname, u.contact_number FROM user_profiles up JOIN users u ON up.user_id = u.user_id WHERE u.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(doctorInfoSql)) {
                ps.setInt(1, doctorUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        doctorName = rs.getString("given_name") + " " + rs.getString("surname");
                        doctorContact = rs.getString("contact_number");
                    } else {
                        conn.rollback();
                        response.sendRedirect("staff-dashboard?error=Could not find doctor details for notification.");
                        return;
                    }
                }
            }

            // Validate room exists if selected
            if (roomId != null) {
                String checkRoomSql = "SELECT room_id FROM rooms WHERE room_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkRoomSql)) {
                    ps.setInt(1, roomId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            response.sendRedirect("staff-dashboard?error=Selected room is not valid.");
                            return;
                        }
                    }
                }
            }

            String patientName = "";
            String patientContact = "";
            java.sql.Date appointmentDate = null;

            // Validate appointment exists and is pending
            String checkApptSql = "SELECT status, given_name, last_name, contact_number, preferred_date FROM appointments WHERE appointment_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkApptSql)) {
                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        response.sendRedirect("staff-dashboard?error=Appointment not found.");
                        return;
                    }
                    String status = rs.getString("status");
                    if (!"Pending".equals(status)) {
                        conn.rollback();
                        response.sendRedirect("staff-dashboard?error=Appointment is not available for assignment.");
                        return;
                    }
                    // Fetch patient details for SMS
                    patientName = rs.getString("given_name") + " " + rs.getString("last_name");
                    patientContact = rs.getString("contact_number");
                    appointmentDate = rs.getDate("preferred_date");
                }
            }

            // Handle rescheduling
            String newPreferredDateStr = request.getParameter("newPreferredDate");
            boolean isRescheduled = newPreferredDateStr != null && !newPreferredDateStr.trim().isEmpty();
            if (isRescheduled) {
                appointmentDate = java.sql.Date.valueOf(newPreferredDateStr);
            }

            // --- Weekend/Holiday Conflict Check ---
            String unavailableReason = ScheduleValidator.getUnavailableReason(appointmentDate, conn);
            if (unavailableReason != null) {
                conn.rollback();
                response.sendRedirect("staff-dashboard?error=Cannot schedule on " + appointmentDate + " because it is " + unavailableReason + ".");
                return;
            }
            // --- End Conflict Check ---


            // --- Daily Appointment Limit Check ---
            int appointmentCount = 0;
            String countSql = "SELECT COUNT(*) FROM appointments WHERE preferred_date = ? AND status IN ('Accepted', 'Assigned', 'Completed')";
            try (PreparedStatement psCount = conn.prepareStatement(countSql)) {
                psCount.setDate(1, appointmentDate);
                try (ResultSet rs = psCount.executeQuery()) {
                    if (rs.next()) {
                        appointmentCount = rs.getInt(1);
                    }
                }
            }

            if (appointmentCount >= 40) {
                conn.rollback();
                response.sendRedirect("staff-dashboard?error=Daily appointment limit of 40 has been reached for " + appointmentDate + ". Cannot accept this appointment for the selected day.");
                return;
            }
            // --- End Limit Check ---


            // --- Schedule Conflict Check ---
            // Checks if the selected room is already booked by any doctor on the selected date.
            if (roomId != null) {
                String conflictSql = "SELECT appointment_id FROM appointments WHERE assigned_room_id = ? AND preferred_date = ? AND status IN ('Accepted', 'Assigned')";
                try (PreparedStatement ps = conn.prepareStatement(conflictSql)) {
                    ps.setInt(1, roomId);
                    ps.setDate(2, appointmentDate); // Uses the original or rescheduled date
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            // A conflict exists.
                            conn.rollback();
                            response.sendRedirect("staff-dashboard?error=Schedule Conflict: The selected room is already booked on " + appointmentDate + ".");
                            return;
                        }
                    }
                }
            }

            // Fetch room name for SMS
            String roomName = "N/A";
            if (roomId != null) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT room_name FROM rooms WHERE room_id = ?")) {
                    ps.setInt(1, roomId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) roomName = rs.getString("room_name");
                    }
                }
            }

            // Build the SQL query dynamically and safely
            StringBuilder sql = new StringBuilder("UPDATE appointments SET status = 'Accepted', assigned_doctor_id = ?, assigned_room_id = ? ");
            List<Object> params = new ArrayList<>();
            params.add(doctorUserId);
            params.add(roomId);
            if (isRescheduled) {
                sql.append(", preferred_date = ?");
                params.add(appointmentDate);
            }
            sql.append(" WHERE appointment_id = ?");
            params.add(appointmentId);

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                for (Object param : params) {
                    if (param instanceof Integer) {
                        ps.setInt(paramIndex++, (Integer) param);
                    } else if (param instanceof java.sql.Date) {
                        ps.setDate(paramIndex++, (java.sql.Date) param);
                    } else if (param == null) {
                        ps.setNull(paramIndex++, java.sql.Types.INTEGER); // For roomId
                    }
                }
                ps.executeUpdate();

                // --- Send SMS Notifications ---
                String formattedDate = new SimpleDateFormat("MMMM dd, yyyy").format(appointmentDate);

                // 1. Message to Doctor
                String doctorMessage = String.format("New Appointment Confirmed: You have a new appointment with patient %s on %s. It has been added to your schedule.",
                        patientName, formattedDate);
                SmsService.sendSms(doctorContact, doctorMessage);

                // 2. Message to Patient
                String patientMessage;
                if (isRescheduled) {
                    patientMessage = String.format("Your AMH appointment has been RESCHEDULED to %s. It is now confirmed with Doctor: Dr. %s, Room: %s.",
                            formattedDate, doctorName, roomName);
                } else {
                    patientMessage = String.format("Your AMH appointment on %s has been confirmed. Doctor: Dr. %s, Room: %s.",
                            formattedDate, doctorName, roomName);
                }
                SmsService.sendSms(patientContact, patientMessage);

                conn.commit(); // Commit transaction
                String successMessage;
                if (isRescheduled) {
                    successMessage = "Appointment #" + appointmentId + " has been successfully rescheduled to " + formattedDate + ". The patient and doctor have been notified via SMS.";
                } else {
                    successMessage = "Appointment #" + appointmentId + " has been confirmed for " + formattedDate + ". The patient and doctor have been notified via SMS.";
                }
                response.sendRedirect("staff-dashboard?success=" + successMessage);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("staff-dashboard?error=Database error while assigning appointment.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff-dashboard?error=An unexpected error occurred during assignment.");
        }
    }
}