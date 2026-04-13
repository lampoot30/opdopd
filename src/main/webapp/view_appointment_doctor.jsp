<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Period" %>
<%@ page import="java.time.ZoneId" %>
<%
    // Security check
    if (!"Doctor".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }

    // Age Calculation Logic
    com.mycompany.opd.models.Appointment appointment = (com.mycompany.opd.models.Appointment) request.getAttribute("appointment");
    String patientAgeDisplay = "N/A";
    if (appointment != null && appointment.getBirthday() != null) {
        try {
            LocalDate birthDate = new java.sql.Date(appointment.getBirthday().getTime()).toLocalDate();
            LocalDate currentDate = LocalDate.now();
            Period period = Period.between(birthDate, currentDate);

            int years = period.getYears();
            int months = period.getMonths();
            int days = period.getDays();

            if (years >= 2) {
                patientAgeDisplay = years + " years old";
            } else if (years == 1) {
                patientAgeDisplay = "1 year " + months + " months old";
            } else { // Less than 1 year old
                if (months >= 1) {
                    patientAgeDisplay = months + " months " + days + " days old";
                } else {
                    patientAgeDisplay = days + " days old";
                }
            }
        } catch (Exception e) {
            // In case of any error, it will default to "N/A"
            getServletContext().log("Error calculating patient age in view_appointment_doctor.jsp", e);
        }
    }
    pageContext.setAttribute("patientAgeDisplay", patientAgeDisplay);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointment Details - Doctor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .main-content {
            margin-left: 250px; /* This should match the sidebar's width */
            padding: 2rem;
        }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card-header { background-color: #0d6efd; color: white; font-weight: 600; border-top-left-radius: 15px; border-top-right-radius: 15px; }
        .info-label { font-weight: 600; color: #6c757d; }
    </style>
</head>
<body>

<c:import url="navbar-doctor.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2"><i class="fas fa-calendar-check me-2"></i>Appointment Details</h1>
            <a href="<c:url value='/doctor-dashboard'/>" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">${param.error}</div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>

        <div class="card">
            <div class="card-header">
                Appointment for <c:out value="${appointment.givenName} ${appointment.lastName}"/> on <fmt:formatDate value="${appointment.preferredDate}" pattern="MMMM dd, yyyy"/>
            </div>
            <div class="card-body p-4">
                <h5 class="mb-4">Patient & Visit Information</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="info-label">Patient Name</div>
                        <div><c:out value="${appointment.givenName} ${appointment.lastName}"/></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="info-label">Age</div>
                        <div>${patientAgeDisplay}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="info-label">Gender</div>
                        <div><c:out value="${appointment.patientGender}"/></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="info-label">Contact Number</div>
                        <div><c:out value="${appointment.patientContactNumber}"/></div>
                    </div>
                    <div class="col-12 mb-3">
                        <div class="info-label">Address</div>
                        <div><c:out value="${appointment.patientAddress}"/></div>
                    </div>
                    <div class="col-12 mb-3">
                        <div class="info-label">Reason for Visit</div>
                        <div><c:out value="${appointment.reasonForVisit}"/></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="info-label">Appointment Status</div>
                        <div><span class="badge bg-primary fs-6"><c:out value="${appointment.status}"/></span></div>
                    </div>
                    <c:if test="${not empty room.roomNumber}">
                        <div class="col-md-6 mb-3">
                            <div class="info-label">Assigned Room</div>
                            <div>
                                <i class="fas fa-door-open me-2 text-muted"></i><c:out value="${room.roomNumber}"/> - <c:out value="${room.roomName}"/>
                            </div>
                        </div>
                    </c:if>
                </div>

                <hr class="my-4">

                <h5 class="mb-3">Actions</h5>
                <c:if test="${appointment.status != 'Completed' && appointment.status != 'Rejected'}">
                    <!-- Button to trigger the confirmation modal -->
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmCompleteModal" ${isFutureAppointment ? 'disabled' : ''}>
                        <i class="fas fa-check-circle me-2"></i>Mark as Complete
                    </button>
                </c:if>
                <c:if test="${appointment.status == 'Completed' || appointment.status == 'Rejected'}">
                    <p class="text-muted">This appointment has been finalized and no further actions can be taken.</p>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmCompleteModal" tabindex="-1" aria-labelledby="confirmCompleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmCompleteModalLabel">Confirm Action</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to mark this appointment as complete?
            </div>
            <div class="modal-footer">
                <form id="completeAppointmentForm" action="mark-appointment-done" method="post">
                    <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Yes, Mark as Complete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
