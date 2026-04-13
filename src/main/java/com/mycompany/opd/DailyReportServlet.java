package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/daily-reports")
public class DailyReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, Object>> reportList = new ArrayList<>();
        String sql = "SELECT report_id, report_date, file_path, generated_at FROM daily_reports ORDER BY report_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> report = new HashMap<>();
                report.put("reportId", rs.getInt("report_id"));
                report.put("reportDate", rs.getDate("report_date"));
                report.put("filePath", rs.getString("file_path"));
                report.put("generatedAt", rs.getTimestamp("generated_at"));
                reportList.add(report);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Optionally, set an error message for the JSP
            request.setAttribute("error", "Failed to load daily reports from the database.");
        }

        request.setAttribute("reportList", reportList);
        request.getRequestDispatcher("/daily_reports.jsp").forward(request, response);
    }
}