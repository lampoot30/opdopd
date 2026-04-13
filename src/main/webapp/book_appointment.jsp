<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Book Appointment - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin-left: 260px; padding: 2rem; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-green, #28a745); }
        .form-label { font-weight: 500; }
        .schedule-info { font-size: 0.9rem; color: #6c757d; margin-top: 5px; }
    </style>
</head>
<body>

<c:import url="navbar-patient.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Book a New Appointment</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-calendar-plus me-2"></i>Appointment Details</h5>
            </div>
            <div class="card-body p-4">
                <form id="appointmentForm" action="BookAppointmentServlet" method="post" enctype="multipart/form-data">
                    <!-- Patient Type Selection First -->
                    <div class="mb-4" id="patientTypeSelection">
                        <label class="form-label h5">Are you a new or old patient?</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="patientType" id="newPatient" value="New" required>
                            <label class="form-check-label" for="newPatient">I am a New Patient</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="patientType" id="oldPatient" value="Old">
                            <label class="form-check-label" for="oldPatient">I am an Old Patient</label>
                        </div>
                    </div>

                    <!-- Rest of the form, initially hidden -->
                    <div id="appointmentFormContent" style="display: none;">
                        <!-- Fields for Old Patient, initially hidden -->
                        <div id="oldPatientFields" style="display: none;">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="opdNo" class="form-label">OPD Number</label>
                                    <input type="text" class="form-control" id="opdNo" name="opdNo" placeholder="Enter OPD Number">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="lastCheckup" class="form-label">Last Check-up Date (Optional)</label>
                                    <input type="date" class="form-control" id="lastCheckup" name="lastCheckup">
                                </div>
                            </div>
                        </div>
                    <!-- Service Selection -->
                    <div class="mb-3">
                        <label for="service" class="form-label">Select Service/Clinic</label>
                        <select class="form-select" id="service" name="service" required>
                            <option value="">-- Please select a service --</option>
                            <c:forEach var="s" items="${services}">
                                <option value="${s.serviceName}" data-schedule="${s.scheduleDetails}">${s.serviceName}</option>
                            </c:forEach>
                        </select>
                        <div id="scheduleInfo" class="schedule-info"></div>
                    </div>

                    <!-- Reason for Visit -->
                    <div class="mb-3">
                        <label for="reasonForVisit" class="form-label">Reason for Visit</label>
                        <input type="text" class="form-control" id="reasonForVisit" name="reasonForVisit" required placeholder="Please describe the reason for your visit">
                    </div>

                    <!-- File Attachment -->
                    <div class="mb-3">
                        <label for="attachment" class="form-label">Attach File (Optional)</label>
                        <input type="file" class="form-control" id="attachment" name="attachment">
                        <small class="form-text text-muted">You can upload a referral letter, previous results, or other relevant documents.</small>
                    </div>

                    <!-- Date Selection -->
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="preferredDate" class="form-label">Preferred Date</label>
                            <input type="date" class="form-control" id="preferredDate" name="preferredDate" required disabled>
                        </div>
                    </div>
                    
                    <!-- Patient Information -->
                    <h5 class="mt-4 mb-3">Patient Information</h5>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="lastName" class="form-label">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required value="${patientProfile.surname}">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="givenName" class="form-label">Given Name</label>
                            <input type="text" class="form-control" id="givenName" name="givenName" required value="${patientProfile.givenName}">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="middleName" class="form-label">Middle Name</label>
                            <input type="text" class="form-control" id="middleName" name="middleName" value="${patientProfile.middleName}">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="birthday" class="form-label">Birthday</label>
                            <input type="date" class="form-control" id="birthday" name="birthday" required value="${patientProfile.dateOfBirth}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="age" class="form-label">Age</label>
                            <input type="text" class="form-control" id="age" name="age" readonly placeholder="Age will be calculated">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="civilStatus" class="form-label">Civil Status</label>
                            <select class="form-select" id="civilStatus" name="civilStatus" required>
                                <option value="Single">Single</option>
                                <option value="Married">Married</option>
                                <option value="Widowed">Widowed</option>
                                <option value="Separated">Separated</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="gender" class="form-label">Gender</label>
                            <input type="text" class="form-control" id="gender" name="gender" required value="${patientProfile.gender}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="religion" class="form-label">Religion</label>
                            <input type="text" class="form-control" id="religion" name="religion" value="${patientProfile.religion}">
                        </div>
                    </div>


                    <div class="mb-3">
                        <label for="contactNumber" class="form-label">Contact Number</label>
                        <input type="tel" class="form-control" id="contactNumber" name="contactNumber" required value="${patientProfile.contactNumber}">
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="2" required>${patientProfile.permanentAddress}</textarea>
                    </div>

                    <!-- Confirmation Checkbox -->
                    <div class="mb-3 form-check">
                        <input class="form-check-input" type="checkbox" id="confirmInfo" required>
                        <label class="form-check-label" for="confirmInfo">
                            I confirm that the information provided is correct and accurate.
                        </label>
                    </div>

                        <div class="text-end mt-4">
                            <button type="submit" id="submitBtn" class="btn btn-primary" disabled><i class="fas fa-calendar-check me-2"></i>Submit Appointment</button>
                        </div>
                    </div>
                </form>
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

<!-- Error Modal -->
<div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="errorModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Invalid Selection</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="errorModalBody">
                <!-- Error message will be injected here -->
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
    const formContent = document.getElementById('appointmentFormContent');
    const oldPatientFields = document.getElementById('oldPatientFields');
    const opdNoInput = document.getElementById('opdNo');
    const patientTypeRadios = document.querySelectorAll('input[name="patientType"]');
    const serviceSelect = document.getElementById('service');
    const dateInput = document.getElementById('preferredDate');
    const birthdayInput = document.getElementById('birthday');
    const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
    const scheduleInfoDiv = document.getElementById('scheduleInfo');

    // Show form content and conditional fields when a patient type is selected
    patientTypeRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            formContent.style.display = 'block';
            const isOldPatient = this.value === 'Old';
            oldPatientFields.style.display = isOldPatient ? 'block' : 'none';
            opdNoInput.required = isOldPatient;
        });
    });

    // Set min date to today
    const today = new Date().toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    // Show form content when a patient type is selected
    patientTypeRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            formContent.style.display = 'block';
        });
    });

    serviceSelect.addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        const schedule = selectedOption.getAttribute('data-schedule');

        if (schedule) {
            dateInput.disabled = false;
            // Assuming 'schedule' now only contains day information (e.g., "Monday to Friday", "By Appointment")
            scheduleInfoDiv.textContent = 'Schedule: ' + schedule;
        } else {
            dateInput.disabled = true;
            dateInput.value = '';
            scheduleInfoDiv.textContent = '';
        }
    });
    dateInput.addEventListener('blur', function() {
        if (!serviceSelect.value || !this.value || this.value.length !== 10 || isNaN(new Date(this.value).getTime())) return; // No service selected, no date entered, incomplete date, or invalid date, skip validation

        const selectedDate = new Date(this.value);
        const dayOfWeek = selectedDate.getUTCDay(); // Sunday = 0, Monday = 1, etc.
        const dayOfMonth = selectedDate.getUTCDate();
        const weekOfMonth = Math.ceil(dayOfMonth / 7);

        const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
        const schedule = selectedOption.getAttribute('data-schedule') ? selectedOption.getAttribute('data-schedule').toLowerCase() : '';

        let isValid = true;
        let errorMessage = 'The selected date is not available for this service. Please check the schedule and choose another date.';

        // General weekend check first
        if (dayOfWeek === 0 || dayOfWeek === 6) { // Sunday or Saturday
            isValid = false;
            errorMessage = 'Appointments cannot be scheduled on weekends (Saturday or Sunday). Please select a weekday.';
        }

        // Then, check service-specific schedules if the day is a weekday
        if (isValid && schedule.includes('monday to friday')) {
            if (dayOfWeek === 0 || dayOfWeek === 6) { // Sunday or Saturday
                isValid = false;
            }
        } else if (schedule.includes('wednesday and thursday')) {
            if (dayOfWeek !== 3 && dayOfWeek !== 4) { // Not Wednesday or Thursday
                isValid = false;
            }
        } else if (schedule.includes('2nd and 4th wednesday')) {
            if (dayOfWeek !== 3 || (weekOfMonth !== 2 && weekOfMonth !== 4)) {
                isValid = false;
            }
        } else if (schedule.includes('by appointment')) {
            // For "by appointment", we assume any day is valid and staff will coordinate.
            isValid = true;
        }

        if (!isValid) {
            document.getElementById('errorModalBody').textContent = errorMessage;
            errorModal.show();
            this.value = ''; // Clear the invalid date
        }
    });

    // Age calculation
    birthdayInput.addEventListener('change', function() {
        const ageInput = document.getElementById('age');
        if (this.value) {
            const birthDate = new Date(this.value);
            const today = new Date();
            let age = today.getFullYear() - birthDate.getFullYear();
            const m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            ageInput.value = age >= 0 ? age : 0;
        }
    });

    // Trigger change on page load to calculate age for pre-filled birthday
    birthdayInput.dispatchEvent(new Event('change'));

    // Enable/disable submit button based on confirmation checkbox
    const confirmCheckbox = document.getElementById('confirmInfo');
    const submitBtn = document.getElementById('submitBtn');

    confirmCheckbox.addEventListener('change', function() {
        submitBtn.disabled = !this.checked;
    });

    // --- New: Handle Success Modal ---
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
