<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Set cache control headers to prevent browser caching of this page.
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    // Security check: only allow Super Admin users to access this page.
    Object userType = session.getAttribute("userType");
    if (userType == null) {
        // Session has expired or user is not logged in
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Your session has expired. Please log in again.");
    } else if (!"Super Admin".equals(userType)) {
        // User is logged in but does not have the correct role
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied. You do not have permission to view this page.");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Super Admin Dashboard - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        .card-header {
            font-weight: 600;
            background-color: var(--primary-admin-blue, #0d6efd);
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .btn-submit {
            background-color: var(--primary-admin-blue, #0d6efd);
            border-color: var(--primary-admin-blue, #0d6efd);
            color: white;
        }
        .btn-submit:hover {
            background-color: var(--primary-admin-blue-dark, #0b5ed7);
            border-color: var(--primary-admin-blue-dark, #0b5ed7);
        }
        .password-strength {
            font-size: 0.85rem;
            font-weight: 500;
        }
        .strength-weak {
            color: #dc3545;
        }
        .strength-medium {
            color: #ffc107;
        }
        .strength-strong {
            color: #198754;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            font-weight: 500;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<c:import url="super_admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Super Admin Dashboard</h1>

        <!-- Display success or error messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><c:out value="${param.success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${param.error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="fas fa-users-cog me-2"></i>Manage Existing Admin Accounts</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Profile Picture</th>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Contact Number</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="admin" items="${adminList}">
                            <tr>
                                <td>
                                    <img src="<c:url value='${not empty admin.profilePicturePath ? admin.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" 
                                         alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                </td>
                                <td><c:out value="${admin.givenName}"/> <c:out value="${admin.middleName}"/> <c:out value="${admin.surname}"/></td>
                                <td><c:out value="${admin.user.username}"/></td>
                                <td><c:out value="${admin.user.contactNumber}"/></td>
                                <td>

                                    <button type="button" class="btn btn-sm btn-outline-warning" data-bs-toggle="modal" data-bs-target="#archiveAdminModal" data-user-id="${admin.userId}" data-username="${admin.user.username}">
                                        <i class="fas fa-archive"></i> Archive
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requestScope.adminList}">
                            <tr>
                                <td colspan="5" class="text-center text-muted p-4">No other Admin accounts found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<!-- Archive Confirmation Modal -->
<div class="modal fade" id="archiveAdminModal" tabindex="-1" aria-labelledby="archiveAdminModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title" id="archiveAdminModalLabel"><i class="fas fa-archive me-2"></i>Confirm Archiving</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>You are about to archive the admin account for <strong id="adminUsernameToArchive" class="text-dark"></strong>.</p>
                <p>This will disable their account and prevent them from logging in. You can restore their account later from the 'Manage Archive' page.</p>
                <p>Are you sure you want to proceed?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="archiveAdminForm" action="<c:url value='/archive-admin'/>" method="post" class="d-inline">
                    <input type="hidden" name="userId" id="userIdToArchive">
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-archive me-2"></i>Yes, Archive Admin
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Script to pass data to the archive confirmation modal
    const archiveAdminModal = document.getElementById('archiveAdminModal');
    archiveAdminModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const userId = button.getAttribute('data-user-id');
        const username = button.getAttribute('data-username');

        const modalUserIdInput = archiveAdminModal.querySelector('#userIdToArchive');
        const modalUsernameSpan = archiveAdminModal.querySelector('#adminUsernameToArchive');

        modalUserIdInput.value = userId;
        modalUsernameSpan.textContent = username;
    });
</script>

</body>
</html>
