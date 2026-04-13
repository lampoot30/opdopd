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
    } else if (!"Super Admin".equals(userType) && !"Admin".equals(userType)) {
        // User is logged in but does not have the correct role
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied. You do not have permission to view this page.");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Management - AMH Hospital</title>
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
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<c:choose>
    <c:when test="${sessionScope.userType == 'Super Admin'}">
        <c:import url="super_admin_navbar.jsp" />
    </c:when>
    <c:otherwise>
        <c:import url="admin_navbar.jsp" />
    </c:otherwise>
</c:choose>

<div class="main-content">
    <div class="container-fluid">
        <c:if test="${sessionScope.userType == 'Super Admin'}">
            <h1 class="h2 mb-4">Admin User Management</h1>
            <div class="card mt-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-users-cog me-2"></i>Existing Admin Accounts</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>User ID</th>
                                    <th>Username</th>
                                    <th>Contact Number</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="admin" items="${adminList}">
                                    <tr>
                                        <td><c:out value="${admin.userId}"/></td>
                                        <td><c:out value="${admin.username}"/></td>
                                        <td><c:out value="${admin.contactNumber}"/></td>
                                        <td><span class="badge bg-${admin.status == 'active' ? 'success' : 'secondary'}"><c:out value="${admin.status}"/></span></td>
                                        <td><c:out value="${admin.createdAt}"/></td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteAdminModal" data-user-id="${admin.userId}" data-username="${admin.username}" title="Delete Admin">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty adminList}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">No Admin users found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteAdminModal" tabindex="-1" aria-labelledby="deleteAdminModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="deleteAdminModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>You are about to permanently delete the admin account for <strong id="adminUsernameToDelete" class="text-dark"></strong>.</p>
                <p class="text-danger fw-bold">This action cannot be undone.</p>
                <p>Are you sure you want to proceed?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteAdminForm" action="<c:url value='/delete-admin'/>" method="post" class="d-inline">
                    <input type="hidden" name="userId" id="userIdToDelete">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Yes, Delete Admin
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Script to pass data to the delete confirmation modal
    const deleteAdminModal = document.getElementById('deleteAdminModal');
    deleteAdminModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const userId = button.getAttribute('data-user-id');
        const username = button.getAttribute('data-username');

        const modalUserIdInput = deleteAdminModal.querySelector('#userIdToDelete');
        const modalUsernameSpan = deleteAdminModal.querySelector('#adminUsernameToDelete');

        modalUserIdInput.value = userId;
        modalUsernameSpan.textContent = username;
    });
</script>
</body>
</html>
