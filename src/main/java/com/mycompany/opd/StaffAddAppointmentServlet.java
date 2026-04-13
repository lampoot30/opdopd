package com.mycompany.opd;

import com.mycompany.opd.models.Doctor;
import com.mycompany.opd.models.Room;
import com.mycompany.opd.resources.ScheduleValidator;
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
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/staff-add-appointment")
public class StaffAddAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Doctor> doctors = new ArrayList<>();
        List<Room> rooms = new ArrayList<>();
        List<Service> services = new ArrayList<>();
        List<Map<String, String>> searchablePatients = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // Fetch all active patients
            String patientsSql = "SELECT u.user_id, up.surname, up.given_name, up.middle_name, up.date_of_birth, u.contact_number, up.gender, up.permanent_address " +
                                 "FROM users u JOIN user_profiles up ON u.user_id = up.user_id " +
                                 "WHERE u.user_type = 'Patient' AND u.status = 'active'";
            try (PreparedStatement ps = conn.prepareStatement(patientsSql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("id", "patient-" + rs.getInt("user_id")); // ID for registered patients
                    p.put("name", rs.getString("surname") + ", " + rs.getString("given_name") + " " + (rs.getString("middle_name") != null ? rs.getString("middle_name") : ""));
                    p.put("lastName", rs.getString("surname"));
                    p.put("givenName", rs.getString("given_name"));
                    p.put("middleName", rs.getString("middle_name"));
                    p.put("birthday", rs.getString("date_of_birth"));
                    p.put("contactNumber", rs.getString("contact_number"));
                    p.put("gender", rs.getString("gender"));
                    p.put("address", rs.getString("permanent_address"));
                    searchablePatients.add(p);
                }
            }

            // Fetch all relatives
            String relativesSql = "SELECT *, patient_user_id FROM patient_relatives";
            try (PreparedStatement ps = conn.prepareStatement(relativesSql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("id", "relative-" + rs.getInt("relative_id")); // ID for relatives
                    p.put("bookedByUserId", String.valueOf(rs.getInt("patient_user_id"))); // The patient who owns the relative
                    p.put("lastName", rs.getString("surname"));
                    p.put("givenName", rs.getString("given_name"));
                    p.put("middleName", rs.getString("middle_name"));
                    p.put("birthday", rs.getString("date_of_birth"));
                    p.put("contactNumber", rs.getString("contact_number"));
                    p.put("gender", rs.getString("gender"));
                    p.put("address", rs.getString("permanent_address"));
                    p.put("name", rs.getString("surname") + ", " + rs.getString("given_name") + " " + (rs.getString("middle_name") != null ? rs.getString("middle_name") : ""));
                    // Add other fields as needed for form population
                    searchablePatients.add(p);
                }
            }

            // Fetch all doctors
            String doctorsSql = "SELECT u.user_id, up.surname, up.given_name, up.specialization FROM users u JOIN user_profiles up ON u.user_id = up.user_id WHERE u.user_type = 'Doctor' ORDER BY up.surname, up.given_name";
            try (PreparedStatement ps = conn.prepareStatement(doctorsSql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor doc = new Doctor();
                    doc.setDoctorId(rs.getInt("user_id"));
                    doc.setSurname(rs.getString("surname"));
                    doc.setGivenName(rs.getString("given_name"));
                    doc.setSpecialization(rs.getString("specialization"));
                    doctors.add(doc);
                }
            }

            // Fetch all rooms
            String roomsSql = "SELECT * FROM rooms ORDER BY room_number";
            try (PreparedStatement ps = conn.prepareStatement(roomsSql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    rooms.add(room);
                }
            }

            // Fetch all services
            String servicesSql = "SELECT * FROM services ORDER BY service_name ASC";
            try (PreparedStatement ps = conn.prepareStatement(servicesSql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    services.add(service);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load necessary data for scheduling.");
        }

        request.setAttribute("doctors", doctors);
        request.setAttribute("rooms", rooms);
        request.setAttribute("services", services);
        request.setAttribute("searchablePatients", searchablePatients);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/staff_add_appointment.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO appointments (booked_by_user_id, relative_id, patient_type, last_name, given_name, middle_name, birthday, civil_status, contact_number, reason_for_visit, preferred_date, status, assigned_doctor_id, assigned_room_id, service_name) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                Date preferredDate = Date.valueOf(request.getParameter("preferredDate"));
                Date birthday = Date.valueOf(request.getParameter("birthday"));
                String serviceName = request.getParameter("service");

                // --- Birthday Validation ---
                if (birthday.toLocalDate().isAfter(LocalDate.now())) {
                    response.sendRedirect("staff-add-appointment?error=Birthday cannot be in the future.");
                    return;
                }
                // --- End Birthday Validation ---

                // --- Weekend/Holiday Conflict Check ---
                String unavailableReason = ScheduleValidator.getUnavailableReason(preferredDate, conn);
                if (unavailableReason != null) {
                    response.sendRedirect("staff-add-appointment?error=Cannot schedule on " + preferredDate + " because it is " + unavailableReason + ".");
                    return;
                }
                // --- End Conflict Check ---


                // --- Daily Appointment Limit Check ---
                int appointmentCount = 0;
                String countSql = "SELECT COUNT(*) FROM appointments WHERE preferred_date = ? AND status IN ('Accepted', 'Assigned', 'Completed')";
                try (PreparedStatement psCount = conn.prepareStatement(countSql)) {
                    psCount.setDate(1, preferredDate);
                    try (ResultSet rs = psCount.executeQuery()) {
                        if (rs.next()) {
                            appointmentCount = rs.getInt(1);
                        }
                    }
                }

                if (appointmentCount >= 40) {
                    response.sendRedirect("staff-add-appointment?error=Daily appointment limit of 40 has been reached for " + preferredDate + ". Cannot schedule more appointments for this day.");
                    return;
                }
                // --- End Limit Check ---
                
                String bookedByUserIdStr = request.getParameter("bookedByUserId");
                String relativeIdStr = request.getParameter("relativeId");

                if (relativeIdStr != null && !relativeIdStr.isEmpty()) { // Case 1: It's a relative
                    ps.setInt(1, Integer.parseInt(request.getParameter("bookedByUserIdForRelative"))); // Correctly get the owner's ID
                    ps.setInt(2, Integer.parseInt(relativeIdStr));
                } else if (bookedByUserIdStr != null && !bookedByUserIdStr.isEmpty()) { // Case 2: It's a registered patient
                    ps.setInt(1, Integer.parseInt(bookedByUserIdStr));
                    ps.setNull(2, java.sql.Types.INTEGER);
                } else {
                    // Case 3: It's a new, unregistered person
                    // The appointment is not linked to a user account.
                    // booked_by_user_id is the ID of the staff member who created it.
                    ps.setNull(1, java.sql.Types.INTEGER);
                    ps.setNull(2, java.sql.Types.INTEGER);
                }
                
                ps.setString(3, "N/A"); // Patient type is not relevant for direct scheduling
                ps.setString(4, request.getParameter("lastName"));
                ps.setString(5, request.getParameter("givenName"));
                ps.setString(6, request.getParameter("middleName"));
                ps.setDate(7, Date.valueOf(request.getParameter("birthday")));
                ps.setString(8, request.getParameter("civilStatus"));
                ps.setString(9, request.getParameter("contactNumber"));
                ps.setString(10, request.getParameter("reasonForVisit"));
                ps.setDate(11, preferredDate);
                ps.setString(12, "Accepted"); // status
                ps.setInt(13, Integer.parseInt(request.getParameter("doctorUserId"))); // assigned_doctor_id
                String roomIdStr = request.getParameter("roomId");
                if (roomIdStr != null && !roomIdStr.isEmpty()) {
                    ps.setInt(14, Integer.parseInt(roomIdStr)); // assigned_room_id
                } else {
                    ps.setNull(14, java.sql.Types.INTEGER);
                }

                ps.setString(15, request.getParameter("service")); // service_name

                ps.executeUpdate();
                response.sendRedirect("staff-dashboard?success=Appointment scheduled successfully!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("staff-add-appointment?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff-add-appointment?error=An unexpected error occurred.");
        }
    }
}