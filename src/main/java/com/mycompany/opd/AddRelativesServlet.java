package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.SmsService;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/my-relatives")
public class AddRelativesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied. Please log in.");
            return;
        }

        int patientUserId = (int) session.getAttribute("userId");
        List<Map<String, Object>> relativesList = new ArrayList<>();
        String sql = "SELECT * FROM patient_relatives WHERE patient_user_id = ? ORDER BY surname, given_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> relative = new HashMap<>();
                    relative.put("relative_id", rs.getInt("relative_id"));
                    relative.put("relationship", rs.getString("relationship"));
                    relative.put("surname", rs.getString("surname"));
                    relative.put("given_name", rs.getString("given_name"));
                    relative.put("contact_number", rs.getString("contact_number"));
                    relative.put("date_of_birth", rs.getDate("date_of_birth"));
                    relativesList.add(relative);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not load the list of relatives.");
        }

        request.setAttribute("relativesList", relativesList);
        request.getRequestDispatcher("/add_my_relatives.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
            return;
        }

        // Retrieve parameters from the form
        String relationshipPreset = request.getParameter("relationship");
        String finalRelationship;
        if ("Others".equalsIgnoreCase(relationshipPreset)) {
            finalRelationship = request.getParameter("otherRelationship");
        } else {
            finalRelationship = relationshipPreset;
        }
        String surname = request.getParameter("surname");
        String givenName = request.getParameter("givenName");
        String middleName = request.getParameter("middleName");
        String contactNumber = request.getParameter("contactNumber");
        String birthday = request.getParameter("birthday");
        String gender = request.getParameter("gender");
        String religion = request.getParameter("religion");
        String permanentAddress = request.getParameter("permanentAddress");
        String currentAddress = request.getParameter("currentAddress");
        String city = request.getParameter("city");
        String zipCode = request.getParameter("zipCode");

        // Get the patient's user ID from the session
        int patientUserId = (int) session.getAttribute("userId");

        String sql = "INSERT INTO patient_relatives (patient_user_id, relationship, surname, given_name, middle_name, contact_number, date_of_birth, gender, religion, permanent_address, current_address, city, postal_code) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientUserId);
            ps.setString(2, finalRelationship);
            ps.setString(3, surname);
            ps.setString(4, givenName);
            ps.setString(5, middleName);
            ps.setString(6, contactNumber);
            ps.setDate(7, Date.valueOf(birthday));
            ps.setString(8, gender);
            ps.setString(9, religion);
            ps.setString(10, permanentAddress);
            ps.setString(11, currentAddress);
            ps.setString(12, city);
            ps.setString(13, zipCode);

            ps.executeUpdate();

            // --- Send SMS Notification to the Relative ---
            try {
                // Get the patient's name for the SMS message
                String patientName = "A registered user";
                String patientNameSql = "SELECT given_name, surname FROM user_profiles WHERE user_id = ?";
                try (PreparedStatement namePs = conn.prepareStatement(patientNameSql)) {
                    namePs.setInt(1, patientUserId);
                    try (ResultSet rs = namePs.executeQuery()) {
                        if (rs.next()) {
                            patientName = rs.getString("given_name") + " " + rs.getString("surname");
                        }
                    }
                }

                String message = String.format(
                    "Hello! You have been added as a relative by %s in the Aurora Memorial Hospital OPD Portal.",
                    patientName
                );
                SmsService.sendSms(contactNumber, message);
                response.sendRedirect("my-relatives?success=Relative added successfully and notification sent.");
            } catch (Exception e) {
                System.err.println("SMS notification failed for new relative: " + e.getMessage());
                response.sendRedirect("my-relatives?success=Relative added, but SMS notification failed.");
            }

        } catch (SQLException ex) {
            // Handle any database errors
            ex.printStackTrace();
            response.sendRedirect("my-relatives?error=A database error occurred. Please try again.");
        } catch (IllegalArgumentException ex) {
            // Handle date parsing errors
            ex.printStackTrace();
            response.sendRedirect("my-relatives?error=Invalid date format. Please use YYYY-MM-DD.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to add relatives to the database";
    }

}