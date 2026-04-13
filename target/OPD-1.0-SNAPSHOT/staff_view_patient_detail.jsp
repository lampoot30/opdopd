<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Patient Records: ${patient.givenName} ${patient.surname}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: var(--primary-staff-color, #17a2b8); color: white; border-radius: 15px 15px 0 0; }
        .profile-header {
            padding: 1.5rem;
            background-color: #fff;
            border-radius: 15px;
            margin-bottom: 1.5rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        .profile-header img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
        }
        .info-label { font-weight: 600; color: #6c757d; }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2">Patient Medical Records</h1>
            <a href="<c:url value='/staff-patient-records'/>" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Back to Patient List</a>
        </div>

        <!-- Patient Profile Header -->
        <div class="profile-header d-flex align-items-center">
            <img src="<c:url value='${not empty patient.profilePicturePath ? patient.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Picture" class="me-4">
            <div>
                <h3 class="mb-0">${patient.givenName} ${patient.surname}</h3>
                <p class="text-muted mb-1">Patient ID: ${patient.userId}</p>
                <p class="mb-0"><i class="fas fa-phone-alt me-2"></i>${patient.contactNumber}</p>
                <p class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>${patient.permanentAddress}</p>
            </div>
        </div>

        <!-- Appointment History -->
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
                                    <td>
                                        <c:if test="${not empty record.givenName}">
                                            Dr. ${record.givenName} ${record.lastName}
                                        </c:if>
                                        <c:if test="${empty record.givenName}">
                                            <span class="text-muted">Not Assigned</span>
                                        </c:if>
                                    </td>
                                    <td><c:out value="${record.reasonForVisit}"/></td>
                                    <td class="text-center">
                                        <span class="badge rounded-pill 
                                            ${record.status == 'Accepted' ? 'bg-success' : ''}
                                            ${record.status == 'Completed' ? 'bg-primary' : ''}
                                            ${record.status == 'Pending' ? 'bg-warning text-dark' : ''}
                                            ${record.status == 'Rejected' ? 'bg-danger' : ''}">
                                            ${record.status}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <a href="<c:url value='/staff-view-appointment-details?id=${record.appointmentId}'/>" class="btn btn-sm btn-outline-info">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty medicalRecords}">
                                <tr><td colspan="6" class="text-center text-muted p-4">No appointment records found for this patient.</td></tr>
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
