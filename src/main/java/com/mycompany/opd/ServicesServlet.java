package com.mycompany.opd;

import com.mycompany.opd.models.Patient;
import com.mycompany.opd.models.Service;
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

@WebServlet("/services")
public class ServicesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        List<Service> services = new ArrayList<>();
        Patient patientProfile = null;
        String sql;
        String forwardPage = isLoggedIn ? "/patient_dashboard.jsp" : "/login.jsp"; // Initialize with a safe default
        
        try (Connection conn = DBUtil.getConnection()) {
            if (isLoggedIn) {
                int userId = (int) session.getAttribute("userId");
                forwardPage = "/book_appointment.jsp";
                
                // Fetch patient profile data
                String patientSql = "SELECT up.*, u.contact_number FROM user_profiles up JOIN users u ON up.user_id = u.user_id WHERE up.user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(patientSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            patientProfile = new Patient();
                            patientProfile.setSurname(rs.getString("surname"));
                            patientProfile.setGivenName(rs.getString("given_name") != null ? rs.getString("given_name") : "");
                            patientProfile.setMiddleName(rs.getString("middle_name") != null ? rs.getString("middle_name") : "");
                            patientProfile.setDateOfBirth(rs.getDate("date_of_birth"));
                            patientProfile.setGender(rs.getString("gender") != null ? rs.getString("gender") : "");
                            patientProfile.setReligion(rs.getString("religion") != null ? rs.getString("religion") : "");
                            patientProfile.setPermanentAddress(rs.getString("permanent_address") != null ? rs.getString("permanent_address") : "");
                            patientProfile.setContactNumber(rs.getString("contact_number") != null ? rs.getString("contact_number") : "");
                        }
                    }
                }

                // Fetch bookable services for logged-in patients
                sql = "SELECT * FROM services WHERE service_name IN ('Family Medicine', 'Women''s Health Clinic', 'Occupational Therapy', 'Rehabilitation Medicine') ORDER BY service_name ASC";

            } else {
                // For public view, show all services
                sql = "SELECT * FROM services ORDER BY service_name ASC";
                forwardPage = "/public_services.jsp";
            }

            // Fetch the services list
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setScheduleType(rs.getString("schedule_type"));
                    service.setScheduleDetails(rs.getString("schedule_details"));
                    services.add(service);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load required data.");
        }

        request.setAttribute("services", services);
        request.setAttribute("patientProfile", patientProfile);
        RequestDispatcher dispatcher = request.getRequestDispatcher(forwardPage);
        dispatcher.forward(request, response);
    }
}