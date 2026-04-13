<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (!"Staff".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Rooms - Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-staff-color, #17a2b8); }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Manage Rooms</h1>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">${param.success}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">${param.error}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>

        <div class="row">
            <!-- Add Room Form -->
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header"><h5 class="mb-0">Add New Room</h5></div>
                    <div class="card-body">
                        <form action="manage-rooms" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="mb-3">
                                <label for="roomNumber" class="form-label">Room Number</label>
                                <input type="text" class="form-control" id="roomNumber" name="roomNumber" required>
                            </div>
                            <div class="mb-3">
                                <label for="roomName" class="form-label">Room Name (Optional)</label>
                                <input type="text" class="form-control" id="roomName" name="roomName">
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Add Room</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Rooms List -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header"><h5 class="mb-0">Existing Rooms</h5></div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr><th>Room Number</th><th>Room Name</th><th class="text-end">Actions</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="room" items="${rooms}">
                                        <tr>
                                            <td>${room.roomNumber}</td>
                                            <td>${room.roomName}</td>
                                            <td class="text-end">
                                                <button class="btn btn-sm btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#editRoomModal" data-id="${room.roomId}" data-number="${room.roomNumber}" data-name="${room.roomName}">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <form action="delete-room" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this room?');">
                                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i> Delete</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Room Modal -->
<div class="modal fade" id="editRoomModal" tabindex="-1" aria-labelledby="editRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="edit-room" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="editRoomModalLabel">Edit Room</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="roomId" id="editRoomId">
                    <div class="mb-3">
                        <label for="editRoomNumber" class="form-label">Room Number</label>
                        <input type="text" class="form-control" id="editRoomNumber" name="roomNumber" required>
                    </div>
                    <div class="mb-3">
                        <label for="editRoomName" class="form-label">Room Name (Optional)</label>
                        <input type="text" class="form-control" id="editRoomName" name="roomName">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const editRoomModal = document.getElementById('editRoomModal');
    editRoomModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const id = button.getAttribute('data-id');
        const number = button.getAttribute('data-number');
        const name = button.getAttribute('data-name');

        editRoomModal.querySelector('#editRoomId').value = id;
        editRoomModal.querySelector('#editRoomNumber').value = number;
        editRoomModal.querySelector('#editRoomName').value = name;
    });
</script>
</body>
</html>
