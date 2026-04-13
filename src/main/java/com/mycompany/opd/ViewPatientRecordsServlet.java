package com.mycompany.opd;

import com.mycompany.opd.models.Appointment;
import com.mycompany.opd.models.Patient;
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

@WebServlet("/view-patient-records")
public class ViewPatientRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Security check: Ensure a doctor is logged in.
        if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam == null || patientIdParam.trim().isEmpty()) {
            response.sendRedirect("doctor-dashboard?error=Invalid patient ID.");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(patientIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("doctor-dashboard?error=Invalid patient ID format.");
            return;
        }

        Patient patientProfile = null;
        List<Appointment> medicalRecords = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // 1. Fetch patient's profile information
            String profileSql = "SELECT up.*, u.contact_number " +
                                "FROM user_profiles up " +
                                "JOIN users u ON up.user_id = u.user_id WHERE up.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(profileSql)) {
                ps.setInt(1, patientId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        patientProfile = new Patient();
                        int userId = rs.getInt("user_id");
                        patientProfile.setUserId(userId);
                        String surname = rs.getString("surname");
                        patientProfile.setSurname(surname);
                        String givenName = rs.getString("given_name");
                        patientProfile.setGivenName(givenName);
                        String gender = rs.getString("gender");
                        patientProfile.setGender(gender);
                        java.sql.Date dateOfBirth = rs.getDate("date_of_birth");
                        patientProfile.setDateOfBirth(dateOfBirth);
                        patientProfile.setContactNumber(rs.getString("contact_number"));

                        // Set other fields from user_profiles as needed
                    }
                }
            }

            if (patientProfile == null) {
                response.sendRedirect("doctor-dashboard?error=Patient not found.");
                return;
            }

            // 2. Fetch patient's medical records (appointments)
            String recordsSql = "SELECT a.appointment_id, a.reason_for_visit, a.preferred_date, a.status, " +
                                "up.surname as doctor_surname, up.given_name as doctor_given_name, r.room_name " +
                                "FROM appointments a " +
                                "LEFT JOIN user_profiles up ON a.assigned_doctor_id = up.user_id " +
                                "LEFT JOIN rooms r ON a.assigned_room_id = r.room_id " +
                                "WHERE a.booked_by_user_id = ? " + // Correctly filtering by the patient's ID
                                "ORDER BY a.preferred_date DESC";
            try (PreparedStatement ps = conn.prepareStatement(recordsSql)) {
                ps.setInt(1, patientId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Appointment appointment = new Appointment();
                        int appointmentId = rs.getInt("appointment_id");
                        appointment.setAppointmentId(appointmentId);
                        String reasonForVisit = rs.getString("reason_for_visit");
                        appointment.setReasonForVisit(reasonForVisit);
                        java.sql.Date preferredDate = rs.getDate("preferred_date");
                        appointment.setPreferredDate(preferredDate);
                        String status = rs.getString("status");
                        appointment.setStatus(status);
                        // Set the doctor's name and room name on the appointment object
                        appointment.setGivenName(rs.getString("doctor_given_name")); // Re-using givenName for doctor's first name
                        appointment.setLastName(rs.getString("doctor_surname"));   // Re-using lastName for doctor's last name
                        appointment.setRoomName(rs.getString("room_name"));

                        medicalRecords.add(appointment);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the exception to the console
            response.sendRedirect("doctor-dashboard?error=Database error occurred while loading patient records.");
        }

        request.setAttribute("patientProfile", patientProfile);
        request.setAttribute("medicalRecords", medicalRecords);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view_patient_records.jsp");
        dispatcher.forward(request, response);
    }
}