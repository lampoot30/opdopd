package com.mycompany.opd;

import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.resources.PasswordUtil;
import com.mycompany.opd.resources.AuditLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contactNumber = request.getParameter("contactNumber");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT user_id, username, password, user_type, status, session_id, failed_login_attempts, account_locked_until FROM users WHERE contact_number = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, contactNumber);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Timestamp lockedUntil = rs.getTimestamp("account_locked_until");
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String status = rs.getString("status");

                // 1. Check if the account is currently locked
                if (lockedUntil != null && lockedUntil.after(new Timestamp(System.currentTimeMillis()))) {
                    response.sendRedirect("login.jsp?error=Account is locked. Please try again later.");
                    return;
                }

                // 2. Check if the account is active
                if (!"active".equals(status)) {
                    response.sendRedirect("account_suspended.jsp");
                    return;
                }

                String storedHashedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(password, storedHashedPassword)) {
                    // --- Successful Login ---
                    String userType = rs.getString("user_type");
                    String existingSessionId = rs.getString("session_id");

                    // 2. Check for concurrent login
                    if (existingSessionId != null) {
                        response.sendRedirect("login.jsp?error=User is already logged in on another device.");
                        return;
                    }

                    // 3. Reset any failed login attempts and unlock account
                    String resetSql = "UPDATE users SET failed_login_attempts = 0, account_locked_until = NULL WHERE username = ?";
                    try (PreparedStatement resetPs = conn.prepareStatement(resetSql)) {
                        resetPs.setString(1, username);
                        resetPs.executeUpdate();
                    }

                    // 4. Prevent session fixation: invalidate old session and create a new one
                    HttpSession oldSession = request.getSession(false);
                    if (oldSession != null) {
                        oldSession.invalidate();
                    }
                    HttpSession session = request.getSession(true); // Create a new session

                    // Store secure attributes. Rely on userId as the primary identifier.
                    session.setAttribute("username", username);
                    session.setAttribute("displayUsername", username);
                    session.setAttribute("userId", userId);
                    session.setAttribute("userType", userType);

                    // 6. Handle "Remember Me" functionality with a cookie
                    if ("on".equals(rememberMe)) {
                        // Create a cookie to remember the contact number
                        Cookie rememberMeCookie = new Cookie("rememberedContact", contactNumber);
                        rememberMeCookie.setMaxAge(30 * 24 * 60 * 60); // Set cookie to last for 30 days
                        response.addCookie(rememberMeCookie);
                    } else {
                        // If "Remember Me" is not checked, delete the cookie
                        Cookie rememberMeCookie = new Cookie("rememberedContact", null);
                        rememberMeCookie.setMaxAge(0); // Expire the cookie immediately
                        response.addCookie(rememberMeCookie);
                    }


                    String updateSessionSql = "UPDATE users SET session_id = ? WHERE username = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSessionSql)) {
                        updatePs.setString(1, session.getId());
                        updatePs.setString(2, username);
                        updatePs.executeUpdate();
                    }
                    
                    // 5. Log the successful login action
                    AuditLogger.log(userId, username, userType, "User logged in"); // This is now step 7

                    // 8. Redirect user to their dashboard
                    if ("Patient".equals(userType) || "Patient Or Guardian".equals(userType)) {
                        response.sendRedirect("patient-dashboard");
                    } else if ("Super Admin".equals(userType)) {
                        response.sendRedirect("super-admin-dashboard"); // Correct
                    } else if ("Admin".equals(userType)) {
                        response.sendRedirect("analytics-overview");
                    } else if ("Doctor".equals(userType)) {
                        response.sendRedirect("doctor-dashboard");
                    } else if ("Staff".equals(userType)) {
                        response.sendRedirect("staff-dashboard");
                    } else {
                        response.sendRedirect("index.jsp?error=Dashboard for your user type is not available.");
                    }
                } else {
                    // --- Failed Login ---
                    int failedAttempts = rs.getInt("failed_login_attempts") + 1;
                    String lockSql;

                    if (failedAttempts >= 5) {
                        // Lock account for 15 minutes
                        lockSql = "UPDATE users SET failed_login_attempts = ?, account_locked_until = ? WHERE username = ?";
                        try (PreparedStatement lockPs = conn.prepareStatement(lockSql)) {
                            lockPs.setInt(1, failedAttempts);
                            lockPs.setTimestamp(2, new Timestamp(System.currentTimeMillis() + 15 * 60 * 1000)); // 15 minutes
                            lockPs.setString(3, username);
                            lockPs.executeUpdate();
                        }
                        response.sendRedirect("login.jsp?error=Account has been locked due to too many failed attempts.");
                    } else {
                        // Increment failed attempts count
                        lockSql = "UPDATE users SET failed_login_attempts = ? WHERE username = ?";
                        try (PreparedStatement lockPs = conn.prepareStatement(lockSql)) {
                            lockPs.setInt(1, failedAttempts);
                            lockPs.setString(2, username);
                            lockPs.executeUpdate();
                        }
                        response.sendRedirect("login.jsp?error=Invalid contact number or password.");
                    }
                }
            } else {
                // No user found with that contact number
                // This is also a failed login attempt, but we can't track it against a user.
                // We just show the generic error.
                response.sendRedirect("login.jsp?error=Invalid contact number or password.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error. Please try again later.");
        }
    }
}
