<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check is handled by SecurityFilter.
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Users - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: #0d6efd; color: white; border-radius: 15px 15px 0 0; }
        .user-type-badge { font-size: 0.8rem; }
    </style>
</head>
<body>

<c:import url="admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4"><i class="fas fa-users-cog me-2"></i>Manage User Accounts</h1>

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
            <div class="card-header"><i class="fas fa-list me-2"></i>Active User Accounts</div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th></th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>User Type</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td>
                                        <img src="<c:url value='${not empty user.profilePicturePath ? user.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" 
                                             alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                    </td>
                                    <td><c:out value="${user.givenName} ${user.surname}"/></td>
                                    <td><c:out value="${user.username}"/></td>
                                    <td>
                                        <span class="badge rounded-pill 
                                            ${user.userType == 'Doctor' ? 'bg-info' : ''}
                                            ${user.userType == 'Staff' ? 'bg-secondary' : ''}
                                            ${user.userType == 'Patient' ? 'bg-success' : ''}
                                            user-type-badge">
                                            <c:out value="${user.userType}"/>
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-sm btn-outline-warning" data-bs-toggle="modal" data-bs-target="#archiveUserModal" data-user-id="${user.userId}" data-username="<c:out value="${user.username}"/>">
                                            <i class="fas fa-archive"></i> Archive
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty userList}">
                                <tr><td colspan="5" class="text-center text-muted p-4">No active users found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Archive Confirmation Modal -->
<div class="modal fade" id="archiveUserModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title"><i class="fas fa-archive me-2"></i>Confirm Archive</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to archive the user: <strong id="usernameToArchive"></strong>?</p>
                <p>This will disable their account and prevent them from logging in.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="<c:url value='/archive-user'/>" method="post" class="d-inline">
                    <input type="hidden" name="userId" id="userIdToArchive">
                    <button type="submit" class="btn btn-warning">Yes, Archive User</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const archiveUserModal = document.getElementById('archiveUserModal');
    archiveUserModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const userId = button.getAttribute('data-user-id');
        const username = button.getAttribute('data-username');
        archiveUserModal.querySelector('#userIdToArchive').value = userId;
        archiveUserModal.querySelector('#usernameToArchive').textContent = username;
    });
</script>
</body>
</html>
