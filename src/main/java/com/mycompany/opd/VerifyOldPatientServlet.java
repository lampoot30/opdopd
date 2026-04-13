package com.mycompany.opd;

import com.google.gson.Gson;
import com.mycompany.opd.models.Patient;
import com.mycompany.opd.resources.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/VerifyOldPatientServlet")
public class VerifyOldPatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String opdNo = request.getParameter("opdNo");
        String lastCheckupDate = request.getParameter("lastCheckupDate");

        Patient patientProfile = null;

        // First, find the user_id from the appointments table using the provided details
        String findUserSql = "SELECT booked_by_user_id FROM appointments WHERE opd_no = ? AND preferred_date = ? ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBUtil.getConnection()) {
            int userId = -1;
            try (PreparedStatement ps = conn.prepareStatement(findUserSql)) {
                ps.setString(1, opdNo);
                ps.setString(2, lastCheckupDate);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("booked_by_user_id");
                    }
                }
            }

            if (userId != -1) {
                // If user is found, fetch their full profile
                String patientSql = "SELECT up.*, u.contact_number " +
                                    "FROM user_profiles up " +
                                    "JOIN users u ON up.user_id = u.user_id " +
                                    "WHERE up.user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(patientSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            patientProfile = new Patient();
                            patientProfile.setSurname(rs.getString("surname"));
                            patientProfile.setGivenName(rs.getString("given_name"));
                            patientProfile.setMiddleName(rs.getString("middle_name"));
                            patientProfile.setDateOfBirth(rs.getDate("date_of_birth"));
                            patientProfile.setGender(rs.getString("gender"));
                            patientProfile.setReligion(rs.getString("religion"));
                            patientProfile.setPermanentAddress(rs.getString("permanent_address"));
                            patientProfile.setContactNumber(rs.getString("contact_number"));
                        }
                    }
                }
            }

            if (patientProfile != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(patientProfile));
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient record not found or details do not match.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error during verification.");
        }
    }
}