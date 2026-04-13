package com.mycompany.opd;

import com.mycompany.opd.models.StaffProfile;
import com.mycompany.opd.models.User;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/archive-staff")
public class ArchiveStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<StaffProfile> staffList = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.contact_number, up.profile_id, up.surname, up.given_name, up.middle_name, up.employee_id " +
                     "FROM users u " +
                     "JOIN user_profiles up ON u.user_id = up.user_id " +
                     "WHERE u.user_type = 'Staff' AND u.status = 'active'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffProfile staff = new StaffProfile();
                staff.setStaffProfileId(rs.getInt("profile_id"));
                staff.setUserId(rs.getInt("user_id"));
                staff.setSurname(rs.getString("surname"));
                staff.setGivenName(rs.getString("given_name"));
                staff.setMiddleName(rs.getString("middle_name"));
                staff.setEmployeeId(rs.getString("employee_id"));
                staff.setContactNumber(rs.getString("contact_number"));
                // Set name as full name
                String name = rs.getString("given_name") + " " + (rs.getString("middle_name") != null ? rs.getString("middle_name") + " " : "") + rs.getString("surname");
                staff.setName(name.trim());
                staff.setId(rs.getInt("user_id")); // Set id to user_id for the JSP
                staffList.add(staff);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load staff data.");
        }

        request.setAttribute("staffList", staffList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/archive_staff.jsp");
        dispatcher.forward(request, response);
    }
}
