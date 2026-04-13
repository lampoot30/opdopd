package com.mycompany.opd;

import com.mycompany.opd.models.Designation;
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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/manage-designations")
public class ManageDesignationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Designation> designations = new ArrayList<>();
        String sql = "SELECT * FROM designations ORDER BY designation_name ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                designations.add(new Designation(rs.getInt("designation_id"), rs.getString("designation_name")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load designations.");
        }

        request.setAttribute("designations", designations);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manage_designations.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("manage-designations?error=Invalid action.");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addDesignation(request, response);
                    break;
                case "update":
                    updateDesignation(request, response);
                    break;
                case "delete":
                    deleteDesignation(request, response);
                    break;
                default:
                    response.sendRedirect("manage-designations?error=Unknown action.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getSQLState().equals("23000")) { // Unique constraint violation
                response.sendRedirect("manage-designations?error=Designation name already exists.");
            } else {
                response.sendRedirect("manage-designations?error=Database error occurred.");
            }
        }
    }

    private void addDesignation(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String name = request.getParameter("designationName");
        String sql = "INSERT INTO designations (designation_name) VALUES (?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
        }
        response.sendRedirect("manage-designations?success=Designation added successfully.");
    }

    private void updateDesignation(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("designationId"));
        String name = request.getParameter("designationName");
        String sql = "UPDATE designations SET designation_name = ? WHERE designation_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
        response.sendRedirect("manage-designations?success=Designation updated successfully.");
    }

    private void deleteDesignation(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("designationId"));
        String sql = "DELETE FROM designations WHERE designation_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
        response.sendRedirect("manage-designations?success=Designation deleted successfully.");
    }
}