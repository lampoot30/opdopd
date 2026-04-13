<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --primary-staff-color: #6c757d; /* A neutral gray for staff */
        --primary-staff-color-dark: #5a6268;
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
        background-color: var(--primary-staff-color);
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
    }
</style>

<!-- Sidebar -->
<div class="sidebar no-print">
    <div class="logo-section">
        <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo">
        <h5 class="mb-0 fw-bold" style="color: var(--primary-staff-color);">AMH Staff Portal</h5>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link ${pageContext.request.servletPath.contains('staff-dashboard') ? 'active' : ''}" href="<c:url value='/staff-dashboard'/>">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('staff-add-appointment') ? 'active' : ''}" href="<c:url value='/staff-add-appointment'/>">
            <i class="fas fa-calendar-plus"></i> Direct Scheduling
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('staff-patient-records') ? 'active' : ''}" href="<c:url value='/staff-patient-records'/>">
            <i class="fas fa-book-medical"></i> Patient Records
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('manage-rooms') ? 'active' : ''}" href="<c:url value='/manage-rooms'/>">
            <i class="fas fa-door-closed"></i> Manage Rooms
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('staff-profile') ? 'active' : ''}" href="<c:url value='/staff-profile'/>">
            <i class="fas fa-user-shield"></i> My Profile
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
    // --- Session Timeout ---
    (function() {
        let inactivityTimer;
        // This duration should match the <session-timeout> in web.xml (in minutes)
        const timeoutDuration = 15 * 60 * 1000; 

        function redirectToSessionExpired() {
            window.location.href = '<c:url value="/session_expired.jsp"/>';
        }

        function resetTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(redirectToSessionExpired, timeoutDuration);
        }

        // Reset timer on any of these events
        ['load', 'mousemove', 'keypress', 'click', 'scroll', 'focus'].forEach(function(eventName) {
            window.addEventListener(eventName, resetTimer, true); 
        });
    })();
</script>
