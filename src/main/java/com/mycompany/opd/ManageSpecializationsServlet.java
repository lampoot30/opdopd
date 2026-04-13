package com.mycompany.opd;

import com.mycompany.opd.models.Specialization;
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

@WebServlet("/manage-specializations")
public class ManageSpecializationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Specialization> specializations = new ArrayList<>();
        String sql = "SELECT * FROM specializations ORDER BY specialization_name ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                specializations.add(new Specialization(rs.getInt("specialization_id"), rs.getString("specialization_name")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load specializations.");
        }

        request.setAttribute("specializations", specializations);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manage_specializations.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addSpecialization(request, response);
                break;
            case "update":
                updateSpecialization(request, response);
                break;
            case "delete":
                deleteSpecialization(request, response);
                break;
            default:
                response.sendRedirect("manage-specializations?error=Invalid action.");
                break;
        }
    }

    private void addSpecialization(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("specializationName");
        String sql = "INSERT INTO specializations (specialization_name) VALUES (?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
            response.sendRedirect("manage-specializations?success=Specialization added successfully.");
        } catch (SQLException e) {
            if (e.getSQLState().equals("23000")) {
                response.sendRedirect("manage-specializations?error=A specialization with that name already exists.");
            } else {
                e.printStackTrace();
                response.sendRedirect("manage-specializations?error=Database error occurred.");
            }
        }
    }

    private void updateSpecialization(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("specializationId"));
        String name = request.getParameter("specializationName");
        String sql = "UPDATE specializations SET specialization_name = ? WHERE specialization_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            ps.executeUpdate();
            response.sendRedirect("manage-specializations?success=Specialization updated successfully.");
        } catch (SQLException e) {
            if (e.getSQLState().equals("23000")) {
                response.sendRedirect("manage-specializations?error=A specialization with that name already exists.");
            } else {
                e.printStackTrace();
                response.sendRedirect("manage-specializations?error=Database error occurred.");
            }
        }
    }

    private void deleteSpecialization(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("specializationId"));
        String sql = "DELETE FROM specializations WHERE specialization_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("manage-specializations?success=Specialization deleted successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage-specializations?error=Database error occurred. The specialization might be in use.");
        }
    }
}