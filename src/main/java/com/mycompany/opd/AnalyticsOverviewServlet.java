package com.mycompany.opd;

import com.mycompany.opd.models.RegistrationAnalytics;
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

@WebServlet("/analytics-overview")
public class AnalyticsOverviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<RegistrationAnalytics> analyticsList = new ArrayList<>();

        String sql = "SELECT " +
                     "  m.month_name, " +
                     "  YEAR(CURDATE()) AS registration_year, " +
                     "  COALESCE(COUNT(u.user_id), 0) AS registration_count " +
                     "FROM months m " + // Using the new months table
                     "LEFT JOIN users u ON m.month_num = MONTH(u.created_at) AND u.user_type = 'Patient' AND YEAR(u.created_at) = YEAR(CURDATE()) " +
                     "GROUP BY m.month_num, month_name " +
                     "ORDER BY m.month_num ASC"; 

        try (Connection conn = DBUtil.getConnection()) {
            // Fetch registration trends
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    RegistrationAnalytics analytic = new RegistrationAnalytics();
                    analytic.setMonthName(rs.getString("month_name")); // Correctly using the SQL alias
                    analytic.setYear(rs.getInt("registration_year"));
                    analytic.setCount(rs.getInt("registration_count"));
                    analyticsList.add(analytic);
                }
            }

            // --- New Logic for Stat Cards ---
            request.setAttribute("patientCount", getCount(conn, "SELECT COUNT(*) FROM users WHERE user_type = 'Patient'"));
            request.setAttribute("doctorCount", getCount(conn, "SELECT COUNT(*) FROM users WHERE user_type = 'Doctor'"));
            request.setAttribute("staffCount", getCount(conn, "SELECT COUNT(*) FROM users WHERE user_type = 'Staff'"));

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load registration analytics from the database.");
        }

        request.setAttribute("analyticsList", analyticsList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_analytics_overview.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Helper method to get a single count from the database.
     * @param conn The database connection.
     * @param query The SQL query that returns a single count.
     * @return The count, or 0 if an error occurs.
     */
    private int getCount(Connection conn, String query) {
        int count = 0;
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}