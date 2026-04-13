<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (!"Super Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Archive - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin-left: 260px; padding: 2rem; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: #6c757d; color: white; }
    </style>
</head>
<body>

<c:import url="super_admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Manage Archived Accounts</h1>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-archive me-2"></i>Archived Users</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Username</th>
                                <th>User Type</th>
                                <th>Contact Number</th>
                                <th>Date Archived</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${archivedUsers}">
                                <tr>
                                    <td>${user.username}</td>
                                    <td><span class="badge bg-secondary">${user.userType}</span></td>
                                    <td>${user.contactNumber}</td>
                                    <td><fmt:formatDate value="${user.updatedAt}" pattern="MMM dd, yyyy, hh:mm a"/></td>
                                    <td class="text-end">
                                        <form action="<c:url value='/restore-user'/>" method="post" class="d-inline">
                                            <input type="hidden" name="userId" value="${user.userId}">
                                            <button type="submit" class="btn btn-sm btn-outline-success me-2" title="Restore User">
                                                <i class="fas fa-undo"></i> Restore
                                            </button>
                                        </form>
                                        <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#permanentDeleteModal" data-user-id="${user.userId}" data-username="${user.username}">
                                            <i class="fas fa-trash-alt"></i> Delete Permanently
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty archivedUsers}">
                                <tr><td colspan="5" class="text-center text-muted p-4">No archived users found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Permanent Delete Confirmation Modal -->
<div class="modal fade" id="permanentDeleteModal" tabindex="-1" aria-labelledby="permanentDeleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="permanentDeleteModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Confirm Permanent Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>You are about to <strong class="text-danger">permanently delete</strong> the account for <strong id="usernameToDelete" class="text-danger"></strong>.</p>
                <p class="fw-bold">This action cannot be undone and the user data will be lost forever.</p>
                <p>Are you absolutely sure you want to proceed?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="permanentDeleteForm" action="<c:url value='/permanent-delete-user'/>" method="post" class="d-inline">
                    <input type="hidden" name="userId" id="userIdToPermanentlyDelete">
                    <button type="submit" class="btn btn-danger"><i class="fas fa-skull-crossbones me-2"></i>Yes, Delete Permanently</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const permanentDeleteModal = document.getElementById('permanentDeleteModal');
    permanentDeleteModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const userId = button.getAttribute('data-user-id');
        const username = button.getAttribute('data-username');

        permanentDeleteModal.querySelector('#userIdToPermanentlyDelete').value = userId;
        permanentDeleteModal.querySelector('#usernameToDelete').textContent = username;
    });
</script>
</body>
</html>
