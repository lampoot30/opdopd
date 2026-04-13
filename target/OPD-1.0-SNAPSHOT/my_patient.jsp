<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check is handled by SecurityFilter.
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Patients - Doctor Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .main-content { margin-left: 250px; padding: 2rem; }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card-header { background-color: #0d6efd; color: white; font-weight: 600; border-top-left-radius: 15px; border-top-right-radius: 15px; }
        .table-hover tbody tr:hover { background-color: #f8f9fa; cursor: pointer; }
    </style>
</head>
<body>

<c:import url="navbar-doctor.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2"><i class="fas fa-users me-2"></i>My Patients</h1>
            <a href="<c:url value='/doctor-dashboard'/>" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                List of Patients with Past or Present Appointments
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Patient Name</th>
                                <th>Contact Number</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${patientList}">
                                <tr>
                                    <td><c:out value="${patient.givenName} ${patient.surname}"/></td>
                                    <td><c:out value="${patient.contactNumber}"/></td>
                                    <td class="text-end">
                                        <a href="<c:url value='/view-patient-records?patientId=${patient.userId}'/>" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-file-medical me-1"></i> View Records
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty patientList}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted p-4">You have not been assigned to any patients yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
