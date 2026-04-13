<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check - although SecurityFilter should handle this.
    String userType = (String) session.getAttribute("userType");
    if (!"Admin".equals(userType) && !"Super Admin".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New Doctor - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .card-header {
            background-color: #0d6efd;
            color: white;
            font-weight: 600;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .form-section-title {
            font-weight: 600;
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <c:import url="admin_navbar.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <%-- Include the reusable notification component --%>
            <c:import url="notification_alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h2"><i class="fas fa-user-plus me-2"></i>Add New Doctor</h1>
                <a href="<c:url value='/analytics-overview'/>" class="btn btn-secondary">Back to Dashboard</a>
            </div>
    
        <div class="card">
            <div class="card-body p-4">
                <form id="addDoctorForm" action="AddDoctorServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="userType" value="Doctor">

                    <h5 class="form-section-title">Personal Information</h5>
                    <div class="row">
                        <div class="col-md-4 mb-3"><label for="surname" class="form-label">Surname</label><input type="text" class="form-control" id="surname" name="surname" required pattern="[a-zA-Z\s'-]+" title="Only letters, spaces, hyphens, and apostrophes are allowed."></div>
                        <div class="col-md-4 mb-3"><label for="givenName" class="form-label">Given Name</label><input type="text" class="form-control" id="givenName" name="givenName" required pattern="[a-zA-Z\s'-]+" title="Only letters, spaces, hyphens, and apostrophes are allowed."></div>
                        <div class="col-md-4 mb-3"><label for="middleName" class="form-label">Middle Name</label><input type="text" class="form-control" id="middleName" name="middleName" pattern="[a-zA-Z\s'.\-]+" title="Only letters, spaces, hyphens, apostrophes, and periods are allowed."></div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3"><label for="dateOfBirth" class="form-label">Date of Birth</label><input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required></div>
                        <div class="col-md-2 mb-3"><label for="age" class="form-label">Age</label><input type="text" class="form-control" id="age" name="age" readonly></div>
                        <div class="col-md-6 mb-3">
                            <label for="gender" class="form-label">Gender</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="permanentAddress" class="form-label">Permanent Address</label>
                        <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" required placeholder="e.g., House No., Street, Barangay"></textarea>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="sameAsPermanent">
                        <label class="form-check-label" for="sameAsPermanent">
                            Current address is the same as permanent address.
                        </label>
                    </div>
                    <div class="mb-3">
                        <label for="currentAddress" class="form-label">Current Address</label>
                        <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" required placeholder="e.g., House No., Street, Barangay"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="city" class="form-label">City/Town (Aurora)</label>
                            <select class="form-select" id="city" name="city" required>
                                <option value="" selected disabled>Select a municipality...</option>
                                <option value="Baler" data-zip="3200">Baler</option>
                                <option value="Casiguran" data-zip="3204">Casiguran</option>
                                <option value="Dilasag" data-zip="3205">Dilasag</option>
                                <option value="Dinalungan" data-zip="3206">Dinalungan</option>
                                <option value="Dingalan" data-zip="3207">Dingalan</option>
                                <option value="Dipaculao" data-zip="3202">Dipaculao</option>
                                <option value="Maria Aurora" data-zip="3203">Maria Aurora</option>
                                <option value="San Luis" data-zip="3201">San Luis</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="postalCode" class="form-label">Postal/ZIP Code</label>
                            <input type="text" class="form-control" id="postalCode" name="postalCode" required readonly>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="form-section-title">Professional & Account Details</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="specialization" class="form-label">Primary Specialization</label>
                            <select class="form-select" id="specialization" name="specialization" required>
                                <option value="" disabled selected>Select a specialization...</option>
                                <c:forEach var="s" items="${specializations}">
                                    <option value="${s.specializationName}"><c:out value="${s.specializationName}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="specialization2" class="form-label">Secondary Specialization (Optional)</label>
                            <select class="form-select" id="specialization2" name="specialization2">
                                <option value="" selected>No secondary specialization</option>
                                <c:forEach var="s" items="${specializations}">
                                    <option value="${s.specializationName}"><c:out value="${s.specializationName}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="licenseNumber" class="form-label">License Number</label>
                            <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="licenseExpiryDate" class="form-label">License Expiry Date</label>
                            <input type="date" class="form-control" id="licenseExpiryDate" name="licenseExpiryDate" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="contactNumber" class="form-label">Contact Number</label>
                            <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="+63" required pattern="^(09|\+639)\d{9}$" title="Enter a valid Philippine number (e.g., +639... or 09...).">
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required readonly>
                            <div class="form-text">Username is auto-generated from the name fields.</div>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="form-section-title">Profile Picture</h5>
                    <div class="mb-3">
                        <label for="profilePicture" class="form-label">Upload Picture (Optional)</label>
                        <input class="form-control" type="file" id="profilePicture" name="profile_picture" accept="image/*">
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="button" class="btn btn-primary btn-lg" id="addDoctorModalBtn" data-bs-toggle="modal" data-bs-target="#confirmationModal" disabled>Add Doctor</button>
                    </div>
                </form>
            </div>
        </div>
        </div>
    </div>
    
<!-- Confirmation Modal -->
<div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="confirmationModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Confirm Action</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to add this new doctor?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmSubmitBtn">Yes, Add Doctor</button>
            </div>
        </div>
    </div>
</div>
    
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>

    document.addEventListener('DOMContentLoaded', function() {
        // --- Modal Confirmation Logic ---
        const confirmSubmitBtn = document.getElementById('confirmSubmitBtn');
        const form = document.getElementById('addDoctorForm');
        if (confirmSubmitBtn && form) {
            confirmSubmitBtn.addEventListener('click', function() {
                form.submit();
            });
        }

        // --- Disable/Enable submit button based on form validity ---
        const addDoctorForm = document.getElementById('addDoctorForm');
        const addDoctorBtn = document.getElementById('addDoctorModalBtn');
        const requiredFieldsDoctor = addDoctorForm.querySelectorAll('[required]');

        function validateDoctorForm() {
            let allFilled = true;
            requiredFieldsDoctor.forEach(field => {
                if (!field.readOnly && !field.value.trim()) {
                    allFilled = false;
                }
            });
            addDoctorBtn.disabled = !allFilled;
        }
        addDoctorForm.addEventListener('input', validateDoctorForm);
        validateDoctorForm(); // Initial check

        // --- Date of Birth Validation ---
        const dobInputDoctor = document.getElementById('dateOfBirth');
        if (dobInputDoctor) {
            const today = new Date().toISOString().split('T')[0];
            dobInputDoctor.setAttribute('max', today);
        }

        // --- Handle contact number input field logic ---
        const contactInput = document.getElementById('contactNumber');
        if (contactInput) {
            contactInput.addEventListener('focus', function() {
                if (this.value === '') {
                    this.value = '+63';
                }
            });
            contactInput.addEventListener('blur', function() {
                if (this.value === '+63') {
                    this.value = '';
                }
            });
            
            // Add input event listener to strip non-numeric characters
            contactInput.addEventListener('input', function() {
                let currentValue = this.value;
                // Ensure it starts with +63
                if (!currentValue.startsWith('+63')) {
                    this.value = '+63';
                }
                // Allow only digits after '+63'
                this.value = '+63' + currentValue.substring(3).replace(/[^\d]/g, '');
            });
        }


        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            // Replace any characters that are not letters or spaces.
            const regex = /[^a-zA-Z\s]/g;
            event.target.value = event.target.value.replace(regex, '');
        }
        document.getElementById('surname').addEventListener('input', restrictNameInput);
        document.getElementById('givenName').addEventListener('input', restrictNameInput);
        document.getElementById('middleName').addEventListener('input', restrictNameInput);

        // --- Address logic ---
        const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');
        const permanentAddress = document.getElementById('permanentAddress');
        const currentAddress = document.getElementById('currentAddress');

        sameAsPermanentCheckbox.addEventListener('change', function() {
            if (this.checked) {
                currentAddress.value = permanentAddress.value;
                currentAddress.setAttribute('readonly', true);
            } else {
                currentAddress.removeAttribute('readonly');
            }
        });

        permanentAddress.addEventListener('input', function() {
            if (sameAsPermanentCheckbox.checked) {
                currentAddress.value = this.value;
            }
        });

        // --- Auto-populate ZIP code based on city selection ---
        const cityDropdown = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');
        cityDropdown.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            postalCodeInput.value = selectedOption.getAttribute('data-zip') || '';
        });

        // --- Auto-generate username from name fields ---
        function generateUsername() {
            const surname = document.getElementById('surname').value.trim().toLowerCase();
            const givenName = document.getElementById('givenName').value.trim().toLowerCase();
            const middleName = document.getElementById('middleName').value.trim().toLowerCase();
            let username = '';
            if (surname && givenName) {
                username = surname + '.' + givenName;
                if (middleName) {
                    username += '.' + middleName.charAt(0);
                }
                document.getElementById('username').value = username;
            } else {
                document.getElementById('username').value = '';
            }
        }
        document.getElementById('surname').addEventListener('input', generateUsername);
        document.getElementById('givenName').addEventListener('input', generateUsername);
        document.getElementById('middleName').addEventListener('input', generateUsername);

        // --- Calculate and display age from date of birth ---
        function calculateAge() {
            const dobInput = document.getElementById('dateOfBirth');
            const ageInput = document.getElementById('age');
            const dob = new Date(dobInput.value);
            if (!dobInput.value) {
                ageInput.value = '';
                return;
            }
            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDifference = today.getMonth() - dob.getMonth();
            if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < dob.getDate())) {
                age--;
            }
            ageInput.value = Math.max(0, age);
        }
        document.getElementById('dateOfBirth').addEventListener('input', calculateAge);
        document.getElementById('dateOfBirth').addEventListener('change', calculateAge);

        // --- Form validation on submit ---
        form.addEventListener('submit', function(e) {
            // Normalize contact number before submission
            const contactNumberInput = document.getElementById('contactNumber');
            let contactNumber = contactNumberInput.value.trim();
            if (contactNumber.startsWith('09') && contactNumber.length === 11) {
                contactNumberInput.value = '+63' + contactNumber.substring(1);
            }

            // Age validation (Doctor must be 30 years or older)
            const dobInput = document.getElementById('dateOfBirth');
            const dob = new Date(dobInput.value);
            if (!dobInput.value) return; 

            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDifference = today.getMonth() - dob.getMonth();
            if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < dob.getDate())) {
                age--;
            }

            if (age < 30) {
                e.preventDefault();
                alert('Doctor must be 30 years of age or older to register.');
                dobInput.focus();
                return;
            }
            
            // Re-enable username field before submission
            document.getElementById('username').readOnly = false;
        });
    });
</script>
</body>
</html>
