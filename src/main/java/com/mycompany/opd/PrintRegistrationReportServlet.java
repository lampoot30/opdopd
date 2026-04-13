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
import java.text.DateFormatSymbols;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

@WebServlet("/print-registration-report")
public class PrintRegistrationReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String monthName = request.getParameter("month");
        int year = Integer.parseInt(request.getParameter("year"));

        // Convert month name to month number
        List<String> monthList = Arrays.asList(new DateFormatSymbols(Locale.US).getMonths());
        int monthNumber = monthList.indexOf(monthName) + 1;

        if (monthNumber == 0) {
            throw new ServletException("Invalid month name provided.");
        }

        List<Patient> registeredPatients = new ArrayList<>();
        String sql = "SELECT u.user_id, u.created_at, up.surname, up.given_name, up.middle_name, u.contact_number " +
                     "FROM users u JOIN user_profiles up ON u.user_id = up.user_id " +
                     "WHERE u.user_type = 'Patient' AND YEAR(u.created_at) = ? AND MONTH(u.created_at) = ? " +
                     "ORDER BY u.created_at ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            ps.setInt(2, monthNumber);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setSurname(rs.getString("surname"));
                    patient.setGivenName(rs.getString("given_name"));
                    patient.setMiddleName(rs.getString("middle_name"));
                    patient.setContactNumber(rs.getString("contact_number"));
                    patient.setCreatedAt(rs.getTimestamp("created_at"));
                    registeredPatients.add(patient);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not generate the report.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_analytics_overview.jsp");
            dispatcher.forward(request, response);
            return;
        }

        request.setAttribute("reportTitle", "Monthly Patient Registration Report");
        request.setAttribute("reportPeriod", monthName + " " + year);
        request.setAttribute("registeredPatients", registeredPatients);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/print_registration_report.jsp");
        dispatcher.forward(request, response);
    }
}