<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // This scriptlet ensures the displayUsername is set for the navbar if it's not already.
    if (session.getAttribute("username") != null && session.getAttribute("displayUsername") == null) {
        try {
            String decryptedUsername = com.mycompany.opd.resources.SessionEncryptionUtil.decrypt((String) session.getAttribute("username"));
            session.setAttribute("displayUsername", decryptedUsername);
        } catch (Exception e) {
            // Ignore - the main page will handle the error
        }
    }
%>
<style>
    :root {
        --primary-green: #28a745;
        --primary-green-dark: #218838;
    }
    .sidebar {
        width: 250px;
        height: 100vh;
        background-color: #fff;
        box-shadow: 2px 0 15px rgba(0, 0, 0, 0.05);
        position: fixed;
        left: 0;
        top: 0;
        z-index: 1000;
        padding: 20px 0;
        overflow-y: auto;
    }
    .sidebar .logo-section {
        text-align: center;
        padding: 20px;
        border-bottom: 1px solid #e0e0e0;
        margin-bottom: 20px;
    }
    .sidebar .logo-section img {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        margin-bottom: 10px;
    }
    .sidebar .nav-link {
        color: #333;
        padding: 12px 25px;
        margin: 5px 15px;
        border-radius: 8px;
        transition: all 0.3s ease;
        font-weight: 500;
    }
    .sidebar .nav-link:hover,
    .sidebar .nav-link.active {
        background-color: var(--primary-green);
        color: white;
        text-decoration: none;
    }
    .sidebar .nav-link i {
        margin-right: 10px;
        width: 20px;
    }

    .main-content {
        margin-left: 250px;
        padding: 30px;
        min-height: 100vh;
    }
    @media (max-width: 768px) {
        .sidebar {
            width: 100%;
            height: auto;
            position: relative;
        }
        .main-content {
            margin-left: 0;
        }
    }
</style>

<!-- Sidebar -->
<div class="sidebar no-print">
    <div class="logo-section">
        <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo">
        <h5 class="mb-0 fw-bold text-success">AMH Patient Portal</h5>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link ${pageContext.request.servletPath.endsWith('/patient_dashboard.jsp') ? 'active' : ''}" href="<c:url value='/patient-dashboard'/>">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a class="nav-link ${pageContext.request.servletPath.endsWith('/book_appointment.jsp') ? 'active' : ''}" href="<c:url value='/services'/>">
            <i class="fas fa-calendar-plus"></i> Book Appointment
        </a>
        <a class="nav-link ${pageContext.request.servletPath.endsWith('/add_my_relatives.jsp') ? 'active' : ''}" href="<c:url value='/my-relatives'/>">
            <i class="fas fa-users-cog"></i> Manage Relatives
        </a>
        <a class="nav-link ${pageContext.request.servletPath.endsWith('/medical_records.jsp') ? 'active' : ''}" href="<c:url value='/medical-records'/>">
            <i class="fas fa-file-medical"></i> View Medical Record
        </a>
        <a class="nav-link ${pageContext.request.servletPath.endsWith('/patient_profile.jsp') ? 'active' : ''}" href="<c:url value='/profile'/>">
            <i class="fas fa-user"></i> Profile
        </a>
               <hr class="my-3">
        <a class="nav-link text-danger" href="#" data-bs-toggle="modal" data-bs-target="#logoutModalDoctor">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>


<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutModalDoctor" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="logoutModalLabel"><i class="fas fa-exclamation-triangle text-warning me-2"></i>Confirm Logout</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to log out?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="<c:url value='/LogoutServlet'/>" class="btn btn-danger">Yes, Logout</a>
            </div>
        </div>
    </div>
</div>


<script>
    (function() {
        let inactivityTimer;
        // The timeout duration in milliseconds. 5 minutes = 300,000 ms.
        // This should match the session-timeout in your web.xml.
        const timeoutDuration = 15 * 60 * 1000;

        function redirectToSessionExpired() {
            // Redirect to the session expired page
            window.location.href = '<c:url value="/session_expired.jsp"/>';
        }

        function resetTimer() {
            // Clear the previous timer and start a new one
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(redirectToSessionExpired, timeoutDuration);
        }

        // Events that reset the inactivity timer
        window.onload = resetTimer;
        document.onmousemove = resetTimer;
        document.onkeypress = resetTimer;
        document.onclick = resetTimer;
        document.onscroll = resetTimer;
        document.onfocus = resetTimer;
    })();
</script>
