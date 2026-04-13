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

@WebServlet("/medical-records")
public class MedicalRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session expired or unauthorized access. Please log in again.");
            return;
        }
        String userType = (String) session.getAttribute("userType");
        if (!"Patient".equals(userType) && !"Patient Or Guardian".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Unauthorized access. Please log in again.");
            return;
        }

        int patientUserId = (int) session.getAttribute("userId");
        List<Appointment> medicalRecords = new ArrayList<>();

        String sql = "SELECT * FROM appointments WHERE booked_by_user_id = ? AND relative_id IS NULL ORDER BY preferred_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment record = new Appointment();
                    record.setAppointmentId(rs.getInt("appointment_id"));
                    record.setPreferredDate(rs.getDate("preferred_date"));
                    record.setReasonForVisit(rs.getString("reason_for_visit"));
                    record.setStatus(rs.getString("status"));
                    medicalRecords.add(record);
                }
            }
        } catch (Exception e) {
            getServletContext().log("Error fetching medical records for patient " + patientUserId, e);
            request.setAttribute("error", "Could not load medical records.");
        }

        request.setAttribute("medicalRecords", medicalRecords);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/medical_records.jsp");
        dispatcher.forward(request, response);
    }
}