<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Appointment Details - Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-staff-color, #17a2b8); }
        .list-group-item { border-left: 0; border-right: 0; }
        .list-group-item strong { min-width: 150px; display: inline-block; }
        .status-badge {
            font-size: 0.9em;
            padding: 0.5em 1em;
        }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2">Appointment Details</h1>
            <a href="javascript:history.back()" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Back</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${error}</div>
        </c:if>

        <div class="row">
            <!-- Appointment Details -->
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-calendar-check me-2"></i>Appointment Information</h5>
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item"><strong>Appointment ID:</strong> #${appointment.appointmentId}</li>
                            <li class="list-group-item"><strong>Patient Name:</strong> ${appointment.givenName} ${appointment.middleName} ${appointment.lastName}</li>
                            <li class="list-group-item"><strong>Patient Type:</strong>
                                <span class="badge ${appointment.patientType == 'New' ? 'bg-primary' : 'bg-secondary'}">${appointment.patientType}</span>
                            </li>
                            <li class="list-group-item"><strong>Preferred Date:</strong>
                                <fmt:formatDate value="${appointment.preferredDate}" pattern="MMMM dd, yyyy"/>
                            </li>
                            <li class="list-group-item"><strong>Reason for Visit:</strong> ${appointment.reasonForVisit}</li>
                            <li class="list-group-item"><strong>Service/Clinic:</strong> ${appointment.servicesClinic}</li>
                            <li class="list-group-item"><strong>Status:</strong>
                                <span class="badge status-badge
                                    ${appointment.status == 'Accepted' ? 'bg-success' : ''}
                                    ${appointment.status == 'Completed' ? 'bg-primary' : ''}
                                    ${appointment.status == 'Pending' ? 'bg-warning text-dark' : ''}
                                    ${appointment.status == 'Rejected' ? 'bg-danger' : ''}">
                                    ${appointment.status}
                                </span>
                            </li>
                            <li class="list-group-item"><strong>Created At:</strong>
                                <fmt:formatDate value="${appointment.createdAt}" pattern="MMMM dd, yyyy 'at' hh:mm a"/>
                            </li>
                            <c:if test="${not empty appointment.assignedDoctorName}">
                                <li class="list-group-item"><strong>Assigned Doctor:</strong> Dr. ${appointment.assignedDoctorName}</li>
                            </c:if>
                            <c:if test="${not empty appointment.assignedRoomName}">
                                <li class="list-group-item"><strong>Assigned Room:</strong> ${appointment.assignedRoomName}</li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="<c:url value='/staff-view-patient-detail?patientId=${appointment.bookedByUserId}'/>" 
                               class="btn btn-outline-info ${empty appointment.bookedByUserId ? 'disabled' : ''}"
                               aria-disabled="${empty appointment.bookedByUserId ? 'true' : 'false'}">
                                <i class="fas fa-user me-2"></i>View Patient Profile
                            </a>                            
                            <c:if test="${appointment.status == 'Pending'}">
                                <a href="<c:url value='/view-appointment?id=${appointment.appointmentId}'/>" class="btn btn-outline-success">
                                    <i class="fas fa-edit me-2"></i>Manage Appointment
                                </a>
                            </c:if>
                            <a href="<c:url value='/print-staff-appointment-details?appointmentId=${appointment.appointmentId}'/>" target="_blank" class="btn btn-outline-secondary">
                                <i class="fas fa-print me-2"></i>Print Details
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
