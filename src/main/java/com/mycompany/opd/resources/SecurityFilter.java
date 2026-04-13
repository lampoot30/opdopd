package com.mycompany.opd.resources;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    private static final Map<String, List<String>> protectedPaths = new HashMap<>();

    @Override
    public void init(FilterConfig filterConfig) {
        // Define protected paths and the roles that can access them

        // Patient Role
        protectedPaths.put("/patient-dashboard", Arrays.asList("Patient"));
        protectedPaths.put("/patient_dashboard.jsp", Arrays.asList("Patient"));
        protectedPaths.put("/profile", Arrays.asList("Patient"));
        protectedPaths.put("/book_appointment.jsp", Arrays.asList("Patient"));
        protectedPaths.put("/medical-records", Arrays.asList("Patient"));
        protectedPaths.put("/print-appointment", Arrays.asList("Patient"));
        protectedPaths.put("/medical_records.jsp", Arrays.asList("Patient"));

        // Doctor Role
        protectedPaths.put("/doctor-dashboard", Arrays.asList("Doctor")); // This now maps to the servlet
        protectedPaths.put("/doctor_dashboard.jsp", Arrays.asList("Doctor"));
        protectedPaths.put("/doctor-profile", Arrays.asList("Doctor"));
        protectedPaths.put("/my-patient", Arrays.asList("Doctor"));
        protectedPaths.put("/doctor-activity-logs", Arrays.asList("Doctor"));
        protectedPaths.put("/edit-doctor-profile", Arrays.asList("Doctor"));
        protectedPaths.put("/update-doctor-profile", Arrays.asList("Doctor"));
        protectedPaths.put("/view-appointment-doctor", Arrays.asList("Doctor"));
        protectedPaths.put("/view-patient-records", Arrays.asList("Doctor"));
        protectedPaths.put("/complete-appointment", Arrays.asList("Doctor"));

        // Staff Role
        protectedPaths.put("/staff-dashboard", Arrays.asList("Staff"));
        protectedPaths.put("/staff_dashboard.jsp", Arrays.asList("Staff"));
        protectedPaths.put("/view-appointment", Arrays.asList("Staff"));
        protectedPaths.put("/assign-appointment", Arrays.asList("Staff"));
        protectedPaths.put("/staff-patient-records", Arrays.asList("Staff"));
        protectedPaths.put("/staff-add-appointment", Arrays.asList("Staff"));
        protectedPaths.put("/print-request", Arrays.asList("Staff"));
        protectedPaths.put("/staff-profile", Arrays.asList("Staff"));
        protectedPaths.put("/edit-staff-profile", Arrays.asList("Staff"));
        protectedPaths.put("/update-staff-profile", Arrays.asList("Staff"));
        protectedPaths.put("/manage-rooms", Arrays.asList("Staff"));
        protectedPaths.put("/staff-view-patient-detail", Arrays.asList("Staff"));
        protectedPaths.put("/edit-room", Arrays.asList("Staff"));
        protectedPaths.put("/delete-room", Arrays.asList("Staff"));

        // Admin Role
        protectedPaths.put("/analytics-overview", Arrays.asList("Admin"));
        protectedPaths.put("/daily-reports", Arrays.asList("Admin"));
        protectedPaths.put("/daily_reports.jsp", Arrays.asList("Admin"));
        protectedPaths.put("/admin-profile", Arrays.asList("Admin"));
        protectedPaths.put("/AddDoctorServlet", Arrays.asList("Admin"));
        protectedPaths.put("/AddStaffServlet", Arrays.asList("Admin"));
        protectedPaths.put("/print-registration-report", Arrays.asList("Admin"));
        protectedPaths.put("/edit-admin-profile", Arrays.asList("Admin"));
        protectedPaths.put("/update-admin-profile", Arrays.asList("Admin"));
        protectedPaths.put("/edit_admin_profile.jsp", Arrays.asList("Admin"));
        protectedPaths.put("/manage-designations", Arrays.asList("Admin"));
        protectedPaths.put("/manage-specializations", Arrays.asList("Admin"));
        protectedPaths.put("/manage-users", Arrays.asList("Admin"));
        protectedPaths.put("/manage_users.jsp", Arrays.asList("Admin"));
        protectedPaths.put("/archive-user", Arrays.asList("Admin"));
        protectedPaths.put("/admin_profile.jsp", Arrays.asList("Admin"));

        // Super Admin Role
        protectedPaths.put("/super_admin_dashboard.jsp", Arrays.asList("Super Admin"));
        protectedPaths.put("/super-admin-profile", Arrays.asList("Super Admin"));
        protectedPaths.put("/audit-logs", Arrays.asList("Super Admin"));
        protectedPaths.put("/AddAdminServlet", Arrays.asList("Super Admin"));
        protectedPaths.put("/RestoreServlet", Arrays.asList("Super Admin"));
        protectedPaths.put("/delete-admin", Arrays.asList("Super Admin"));

        protectedPaths.put("/edit-super-admin-profile", Arrays.asList("Super Admin"));
        protectedPaths.put("/edit_super_admin_profile.jsp", Arrays.asList("Super Admin"));
        protectedPaths.put("/archive-admin", Arrays.asList("Super Admin"));
        protectedPaths.put("/update-super-admin-profile", Arrays.asList("Super Admin"));
        protectedPaths.put("/manage-archive", Arrays.asList("Super Admin"));
        protectedPaths.put("/restore-user", Arrays.asList("Super Admin"));
        protectedPaths.put("/permanent-delete-user", Arrays.asList("Super Admin"));
        protectedPaths.put("/verify-otp-and-update", Arrays.asList("Super Admin"));
        
        // Path accessible by any logged-in user
        protectedPaths.put("/change-password", Arrays.asList("Patient", "Doctor", "Staff", "Admin", "Super Admin"));
        protectedPaths.put("/verify-password-change", Arrays.asList("Patient", "Doctor", "Staff", "Admin", "Super Admin"));
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String path = request.getServletPath();

        // Allow access to the registration servlet without security checks
        if ("/register".equals(path)) {
            chain.doFilter(req, res);
            return;
        }

        // Check if the path is protected
        List<String> allowedRoles = protectedPaths.get(path);

        if (allowedRoles != null) {
            // This is a protected path, so we must check the session
            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("userType") == null) {
                // No active session, so redirect to login with an access denied message.
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
                return;
            }

            String userType = (String) session.getAttribute("userType");

            if (!allowedRoles.contains(userType)) {
                // User has a session but is not authorized for this page
                // Send a script to show a pop-up alert and then redirect.
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<html><body>");
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Access Denied: You do not have the necessary permissions to view this page.');");
                out.println("window.history.back();"); // Go back to the previous page
                out.println("</script>");
                out.println("</body></html>");
                out.close();
                return;
            }
        }

        // Path is not protected, or user is authorized, so continue the request
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
        protectedPaths.clear();
    }
}