<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Medical Records for ${relativeName} - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin-left: 260px; padding: 2rem; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-green, #28a745); }
        .status-badge { font-size: 0.85em; padding: 0.5em 0.8em; }
    </style>
</head>
<body>

<c:import url="navbar-patient.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2">Medical Records for <span class="text-success">${relativeName}</span></h1>
            <a href="<c:url value='/my-relatives'/>" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Back to Manage Relatives</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-history me-2"></i>Appointment History</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Appointment ID</th>
                                <th>Date</th>
                                <th>Doctor</th>
                                <th>Reason for Visit</th>
                                <th class="text-center">Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="record" items="${medicalRecords}">
                                <tr>
                                    <td>#${record.appointmentId}</td>
                                    <td><fmt:formatDate value="${record.preferredDate}" pattern="MMMM dd, yyyy"/></td>
                                    <td>${record.givenName} ${record.lastName}</td>
                                    <td><c:out value="${record.reasonForVisit}"/></td>
                                    <td class="text-center">
                                        <span class="badge rounded-pill bg-${record.status == 'Accepted' ? 'success' : (record.status == 'Completed' ? 'primary' : (record.status == 'Rejected' ? 'danger' : 'secondary'))} status-badge">
                                            ${record.status}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <c:if test="${record.status == 'Accepted'}">
                                            <a href="<c:url value='/print-appointment?id=${record.appointmentId}'/>" class="btn btn-sm btn-outline-primary" target="_blank"><i class="fas fa-print"></i> Print</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty medicalRecords}">
                                <tr><td colspan="5" class="text-center text-muted p-4">No medical records found for this relative.</td></tr>
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
