<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --primary-admin-blue: #0d6efd;
        --primary-admin-blue-dark: #0b5ed7;
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
        background-color: var(--primary-admin-blue);
        color: white;
        text-decoration: none;
    }
    .sidebar .nav-link i {
        margin-right: 10px;
        width: 20px;
    }
    .main-content {
        margin-left: 250px; /* This must match the sidebar's width */
        padding: 30px;
    }
</style>

<!-- Sidebar -->
<div class="sidebar no-print">
    <div class="logo-section">
        <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo">
        <h5 class="mb-0 fw-bold" style="color: var(--primary-admin-blue);">AMH Admin Portal</h5>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link ${pageContext.request.servletPath.contains('analytics-overview') ? 'active' : ''}" href="<c:url value='/analytics-overview'/>">
            <i class="fas fa-chart-line"></i> Analytics Overview
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('AddStaffServlet') ? 'active' : ''}" href="<c:url value='/AddStaffServlet'/>">
            <i class="fas fa-user-plus"></i> Add Staff
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('AddDoctorServlet') ? 'active' : ''}" href="<c:url value='/AddDoctorServlet'/>">
            <i class="fas fa-user-md"></i> Add Doctor
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('manage-designations') ? 'active' : ''}" href="<c:url value='/manage-designations'/>">
            <i class="fas fa-id-badge"></i> Manage Designations
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('manage-specializations') ? 'active' : ''}" href="<c:url value='/manage-specializations'/>">
            <i class="fas fa-star"></i> Manage Specializations
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('manage-users') ? 'active' : ''}" href="<c:url value='/manage-users'/>">
            <i class="fas fa-users-cog"></i> Manage Users
        </a>
        <a class="nav-link ${pageContext.request.servletPath.contains('admin-profile') ? 'active' : ''}" href="<c:url value='/admin-profile'/>">
            <i class="fas fa-user-shield"></i> Profile
        </a>
        <hr class="my-3">
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
        const timeoutDuration = 15 * 60 * 1000; // 15 minutes

        function redirectToSessionExpired() {
            window.location.href = '<c:url value="/session_expired.jsp"/>';
        }

        function resetTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(redirectToSessionExpired, timeoutDuration);
        }

        window.onload = resetTimer;
        document.onmousemove = resetTimer;
        document.onkeypress = resetTimer;
        document.onclick = resetTimer;
        document.onscroll = resetTimer;
        document.onfocus = resetTimer;
    })();
</script>
