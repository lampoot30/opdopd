<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Patient Records - Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: var(--primary-staff-color, #17a2b8); color: white; border-radius: 15px 15px 0 0; }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4"><i class="fas fa-book-medical me-2"></i>Patient Records</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert"><c:out value="${error}"/></div>
        </c:if>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>All Patients</h5>
                <div class="col-md-4">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search for patients...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="patientTable">
                        <thead class="table-light">
                            <tr>
                                <th></th>
                                <th>Name</th>
                                <th>Contact Number</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${patientList}">
                                <tr>
                                    <td>
                                        <img src="<c:url value='${not empty patient.profilePicturePath ? patient.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" 
                                             alt="Profile" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                    </td>
                                    <td><c:out value="${patient.surname}, ${patient.givenName} ${patient.middleName}"/></td>
                                    <td><c:out value="${patient.contactNumber}"/></td>
                                    <td class="text-end">
                                        <a href="<c:url value='/staff-view-patient-detail?patientId=${patient.userId}'/>" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye me-1"></i> View Records
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty patientList}">
                                <tr><td colspan="4" class="text-center text-muted p-4">No patients found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('searchInput').addEventListener('keyup', function() {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll('#patientTable tbody tr');
        rows.forEach(row => {
            const name = row.cells[1].textContent.toLowerCase();
            if (name.includes(filter)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });
</script>
</body>
</html>
