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

@WebServlet("/staff-patient-records")
public class StaffPatientRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Patient> patientList = new ArrayList<>();
        String sql = "SELECT u.user_id, up.surname, up.given_name, up.middle_name, u.contact_number, up.profile_picture_path " +
                     "FROM users u " +
                     "JOIN user_profiles up ON u.user_id = up.user_id " +
                     "WHERE u.user_type = 'Patient' AND u.status = 'active' " +
                     "ORDER BY up.surname, up.given_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setUserId(rs.getInt("user_id"));
                patient.setSurname(rs.getString("surname"));
                patient.setGivenName(rs.getString("given_name"));
                patient.setMiddleName(rs.getString("middle_name"));
                patient.setContactNumber(rs.getString("contact_number"));
                patient.setProfilePicturePath(rs.getString("profile_picture_path"));
                patientList.add(patient);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load patient list.");
        }

        request.setAttribute("patientList", patientList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/staff_patient_records.jsp");
        dispatcher.forward(request, response);
    }
}