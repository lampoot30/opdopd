<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Direct Scheduling - Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; background-color: var(--primary-staff-color, #17a2b8); color: white; border-radius: 15px 15px 0 0; }
        .form-section-title { font-weight: 600; color: var(--primary-staff-color, #17a2b8); border-bottom: 2px solid var(--primary-staff-color, #17a2b8); padding-bottom: 5px; margin-bottom: 20px; }
        #patientSearchResults {
            position: absolute;
            background-color: white;
            border: 1px solid #ddd;
            border-top: none;
            z-index: 99;
            width: calc(100% - 2rem);
            max-height: 200px;
            overflow-y: auto;
            border-radius: 0 0 .25rem .25rem;
        }
        .search-result-item {
            padding: 10px;
            cursor: pointer;
        }
        .search-result-item:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4"><i class="fas fa-calendar-plus me-2"></i>Direct Patient Scheduling</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert"><c:out value="${param.error}"/></div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success" role="alert"><c:out value="${param.success}"/></div>
        </c:if>

        <div class="card">
            <div class="card-header"><i class="fas fa-search me-2"></i>Find Patient or Relative</div>
            <div class="card-body">
                <div class="mb-3 position-relative">
                    <label for="patientSearch" class="form-label">Search by Name</label>
                    <input type="text" id="patientSearch" class="form-control" placeholder="Start typing a patient or relative's name...">
                    <div id="patientSearchResults"></div>
                </div>
                <div>
                    <button type="button" id="clearFormBtn" class="btn btn-sm btn-outline-secondary"><i class="fas fa-eraser me-2"></i>Clear Form for New Person</button>
                    <small class="text-muted ms-2">Use this to schedule for someone not in the system.</small>
                </div>
            </div>
        </div>

        <form id="appointmentForm" action="staff-add-appointment" method="post" class="mt-4">
            <div class="card">
                <div class="card-header"><i class="fas fa-file-medical me-2"></i>Appointment Details</div>
                <div class="card-body p-4">
                    <input type="hidden" id="bookedByUserId" name="bookedByUserId">
                    <input type="hidden" id="relativeId" name="relativeId">
                    <input type="hidden" id="bookedByUserIdForRelative" name="bookedByUserIdForRelative">

                    <h5 class="form-section-title">Patient Information</h5>
                    <div class="row">
                        <div class="col-md-4 mb-3"><label for="lastName" class="form-label">Last Name</label><input type="text" class="form-control" id="lastName" name="lastName" required></div>
                        <div class="col-md-4 mb-3"><label for="givenName" class="form-label">Given Name</label><input type="text" class="form-control" id="givenName" name="givenName" required></div>
                        <div class="col-md-4 mb-3"><label for="middleName" class="form-label">Middle Name</label><input type="text" class="form-control" id="middleName" name="middleName"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3"><label for="birthday" class="form-label">Birthday</label><input type="date" class="form-control" id="birthday" name="birthday" required></div>
                        <div class="col-md-6 mb-3"><label for="contactNumber" class="form-label">Contact Number</label><input type="tel" class="form-control" id="contactNumber" name="contactNumber" required></div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="gender" class="form-label">Gender</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
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
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
                    </div>

                    <hr class="my-4">
                    <h5 class="form-section-title">Scheduling Information</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="service" class="form-label">Service/Clinic</label>
                            <select class="form-select" id="service" name="service" required>
                                <option value="">-- Select a service --</option>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.serviceName}">${s.serviceName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="doctorUserId" class="form-label">Assign Doctor</label>
                            <select class="form-select" id="doctorUserId" name="doctorUserId" required>
                                <option value="">-- Select a doctor --</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.doctorId}">${doc.surname}, ${doc.givenName} (${doc.specialization})</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="preferredDate" class="form-label">Appointment Date</label>
                            <input type="date" class="form-control" id="preferredDate" name="preferredDate" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="roomId" class="form-label">Assign Room (Optional)</label>
                            <select class="form-select" id="roomId" name="roomId">
                                <option value="">-- No room --</option>
                                <c:forEach var="room" items="${rooms}">
                                    <option value="${room.roomId}">${room.roomNumber}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="reasonForVisit" class="form-label">Reason for Visit</label>
                        <textarea class="form-control" id="reasonForVisit" name="reasonForVisit" rows="3" required></textarea>
                    </div>

                    <!-- Confirmation Checkbox -->
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="confirmInfoCheckbox" required>
                        <label class="form-check-label" for="confirmInfoCheckbox">
                            I confirm that the information provided is correct and accurate.
                        </label>
                    </div>

                    <div class="text-end mt-4">
                        <button type="submit" id="scheduleBtn" class="btn btn-primary" disabled><i class="fas fa-calendar-check me-2"></i>Schedule Appointment</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const patientSearchInput = document.getElementById('patientSearch');
        const searchResultsContainer = document.getElementById('patientSearchResults');
        const confirmCheckbox = document.getElementById('confirmInfoCheckbox');
        const scheduleBtn = document.getElementById('scheduleBtn');
        
        // This is the full list of patients and relatives from the servlet
        const searchablePatients = [
            <c:forEach var="p" items="${searchablePatients}">
                {
                    id: '${p.id}',
                    name: '${fn:escapeXml(p.name)}',
                    lastName: '${fn:escapeXml(p.lastName)}',
                    givenName: '${fn:escapeXml(p.givenName)}',
                    middleName: '${fn:escapeXml(p.middleName)}',
                    birthday: '${p.birthday}',
                    contactNumber: '${p.contactNumber}',
                    gender: '${p.gender}',
                    address: '${fn:escapeXml(p.address)}',
                    relativeId: '${p.relativeId}',
                    bookedByUserId: '${p.bookedByUserId}'
                },
            </c:forEach>
        ];

        patientSearchInput.addEventListener('keyup', function() {
            const query = this.value.toLowerCase();
            searchResultsContainer.innerHTML = '';

            if (query.length < 2) {
                return;
            }

            const filtered = searchablePatients.filter(p => p.name.toLowerCase().includes(query));

            filtered.forEach(p => {
                const item = document.createElement('div');
                item.className = 'search-result-item';
                item.textContent = p.name;
                item.onclick = () => selectPatient(p);
                searchResultsContainer.appendChild(item);
            });
        });

        function selectPatient(patient) {
            // Clear search
            patientSearchInput.value = patient.name;
            searchResultsContainer.innerHTML = '';

            // Populate form
            document.getElementById('lastName').value = patient.lastName || '';
            document.getElementById('givenName').value = patient.givenName || '';
            document.getElementById('middleName').value = patient.middleName || '';
            document.getElementById('birthday').value = patient.birthday || '';
            document.getElementById('contactNumber').value = patient.contactNumber || '';
            document.getElementById('gender').value = patient.gender || 'Male';
            document.getElementById('address').value = patient.address || '';

            // Set hidden IDs
            const [type, id] = patient.id.split('-');
            if (type === 'patient') {
                document.getElementById('bookedByUserId').value = id;
                document.getElementById('relativeId').value = '';
            } else { // relative
                document.getElementById('bookedByUserIdForRelative').value = patient.bookedByUserId;
                document.getElementById('relativeId').value = id;
            }
        }
        
        // Clear form button logic
        document.getElementById('clearFormBtn').addEventListener('click', function() {
            document.getElementById('appointmentForm').reset();
            document.getElementById('patientSearch').value = '';
            document.getElementById('bookedByUserId').value = '';
            document.getElementById('relativeId').value = '';
            document.getElementById('bookedByUserIdForRelative').value = '';
            
            // Make fields editable again if they were readonly
            document.getElementById('lastName').readOnly = false;
            document.getElementById('givenName').readOnly = false;
            document.getElementById('middleName').readOnly = false;
            document.getElementById('birthday').readOnly = false;
            document.getElementById('contactNumber').readOnly = false;
        });
        
        // Hide search results when clicking outside
        document.addEventListener('click', function(e) {
            if (!patientSearchInput.contains(e.target)) {
                searchResultsContainer.innerHTML = '';
            }
        });
        
        // Enable/disable submit button based on confirmation checkbox
        confirmCheckbox.addEventListener('change', function() {
            scheduleBtn.disabled = !this.checked;
        });

        // --- Birthday Validation ---
        const birthdayInput = document.getElementById('birthday');
        if (birthdayInput) {
            const today = new Date().toISOString().split('T')[0];
            birthdayInput.setAttribute('max', today);
        }

        // --- Contact Number Input Logic ---
        const contactInput = document.getElementById('contactNumber');
        if (contactInput) {
            contactInput.addEventListener('input', function() {
                let currentValue = this.value;
                // This field doesn't need a default prefix, just strip letters
                this.value = currentValue.replace(/[^\d+]/g, ''); // Allow digits and '+'
            });
        }

    });
</script>
</body>
</html>
