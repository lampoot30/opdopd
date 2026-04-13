package com.mycompany.opd;

import com.mycompany.opd.models.Appointment;
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

@WebServlet("/print-request")
public class PrintRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // The SecurityFilter has already verified that the user is a logged-in Staff member.
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            Appointment appointment = null;

            String sql = "SELECT * FROM appointments WHERE appointment_id = ?";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, appointmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        appointment = new Appointment();
                        // Populate the Appointment object with all necessary details
                        appointment.setAppointmentId(rs.getInt("appointment_id"));
                        appointment.setPatientType(rs.getString("patient_type"));
                        appointment.setLastName(rs.getString("last_name"));
                        appointment.setGivenName(rs.getString("given_name"));
                        appointment.setMiddleName(rs.getString("middle_name"));
                        appointment.setReasonForVisit(rs.getString("reason_for_visit"));
                        appointment.setPreferredDate(rs.getDate("preferred_date"));

                        // Pass properties with missing setters as separate attributes for the JSP
                        request.setAttribute("printBirthday", rs.getDate("birthday"));
                        request.setAttribute("printContactNumber", rs.getString("contact_number"));
                        // civil_status and opd_no are not used in the JSP, so we don't need to pass them.
                    }
                }
            }

            if (appointment != null) {
                request.setAttribute("appointment", appointment);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/print_request.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment request not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while fetching the appointment request.");
        }
    }
}