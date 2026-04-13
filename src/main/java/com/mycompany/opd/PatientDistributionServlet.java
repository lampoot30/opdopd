package com.mycompany.opd;

import com.google.gson.Gson;
import com.mycompany.opd.resources.DBUtil; // Correct import for your project's DB utility

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/api/patient-distribution")
public class PatientDistributionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Security Check: Ensure only Admin or Super Admin can access this data.
        if (session == null || (!"Admin".equals(session.getAttribute("userType")) && !"Super Admin".equals(session.getAttribute("userType")))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied.");
            return;
        }

        // A map to store city and patient count, LinkedHashMap maintains insertion order.
        Map<String, Integer> patientDistribution = new LinkedHashMap<>();

        // SQL to count patients per city, filtering out null or empty city names.
        // Ordering by count DESC to show most populated cities first.
        String sql = "SELECT city, COUNT(*) as patient_count " +
                     "FROM (" +
                     "    SELECT up.city FROM user_profiles up " +
                     "    JOIN users u ON up.user_id = u.user_id " +
                     "    WHERE u.user_type = 'Patient' AND up.city IS NOT NULL AND up.city != '' " +
                     "    UNION ALL " +
                     "    SELECT city FROM patient_relatives WHERE city IS NOT NULL AND city != ''" +
                     ") as combined_patients GROUP BY city ORDER BY patient_count DESC";

        try (Connection conn = DBUtil.getConnection(); // Use the correct DBUtil class
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String city = rs.getString("city");
                int count = rs.getInt("patient_count");
                patientDistribution.put(city, count);
            }

        } catch (SQLException e) {
            // Log the error and send a server error response
            e.printStackTrace(); // It's good practice to log this to your server's log file
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "A database error occurred while fetching patient distribution.");
            return;
        }

        // Convert the map to JSON using Gson library
        // The pom.xml already includes Gson, so no further action needed there.
        String json = new Gson().toJson(patientDistribution);

        // Set the content type to application/json and write the response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(json);
            out.flush();
        }
    }
}