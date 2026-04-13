package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.OtpService;
import com.mycompany.opd.resources.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String submittedOtp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (session == null || session.getAttribute("resetPasswordUserId") == null) {
            response.sendRedirect("login.jsp?error=Your session has expired. Please try again.");
            return;
        }

        if (!OtpService.verifyOtp(session, submittedOtp)) {
            response.sendRedirect("reset_password.jsp?error=Invalid or expired OTP.");
            return;
        }

        if (newPassword == null || newPassword.isEmpty() || !newPassword.equals(confirmPassword)) {
            response.sendRedirect("reset_password.jsp?error=Passwords do not match or are empty.");
            return;
        }

        int userId = (int) session.getAttribute("resetPasswordUserId");
        String hashedPassword = PasswordUtil.hashPassword(newPassword);

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, hashedPassword);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
            
            session.invalidate(); // Invalidate session after successful reset
            response.sendRedirect("login.jsp?success=Password has been reset successfully. You can now log in.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("reset_password.jsp?error=Database error. Could not update password.");
        }
    }
}