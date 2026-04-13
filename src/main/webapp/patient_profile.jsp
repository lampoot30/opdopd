<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Patient Profile - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .profile-header {
            padding: 2rem;
            background-color: #fff;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        .profile-avatar img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        .card-header {
            font-weight: 600;
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            color: var(--primary-green);
        }
        /* Style for the password toggle button */
        .password-toggle-btn {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            z-index: 10;
            border: none;
            background: transparent;
            cursor: pointer;
            padding: .375rem .75rem;
        }
    </style>
</head>
<body>

<c:import url="navbar-patient.jsp" />

<div class="main-content">
    <c:if test="${not empty patient and patient.userId > 0}">
        <div class="profile-header d-flex align-items-center">
            <div class="profile-avatar me-4">
                <img src="<c:url value='${not empty patient.profilePicturePath ? patient.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Picture" id="profileImg">
            </div>
            <div>
                <h2 class="mb-0">${patient.givenName} ${patient.surname}</h2>
                <p class="text-muted mb-1">Patient ID: ${patient.userId}</p>
                <span class="badge bg-success">Active Patient</span>
            </div>
            <div class="ms-auto">
                <!-- Buttons will be toggled by JavaScript -->
                <button id="editProfileBtn" class="btn btn-primary"><i class="fas fa-edit me-2"></i>Edit Profile</button>
                <div id="editModeButtons" style="display: none;">
                    <button type="button" id="cancelBtn" class="btn btn-secondary me-2"><i class="fas fa-times me-2"></i>Cancel</button>
                    <button type="submit" form="profileForm" class="btn btn-success"><i class="fas fa-save me-2"></i>Save Changes</button>
                </div>
            </div>
        </div>

        <form id="profileForm" action="<c:url value='/update_patient_profile'/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="username" value="${patient.username}">
            <div class="row">
                <div class="col-xl-8">
                    <!-- Personal Details Card -->
                    <div class="card mb-4">
                        <div class="card-header">Personal Details</div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3"><label class="form-label fw-bold">Given Name</label><input type="text" class="form-control" name="given_name" value="${patient.givenName}" readonly></div>
                                <div class="col-md-6 mb-3"><label class="form-label fw-bold">Surname</label><input type="text" class="form-control" name="surname" value="${patient.surname}" readonly></div>
                                <div class="col-md-6 mb-3"><label class="form-label fw-bold">Middle Name</label><input type="text" class="form-control" name="middle_name" value="${not empty patient.middleName ? patient.middleName : 'N/A'}" readonly></div>
                                <div class="col-md-6 mb-3"><label class="form-label fw-bold">Date of Birth</label><input type="text" class="form-control" name="date_of_birth" value="${patient.dateOfBirth}" readonly></div>
                                <div class="col-md-6 mb-3"><label class="form-label fw-bold">Gender</label><input type="text" class="form-control" name="gender" value="${patient.gender}" readonly></div>
                                <div class="col-md-6 mb-3"><label class="form-label fw-bold">Religion</label><input type="text" class="form-control" id="religion" name="religion" value="<c:out value='${patient.religion}'/>" readonly></div>
                            </div>
                        </div>
                    </div>
                    <!-- Address Information Card -->
                    <div class="card mb-4">
                        <div class="card-header">Address Information</div>
                        <div class="card-body">
                            <div class="mb-3"><label class="form-label fw-bold">Permanent Address</label><textarea class="form-control" name="permanent_address" rows="2" readonly>${patient.permanentAddress}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-bold">Current Address</label><textarea class="form-control" name="current_address" rows="2" readonly>${patient.currentAddress}</textarea></div>
                            <div class="row">
                                <div class="col-md-4 mb-3"><label class="form-label fw-bold">City/Town</label><input type="text" class="form-control" name="city" value="${patient.city}" readonly></div>
                                <div class="col-md-4 mb-3"><label class="form-label fw-bold">Postal/ZIP Code</label><input type="text" class="form-control" name="postal_code" value="${patient.postalCode}" readonly></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4">
                    <!-- Account Details Card -->
                    <div class="card mb-4">
                        <div class="card-header">Account Details</div>
                        <div class="card-body">
                            <div class="mb-3"><label class="form-label fw-bold">Username</label><input type="text" class="form-control" name="username" value="${patient.username}" readonly></div>
                            <div class="mb-3"><label class="form-label fw-bold">Contact Number</label><input type="text" class="form-control" name="contact_number" value="${patient.contactNumber}" readonly></div>
                            <div class="mb-3"><label class="form-label fw-bold">Member Since</label><input type="text" class="form-control" value="${patient.createdAt}" readonly></div>
                        </div>
                    </div>
                    <!-- Profile Picture Upload Card -->
                    <div class="card mb-4" id="upload-section" style="display: none;">
                        <div class="card-header">Profile Picture</div>
                        <div class="card-body text-center">
                            <label for="profilePictureInput" class="form-label">Change Picture</label>
                            <input class="form-control form-control-sm" type="file" id="profilePictureInput" name="profile_picture" accept="image/*">
                        </div>
                    </div>
                </div>
            </div>
        </form>

        <!-- Change Password Card -->
        <div id="changePasswordSection" class="card mt-4" style="display: none;">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-key me-2"></i>Change Password</h5>
            </div>
            <div class="card-body">
                <form action="change-password" method="post">
                    <div class="mb-3">
                        <label for="oldPassword" class="form-label">Enter Old Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                            <button class="password-toggle-btn" type="button" id="toggleOldPassword">
                                <i class="fas fa-eye" id="oldPasswordIcon"></i>
                            </button>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            <button class="password-toggle-btn" type="button" id="toggleNewPassword">
                                <i class="fas fa-eye" id="newPasswordIcon"></i>
                            </button>
                        </div>
                        <!-- Password Requirements Checklist -->
                        <div id="password-requirements" class="mt-2" style="display: none;">
                            <ul class="list-unstyled mb-0 small">
                                <li id="length" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least 8 characters</li>
                                <li id="uppercase" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one uppercase letter (A-Z)</li>
                                <li id="lowercase" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one lowercase letter (a-z)</li>
                                <li id="number" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one number (0-9)</li>
                                <li id="special" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one special character (!@#$%^&*)</li>
                            </ul>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmNewPassword" class="form-label">Re-enter New Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                            <button class="password-toggle-btn" type="button" id="toggleConfirmNewPassword">
                                <i class="fas fa-eye" id="confirmNewPasswordIcon"></i>
                            </button>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Change Password</button>
                </form>
            </div>
        </div>
    </c:if>
    <c:if test="${empty patient or patient.userId == 0}">
        <div class="alert alert-danger">Profile information not found.</div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        let isFormDirty = false;
        const editBtn = document.getElementById('editProfileBtn');
        const editModeButtons = document.getElementById('editModeButtons');
        const cancelBtn = document.getElementById('cancelBtn');
        const uploadSection = document.getElementById('upload-section');
        const passwordSection = document.getElementById('changePasswordSection');
        const form = document.getElementById('profileForm');
        const inputs = form.querySelectorAll('input, textarea');

        editBtn.addEventListener('click', function() {
            // Switch to Edit Mode
            inputs.forEach(input => {
                const name = input.getAttribute('name');
                // Do not allow editing of username or member since date
                if (name !== 'username' && !input.value.includes(':')) { // A simple way to keep timestamp readonly
                    input.removeAttribute('readonly');
                }
            });

            const dobInput = document.querySelector('input[name="date_of_birth"]');
            if (dobInput) {
                dobInput.type = 'date';
                // Set the maximum selectable date to today to prevent future dates.
                const today = new Date().toISOString().split('T')[0];
                dobInput.setAttribute('max', today);
            }

            uploadSection.style.display = 'block';
            editBtn.style.display = 'none';
            passwordSection.style.display = 'block'; // Show the password section
            editModeButtons.style.display = 'block';
        });

        cancelBtn.addEventListener('click', function() {
            // If the form has been changed, ask for confirmation before canceling.
            if (isFormDirty) {
                if (confirm('You have unsaved changes. Are you sure you want to cancel?')) {
                    window.location.reload();
                }
            } else {
                window.location.reload();
            }
        });

        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            // Replace any characters that are not letters or spaces.
            const regex = /[^a-zA-Z\s]/g;
            event.target.value = event.target.value.replace(regex, '');
        }
        const givenNameInput = document.querySelector('input[name="given_name"]');
        const surnameInput = document.querySelector('input[name="surname"]');
        const middleNameInput = document.querySelector('input[name="middle_name"]');
        givenNameInput.addEventListener('input', restrictNameInput);
        surnameInput.addEventListener('input', restrictNameInput);
        middleNameInput.addEventListener('input', restrictNameInput);

        const religionInput = document.getElementById('religion');
        if(religionInput) {
            religionInput.addEventListener('input', restrictNameInput);
        }

        // --- Contact Number Input Logic ---
        const contactInput = document.querySelector('input[name="contact_number"]');
        if (contactInput) {
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

        // --- Unsaved Changes Confirmation ---
        form.addEventListener('input', function() {
            isFormDirty = true;
        });
    });

    // Preview uploaded image
    const profilePictureInput = document.getElementById('profilePictureInput');
    if (profilePictureInput) {
        profilePictureInput.onchange = evt => {
            const [file] = profilePictureInput.files;
            if (file) {
                document.getElementById('profileImg').src = URL.createObjectURL(file);
            }
        }
    }

    // Reusable password toggle function
    function setupPasswordToggle(toggleButtonId, passwordInputId, iconId) {
        const toggleButton = document.getElementById(toggleButtonId);
        const passwordInput = document.getElementById(passwordInputId);
        const icon = document.getElementById(iconId);

        if (toggleButton && passwordInput && icon) {
            toggleButton.addEventListener('click', function() {
                const isPassword = passwordInput.type === 'password';
                passwordInput.type = isPassword ? 'text' : 'password';
                icon.classList.toggle('fa-eye', !isPassword);
                icon.classList.toggle('fa-eye-slash', isPassword);
            });
        }
    }

    // Initialize all password toggles on the page
    setupPasswordToggle('toggleOldPassword', 'oldPassword', 'oldPasswordIcon');
    setupPasswordToggle('toggleNewPassword', 'newPassword', 'newPasswordIcon');
    setupPasswordToggle('toggleConfirmNewPassword', 'confirmNewPassword', 'confirmNewPasswordIcon');

    // --- Reusable Real-time Password Requirement Validation ---
    function setupPasswordStrengthChecker(inputId, requirementsId, prefix) {
        const passwordInput = document.getElementById(inputId);
        const requirementsDiv = document.getElementById(requirementsId);

        if (passwordInput && requirementsDiv) {
            const requirements = {
                length: document.getElementById(prefix ? prefix + '-length' : 'length'),
                uppercase: document.getElementById(prefix ? prefix + '-uppercase' : 'uppercase'),
                lowercase: document.getElementById(prefix ? prefix + '-lowercase' : 'lowercase'),
                number: document.getElementById(prefix ? prefix + '-number' : 'number'),
                special: document.getElementById(prefix ? prefix + '-special' : 'special')
            };

            const validations = {
                length: val => val.length >= 8,
                uppercase: val => /[A-Z]/.test(val),
                lowercase: val => /[a-z]/.test(val),
                number: val => /[0-9]/.test(val),
                special: val => /[^A-Za-z0-9]/.test(val)
            };

            passwordInput.addEventListener('focus', () => requirementsDiv.style.display = 'block');

            passwordInput.addEventListener('input', function() {
                const password = this.value;
                for (const key in validations) {
                    const reqEl = requirements[key];
                    const icon = reqEl.querySelector('i');
                    if (validations[key](password)) {
                        reqEl.classList.add('text-success');
                        reqEl.classList.remove('text-danger');
                        icon.classList.replace('fa-times-circle', 'fa-check-circle');
                    } else {
                        reqEl.classList.remove('text-success');
                        reqEl.classList.add('text-danger');
                        icon.classList.replace('fa-check-circle', 'fa-times-circle');
                    }
                }
            });
        }
    }

    // Initialize for both password fields in the change password form
    setupPasswordStrengthChecker('newPassword', 'password-requirements', '');
</script>
</body>
</html>
