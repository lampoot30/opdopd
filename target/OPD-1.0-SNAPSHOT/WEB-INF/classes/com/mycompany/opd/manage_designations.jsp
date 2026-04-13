<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check is handled by SecurityFilter.
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Designations - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .main-content { padding: 30px; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: #0d6efd; color: white; border-radius: 15px 15px 0 0; }
    </style>
</head>
<body>

<c:import url="admin_navbar.jsp" />

<div class="main-content container-fluid">
    <h1 class="h2 mb-4"><i class="fas fa-id-badge me-2"></i>Manage Staff Designations</h1>

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
        <!-- Add New Designation Card -->
        <div class="col-lg-4 mb-4">
            <div class="card">
                <div class="card-header"><i class="fas fa-plus-circle me-2"></i>Add New Designation</div>
                <div class="card-body">
                    <form action="manage-designations" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label for="designationName" class="form-label">Designation Name</label>
                            <input type="text" class="form-control" id="designationName" name="designationName" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Add Designation</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Existing Designations Card -->
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header"><i class="fas fa-list me-2"></i>Existing Designations</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Designation Name</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${designations}">
                                    <tr>
                                        <td><c:out value="${d.name}"/></td>
                                        <td class="text-end">
                                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editModal" data-id="${d.id}" data-name="${d.name}"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="${d.id}" data-name="${d.name}"><i class="fas fa-trash"></i></button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty designations}">
                                    <tr><td colspan="2" class="text-center text-muted p-4">No designations found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
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
            <form action="manage-designations" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="designationId" id="editDesignationId">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Designation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <label for="editDesignationName" class="form-label">Designation Name</label>
                    <input type="text" class="form-control" id="editDesignationName" name="designationName" required>
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
            <form action="manage-designations" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="designationId" id="deleteDesignationId">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the designation: <strong id="deleteDesignationName"></strong>?
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
        const id = button.getAttribute('data-id');
        const name = button.getAttribute('data-name');
        editModal.querySelector('#editDesignationId').value = id;
        editModal.querySelector('#editDesignationName').value = name;
    });

    // Populate Delete Modal
    const deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', event => {
        const button = event.relatedTarget;
        const id = button.getAttribute('data-id');
        const name = button.getAttribute('data-name');
        deleteModal.querySelector('#deleteDesignationId').value = id;
        deleteModal.querySelector('#deleteDesignationName').textContent = name;
    });
</script>
</body>
</html>