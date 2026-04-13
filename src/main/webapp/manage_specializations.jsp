<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check is handled by SecurityFilter.
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Specializations - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: #0d6efd; color: white; border-radius: 15px 15px 0 0; }
    </style>
</head>
<body>

<c:import url="admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4"><i class="fas fa-star me-2"></i>Manage Doctor Specializations</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <c:out value="${param.error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <c:out value="${param.success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- Add New Specialization Card -->
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header"><i class="fas fa-plus-circle me-2"></i>Add New Specialization</div>
                    <div class="card-body">
                        <form action="manage-specializations" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="mb-3">
                                <label for="specializationName" class="form-label">Specialization Name</label>
                                <input type="text" class="form-control" id="specializationName" name="specializationName" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Add Specialization</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Existing Specializations Card -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header"><i class="fas fa-list me-2"></i>Existing Specializations</div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Specialization Name</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${specializations}">
                                        <tr>
                                            <td><c:out value="${s.specializationName}"/></td>
                                            <td class="text-end">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editModal" data-id="${s.specializationId}" data-name="${s.specializationName}"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="${s.specializationId}" data-name="${s.specializationName}"><i class="fas fa-trash"></i></button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty specializations}">
                                        <tr><td colspan="2" class="text-center text-muted p-4">No specializations found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="manage-specializations" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="specializationId" id="editSpecializationId">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Specialization</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <label for="editSpecializationName" class="form-label">Specialization Name</label>
                    <input type="text" class="form-control" id="editSpecializationName" name="specializationName" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="manage-specializations" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="specializationId" id="deleteSpecializationId">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the specialization: <strong id="deleteSpecializationName"></strong>?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Populate Edit Modal
    const editModal = document.getElementById('editModal');
    editModal.addEventListener('show.bs.modal', event => {
        const button = event.relatedTarget;
        editModal.querySelector('#editSpecializationId').value = button.getAttribute('data-id');
        editModal.querySelector('#editSpecializationName').value = button.getAttribute('data-name');
    });

    // Populate Delete Modal
    const deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', event => {
        const button = event.relatedTarget;
        deleteModal.querySelector('#deleteSpecializationId').value = button.getAttribute('data-id');
        deleteModal.querySelector('#deleteSpecializationName').textContent = button.getAttribute('data-name');
    });
</script>
</body>
</html>
