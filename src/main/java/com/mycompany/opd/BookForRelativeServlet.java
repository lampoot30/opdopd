package com.mycompany.opd;

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
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/book-for-relative")
public class BookForRelativeServlet extends HttpServlet {

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
        Map<String, Object> relativeProfile = new HashMap<>();
        int age = -1;

        try (Connection conn = DBUtil.getConnection()) {
            // 1. Fetch Relative's Profile
            String relativeSql = "SELECT * FROM patient_relatives WHERE relative_id = ? AND patient_user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(relativeSql)) {
                ps.setInt(1, relativeId);
                ps.setInt(2, patientUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        relativeProfile.put("surname", rs.getString("surname"));
                        relativeProfile.put("givenName", rs.getString("given_name"));
                        java.sql.Date dateOfBirth = rs.getDate("date_of_birth");
                        relativeProfile.put("dateOfBirth", dateOfBirth);
                        relativeProfile.put("middleName", rs.getString("middle_name"));
                        relativeProfile.put("gender", rs.getString("gender"));
                        relativeProfile.put("religion", rs.getString("religion"));
                        relativeProfile.put("contactNumber", rs.getString("contact_number"));
                        relativeProfile.put("permanentAddress", rs.getString("permanent_address"));

                        // Calculate age from date of birth
                        if (dateOfBirth != null) {
                            LocalDate dob = dateOfBirth.toLocalDate();
                            age = Period.between(dob, LocalDate.now()).getYears();
                        }
                    } else {
                        response.sendRedirect("my-relatives?error=Relative not found.");
                        return;
                    }
                }
            }

            // 2. Fetch Services
            List<Service> services = new ArrayList<>();
            // Fetch all bookable services, regardless of age.
            String servicesSql = "SELECT * FROM services WHERE service_name IN ('Family Medicine', 'Women''s Health Clinic', 'Occupational Therapy', 'Rehabilitation Medicine', 'Pediatric Medicine') ORDER BY service_name ASC";
            try (PreparedStatement ps = conn.prepareStatement(servicesSql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setScheduleDetails(rs.getString("schedule_details"));
                    services.add(service);
                }
            }

            request.setAttribute("relativeProfile", relativeProfile);
            request.setAttribute("relativeId", relativeId);
            request.setAttribute("services", services);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred while loading page data.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("book_for_relative.jsp");
        dispatcher.forward(request, response);
    }
}