package com.mycompany.opd;

import com.mycompany.opd.models.User;
import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.ConfigUtil;
import com.mycompany.opd.resources.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/RestoreServlet")
@MultipartConfig
public class RestoreServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String confirmationPassword = request.getParameter("confirmationPassword");
        Part backupFilePart = request.getPart("backupFile");

        // 1. Check if the user is logged in and is a Super Admin
        if (session == null || session.getAttribute("userId") == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Authentication failed. Please log in again.");
            return;
        }

        int loggedInUserId = (int) session.getAttribute("userId");

        if (confirmationPassword == null || confirmationPassword.trim().isEmpty() || backupFilePart == null || backupFilePart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=Password confirmation and a backup file are required.");
            return;
        }

        // 2. Validate the provided password against the user's actual password hash from the database
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT password FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, loggedInUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String storedHashedPassword = rs.getString("password");
                        if (!PasswordUtil.verifyPassword(confirmationPassword, storedHashedPassword)) {
                            response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=Incorrect password. Please try again.");
                            return;
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=User not found.");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the exception
            response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=Database error during password verification: " + e.getMessage());
            return;
        }

        // 3. If password is correct, proceed with the restore logic
        // TODO: Implement the actual database restore logic here.
        // This would involve unzipping the file, reading the SQL, and executing it.
        // You would need to use the 'confirmationPassword' to decrypt the zip file.
        
        response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?success=Restore process initiated successfully.");
    }
}