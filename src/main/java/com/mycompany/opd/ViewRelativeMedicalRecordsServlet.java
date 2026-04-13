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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/view-relative-records")
public class ViewRelativeMedicalRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        String relativeIdStr = request.getParameter("relativeId");
        if (relativeIdStr == null || relativeIdStr.isEmpty()) {
            response.sendRedirect("my-relatives?error=No relative selected.");
            return;
        }

        int patientUserId = (int) session.getAttribute("userId");
        int relativeId = Integer.parseInt(relativeIdStr);
        List<Appointment> medicalRecords = new ArrayList<>();
        String relativeName = "";

        try (Connection conn = DBUtil.getConnection()) {
            // 1. Get the relative's name for the page title
            try (PreparedStatement ps = conn.prepareStatement("SELECT given_name, surname FROM patient_relatives WHERE relative_id = ? AND patient_user_id = ?")) {
                ps.setInt(1, relativeId);
                ps.setInt(2, patientUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        relativeName = rs.getString("given_name") + " " + rs.getString("surname");
                    } else {
                        response.sendRedirect("my-relatives?error=Relative not found.");
                        return;
                    }
                }
            }

            // 2. Get the medical records for that relative
            String sql = "SELECT a.*, up.surname AS doctor_surname, up.given_name AS doctor_given_name FROM appointments a LEFT JOIN user_profiles up ON a.assigned_doctor_id = up.user_id WHERE a.booked_by_user_id = ? AND relative_id = ? ORDER BY preferred_date DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, patientUserId);
                ps.setInt(2, relativeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Appointment record = new Appointment();
                        record.setAppointmentId(rs.getInt("appointment_id"));
                        record.setPreferredDate(rs.getDate("preferred_date"));
                        record.setReasonForVisit(rs.getString("reason_for_visit"));
                        record.setStatus(rs.getString("status"));
                        record.setGivenName(rs.getString("doctor_given_name")); // Doctor's first name
                        record.setLastName(rs.getString("doctor_surname"));   // Doctor's last name
                        medicalRecords.add(record);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error while fetching relative's records.");
        }

        request.setAttribute("medicalRecords", medicalRecords);
        request.setAttribute("relativeName", relativeName);
        request.getRequestDispatcher("/view_relative_records.jsp").forward(request, response);
    }
}