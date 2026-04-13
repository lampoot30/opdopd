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
    <title>Staff Dashboard - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-staff-color, #17a2b8); }
        .table-hover tbody tr:hover { background-color: #f8f9fa; }
        .badge-new { background-color: #007bff; }
        .badge-old { background-color: #6c757d; }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Appointment Requests</h1>

        <!-- Display error message if data loading fails -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${error}</div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-clock me-2"></i>Pending Appointments</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Patient Name</th>
                                <th>Patient Type</th>
                                <th>Preferred Date</th>
                                <th>Reason for Visit</th>
                                <th>Services/Clinic</th>
                                <th>Attachment</th>
                                <th>Submitted At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appt" items="${pendingAppointments}">
                                <tr>
                                    <td>${appt.givenName} ${appt.lastName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${appt.patientType == 'New'}">
                                                <span class="badge badge-new text-white">New</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-old text-white">Old</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${appt.preferredDate}</td>
                                    <td>${appt.reasonForVisit}</td>
                                    <td>${appt.servicesClinic}</td>
                                    <td>
                                        <c:if test="${not empty appt.attachmentPath}">
                                            <a href="<c:url value='/${appt.attachmentPath}'/>" download class="btn btn-sm btn-outline-secondary">
                                                <i class="fas fa-download me-1"></i> Download
                                            </a>
                                        </c:if>
                                        <c:if test="${empty appt.attachmentPath}">
                                            <span class="text-muted">None</span>
                                        </c:if>
                                    </td>
                                    <td>${appt.createdAt}</td>
                                    <td>
                                        <a href="<c:url value='/view-appointment?id=${appt.appointmentId}'/>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-edit me-1"></i> Manage
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty pendingAppointments}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted p-4">No pending appointments.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="successModalLabel"><i class="fas fa-check-circle me-2"></i>Success</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="successModalBody">
                <!-- Success message will be injected here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // --- Handle Success Modal ---
        const urlParams = new URLSearchParams(window.location.search);
        const successMessage = urlParams.get('success');

        if (successMessage) {
            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
            document.getElementById('successModalBody').textContent = successMessage;
            successModal.show();

            // Clean the URL to prevent the modal from re-appearing on refresh
            const newUrl = window.location.pathname;
            window.history.replaceState({}, document.title, newUrl);
        }
    });
</script>
</body>
</html>
