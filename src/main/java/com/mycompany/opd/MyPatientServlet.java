package com.mycompany.opd;

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

@WebServlet("/my-patient")
public class MyPatientServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        int doctorId = (int) session.getAttribute("userId");
        List<Patient> patientList = new ArrayList<>();

        // This query gets all unique patients that have ever been assigned to the current doctor.
        String sql = "SELECT DISTINCT u.user_id, u.contact_number, up.given_name, up.surname " +
                     "FROM users u " +
                     "JOIN user_profiles up ON u.user_id = up.user_id " +
                     "JOIN appointments a ON u.user_id = a.booked_by_user_id " +
                     "WHERE a.assigned_doctor_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setGivenName(rs.getString("given_name"));
                    patient.setSurname(rs.getString("surname"));
                    patient.setContactNumber(rs.getString("contact_number"));
                    patientList.add(patient);
                }
            }

            request.setAttribute("patientList", patientList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/my_patient.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("doctor-dashboard?error=An error occurred while loading patient records.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctor-dashboard?error=An unexpected error occurred.");
        }
    }
}