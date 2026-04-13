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
import java.sql.SQLException;
import java.util.ArrayList; 
import java.util.List;

@WebServlet("/staff-view-patient-detail")
public class StaffViewPatientDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userType = (session != null) ? (String) session.getAttribute("userType") : null;

        // Security Check: Ensure a user is logged in and has the correct role.
        if (!"Staff".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            System.out.println("DEBUG: Patient ID not provided in request.");
            response.sendRedirect("staff-patient-records?error=No patient selected.");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(patientIdStr);
            System.out.println("DEBUG: Attempting to fetch patient with ID: " + patientId);
        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid patient ID format: " + patientIdStr);
            response.sendRedirect("staff-patient-records?error=Invalid patient ID format.");
            return;
        }

        try {
            Patient patient = null;
            List<Appointment> medicalRecords = new ArrayList<>();

            try (Connection conn = DBUtil.getConnection()) {
                // 1. Fetch patient profile details
                String profileSql = "SELECT u.user_id, u.contact_number, up.surname, up.given_name, up.middle_name, " +
                                    "up.date_of_birth, up.gender, up.religion, up.permanent_address, up.current_address, " +
                                    "up.city, up.postal_code, up.profile_picture_path " +
                                    "FROM user_profiles up JOIN users u ON up.user_id = u.user_id " +
                                    "WHERE up.user_id = ? AND u.user_type = 'Patient'";
                try (PreparedStatement ps = conn.prepareStatement(profileSql)) {
                    ps.setInt(1, patientId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            patient = new Patient();
                            patient.setUserId(rs.getInt("user_id")); // Use rs.getInt("user_id") for consistency
                            patient.setGivenName(rs.getString("given_name"));
                            patient.setSurname(rs.getString("surname"));
                            patient.setMiddleName(rs.getString("middle_name"));
                            patient.setDateOfBirth(rs.getDate("date_of_birth"));
                            patient.setGender(rs.getString("gender"));
                            patient.setContactNumber(rs.getString("contact_number"));
                            patient.setPermanentAddress(rs.getString("permanent_address"));
                            patient.setProfilePicturePath(rs.getString("profile_picture_path"));
                            // Add other fields from user_profiles if needed by the JSP
                            // patient.setReligion(rs.getString("religion"));
                            // patient.setCurrentAddress(rs.getString("current_address"));
                            // patient.setCity(rs.getString("city"));
                            // patient.setPostalCode(rs.getString("postal_code"));
                            System.out.println("DEBUG: Patient profile found for ID: " + patientId);
                        } else {
                            System.out.println("DEBUG: No patient profile found for ID: " + patientId + " or user is not a 'Patient'.");
                        }
                    }
                }

                if (patient == null) {
                    response.sendRedirect("staff-patient-records?error=Patient not found or is not registered as a patient.");
                    return;
                }

                // 2. Fetch patient's appointment history
                String recordsSql = "SELECT a.appointment_id, a.preferred_date, a.reason_for_visit, a.status, " +
                                    "up.given_name AS doc_given_name, up.surname AS doc_surname " +
                                    "FROM appointments a " +
                                    "LEFT JOIN user_profiles up ON a.assigned_doctor_id = up.user_id " +
                                    "WHERE a.booked_by_user_id = ? ORDER BY a.preferred_date DESC";
                try (PreparedStatement ps = conn.prepareStatement(recordsSql)) {
                    ps.setInt(1, patientId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Appointment record = new Appointment();
                            record.setAppointmentId(rs.getInt("appointment_id"));
                            record.setPreferredDate(rs.getDate("preferred_date"));
                            record.setReasonForVisit(rs.getString("reason_for_visit"));
                            record.setStatus(rs.getString("status"));
                            record.setGivenName(rs.getString("doc_given_name"));
                            record.setLastName(rs.getString("doc_surname"));
                            medicalRecords.add(record);
                        }
                    }
                }
            }

            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecords", medicalRecords);
            request.getRequestDispatcher("/staff_view_patient_detail.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("staff-patient-records?error=A database error occurred while fetching patient records.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff-patient-records?error=An error occurred while fetching patient records.");
        }
    }
}