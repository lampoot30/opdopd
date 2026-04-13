package com.mycompany.opd;

import com.mycompany.opd.models.Patient;
import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/archive-patient")
public class ArchivePatientServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Patient> patientList = new ArrayList<>();
        String sql = "SELECT u.user_id, up.given_name, up.surname, u.contact_number " +
                     "FROM users u " +
                     "JOIN user_profiles up ON u.user_id = up.user_id " +
                     "WHERE u.user_type = 'Patient' AND u.status = 'active'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setUserId(rs.getInt("user_id"));
                patient.setGivenName(rs.getString("given_name"));
                patient.setSurname(rs.getString("surname"));
                patient.setContactNumber(rs.getString("contact_number"));
                patientList.add(patient);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load patient data.");
        }

        request.setAttribute("patientList", patientList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/archive_patient.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE users SET status = 'inactive' WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(userIdStr));
                ps.executeUpdate();
            }
            response.sendRedirect("archive-patient?success=Patient account archived successfully.");
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("archive-patient?error=Failed to archive patient account.");
        }
    }
}