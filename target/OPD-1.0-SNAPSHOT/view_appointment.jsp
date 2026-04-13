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
    <title>Manage Appointment - Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-staff-color, #17a2b8); }
        .list-group-item { border-left: 0; border-right: 0; }
        .list-group-item strong { min-width: 150px; display: inline-block; }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Manage Appointment Request</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${error}</div>
        </c:if>

        <div class="row">
            <!-- Appointment Details -->
            <div class="col-lg-7 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user-injured me-2"></i>Patient & Appointment Details</h5>
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item"><strong>Patient Name:</strong> ${appointment.givenName} ${appointment.middleName} ${appointment.lastName}</li>
                            <li class="list-group-item"><strong>Patient Type:</strong> <span class="badge ${appointment.patientType == 'New' ? 'bg-primary' : 'bg-secondary'}">${appointment.patientType}</span></li>
                            <li class="list-group-item" id="preferredDateDisplay"><strong>Patient's Request:</strong> ${appointment.preferredDate}</li>
                            <li class="list-group-item"><strong>Reason for Visit:</strong> ${appointment.reasonForVisit}</li>
                            <li class="list-group-item"><strong>Current Status:</strong> <span class="badge bg-warning text-dark">${appointment.status}</span></li>
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

            <!-- Assignment Form -->
            <c:if test="${appointment.status == 'Pending'}">
                <div class="col-lg-5 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-check-circle me-2"></i>Assign Appointment</h5>
                        </div>
                        <div class="card-body p-4">
                            <form action="assign-appointment" method="post">
                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                                <div class="mb-3">
                                    <label for="doctorUserId" class="form-label fw-bold">Assign Doctor</label>
                                    <select class="form-select" id="doctorUserId" name="doctorUserId" required>
                                        <option value="">-- Select a Doctor --</option>
                                        <c:forEach var="doc" items="${doctors}">
                                            <option value="${doc.doctorId}">Dr. ${doc.givenName} ${doc.surname} (${doc.specialization})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label for="roomId" class="form-label fw-bold">Assign Room (Optional)</label>
                                    <select class="form-select" id="roomId" name="roomId">
                                        <option value="">-- Select a Room --</option>
                                        <c:forEach var="room" items="${rooms}">
                                            <option value="${room.roomId}">${room.roomNumber}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <hr class="my-4">

                                <!-- Hidden input for the new date, to be populated by the modal -->
                                <input type="hidden" id="newPreferredDate" name="newPreferredDate">

                                <div class="d-flex justify-content-between align-items-center">
                                    <button type="button" id="rescheduleBtn" class="btn btn-outline-warning" data-bs-toggle="modal" data-bs-target="#rescheduleModal">
                                        <i class="fas fa-calendar-alt me-2"></i>Reschedule
                                    </button>
                                    <button type="submit" class="btn btn-success fw-bold">
                                        <i class="fas fa-check-circle me-2"></i>Confirm & Assign
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Reschedule Modal -->
<div class="modal fade" id="rescheduleModal" tabindex="-1" aria-labelledby="rescheduleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rescheduleModalLabel"><i class="fas fa-calendar-alt me-2 text-warning"></i>Reschedule Appointment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Please select a new date for the appointment.</p>
                <div class="mb-3">
                    <label for="modalNewDate" class="form-label">New Appointment Date</label>
                    <input type="date" class="form-control" id="modalNewDate">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="useDateBtn" class="btn btn-outline-primary">Use this Date for Assignment</button>
                <form action="propose-reschedule" method="post" class="d-inline">
                    <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                    <input type="hidden" id="newProposedDate" name="newProposedDate">
                    <button type="submit" id="proposeDateBtn" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-2"></i>Propose New Date & Notify Patient
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const useDateBtn = document.getElementById('useDateBtn');
        const modalNewDateInput = document.getElementById('modalNewDate');
        const hiddenNewDateInput = document.getElementById('newPreferredDate');
        const preferredDateDisplay = document.getElementById('preferredDateDisplay');
        const rescheduleModal = new bootstrap.Modal(document.getElementById('rescheduleModal'));
        const newProposedDateInput = document.getElementById('newProposedDate');
        const proposeDateBtn = document.getElementById('proposeDateBtn');

        // When date in modal changes, update the hidden input for the proposal form
        modalNewDateInput.addEventListener('change', function() {
            newProposedDateInput.value = this.value;
        });

        // This button just stages the date for the main assignment form
        useDateBtn.addEventListener('click', function() {
            const newDate = modalNewDateInput.value;
            if (newDate) {
                hiddenNewDateInput.value = newDate;
                // Update the UI to show the new date is set
                preferredDateDisplay.innerHTML = '<strong>Patient\'s Request:</strong> <s class="text-muted">${appointment.preferredDate}</s><br><strong class="text-warning">New Date:</strong> ' + newDate;
                rescheduleModal.hide();
            } else {
                alert('Please select a new date.');
            }
        });

        // Disable the propose button until a date is selected
        proposeDateBtn.disabled = true;
        modalNewDateInput.addEventListener('input', function() {
            proposeDateBtn.disabled = !this.value;
        });
    });
</script>
</body>
</html>
