package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.SmsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/BookAppointmentServlet")
@MultipartConfig
public class BookAppointmentServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "attachments";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            int userId = (int) session.getAttribute("userId");
            String username = (String) session.getAttribute("displayUsername");
            String attachmentPath = null;

            // --- Handle File Upload ---
            Part filePart = request.getPart("attachment");
            if (filePart != null) {
                String fileName = filePart.getSubmittedFileName();

                if (fileName != null && !fileName.isEmpty()) {
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Create a unique file name
                    String uniqueFileName = username + "_" + System.currentTimeMillis() + "_" + fileName;
                    filePart.write(uploadFilePath + File.separator + uniqueFileName);
                    attachmentPath = (UPLOAD_DIR + File.separator + uniqueFileName).replace(File.separator, "/");
                }
            }

            // Handle relativeId early for error redirects
            String relativeIdStr = request.getParameter("relativeId");
            String redirectPage = (relativeIdStr != null && !relativeIdStr.isEmpty()) ? "book_for_relative.jsp?relativeId=" + relativeIdStr : "book_appointment.jsp";

            String sql = "INSERT INTO appointments (booked_by_user_id, relative_id, patient_type, last_name, given_name, middle_name, birthday, gender, contact_number, address, opd_no, last_checkup_date, reason_for_visit, service_name, attachment_path, preferred_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);

                // Handle relativeId
                if (relativeIdStr != null && !relativeIdStr.isEmpty()) {
                    ps.setInt(2, Integer.parseInt(relativeIdStr));
                } else {
                    ps.setNull(2, java.sql.Types.INTEGER);
                }

                String patientType = request.getParameter("patientType");
                if (patientType != null) {
                    patientType = patientType.substring(0, 1).toUpperCase() + patientType.substring(1).toLowerCase();
                }
                ps.setString(3, patientType);
                ps.setString(4, request.getParameter("lastName"));
                ps.setString(5, request.getParameter("givenName"));
                ps.setString(6, request.getParameter("middleName"));

                // Validate and parse birthday
                String birthdayStr = request.getParameter("birthday");
                if (birthdayStr == null || !birthdayStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
                    response.sendRedirect(redirectPage + "&error=Invalid birthday format.");
                    return;
                }
                ps.setDate(7, Date.valueOf(birthdayStr));

                ps.setString(8, request.getParameter("gender"));
                ps.setString(9, request.getParameter("contactNumber"));
                ps.setString(10, request.getParameter("address")); // Corrected form field name

                // Handle optional fields for 'old' patient
                if ("Old".equals(patientType)) {
                    ps.setString(11, request.getParameter("opdNo")); // Corrected index
                    String lastCheckup = request.getParameter("lastCheckup");
                    if (lastCheckup != null && !lastCheckup.isEmpty()) {
                        if (!lastCheckup.matches("\\d{4}-\\d{2}-\\d{2}")) {
                            response.sendRedirect(redirectPage + "&error=Invalid last checkup date format.");
                            return;
                        }
                        ps.setDate(12, Date.valueOf(lastCheckup)); // Corrected index
                    } else {
                        ps.setNull(12, java.sql.Types.DATE); // Corrected index
                    }
                } else {
                    // For 'New' patients, opd_no and last_checkup_date are null
                    ps.setNull(11, java.sql.Types.VARCHAR); // opd_no
                    ps.setNull(12, java.sql.Types.DATE); // last_checkup_date
                }

                // Validate preferredDate format before parsing
                String preferredDateStr = request.getParameter("preferredDate");
                if (preferredDateStr == null || !preferredDateStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
                    response.sendRedirect(redirectPage + "&error=Invalid preferred date format.");
                    return;
                }

                ps.setString(13, request.getParameter("reasonForVisit"));
                ps.setString(14, request.getParameter("service"));
                ps.setString(15, attachmentPath);
                ps.setDate(16, Date.valueOf(preferredDateStr));

                ps.executeUpdate();
            }

            // --- Send SMS Notification if booked for a relative ---
            if (relativeIdStr != null && !relativeIdStr.isEmpty()) {
                try {
                    // Get the patient's name for the SMS message
                    String patientName = "A registered user";
                    String patientNameSql = "SELECT given_name, surname FROM user_profiles WHERE user_id = ?";
                    try (PreparedStatement namePs = conn.prepareStatement(patientNameSql)) {
                        namePs.setInt(1, userId);
                        try (ResultSet rs = namePs.executeQuery()) {
                            if (rs.next()) {
                                patientName = rs.getString("given_name") + " " + rs.getString("surname");
                            }
                        }
                    }

                    String relativeContactNumber = request.getParameter("contactNumber");
                    String service = request.getParameter("service");
                    String preferredDate = request.getParameter("preferredDate");

                    String message = String.format(
                        "Hello! %s has booked an appointment for you at AMH OPD. Service: %s, Date: %s. You will be notified once it is confirmed.",
                        patientName, service, preferredDate
                    );
                    SmsService.sendSms(relativeContactNumber, message);
                    response.sendRedirect("book_for_relative.jsp?relativeId=" + relativeIdStr + "&success=Appointment request submitted and relative has been notified.");
                } catch (Exception e) {
                    System.err.println("SMS notification failed for relative's appointment: " + e.getMessage());
                    response.sendRedirect("book_for_relative.jsp?relativeId=" + relativeIdStr + "&success=Appointment submitted, but SMS notification failed.");
                }
            } else {
                response.sendRedirect("book_appointment.jsp?success=Your appointment request has been submitted successfully! You will be notified once it is confirmed.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("book_appointment.jsp?error=Database error occurred. Please try again.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("book_appointment.jsp?error=An unexpected error occurred. Please check your inputs.");
        }
    }
}