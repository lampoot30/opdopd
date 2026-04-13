package com.mycompany.opd;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles user logout by invalidating the session and redirecting to the login page.
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set cache control headers to prevent browser caching of protected pages.
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // Get the current session, but don't create a new one if it doesn't exist.
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidate the session, which removes all session attributes and logs the user out.
            session.invalidate();
        }
        
        // Redirect the user to the login page with a success message.
        response.sendRedirect(request.getContextPath() + "/login.jsp?success=You have been logged out successfully.");
    }

}