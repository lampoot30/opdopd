<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check: Only allow Doctor users to access this page.
    if (!"Doctor".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>My Profile - Doctor Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .main-content {
            margin-left: 250px; /* Adjusted to match sidebar width */
            padding: 2rem;
        }
        .profile-header {
            padding: 2rem;
            background-color: #fff;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        .profile-header img {
            width: 150px;
            height: 150px;
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
            color: #007bff; /* Doctor's primary color */
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

<c:import url="navbar-doctor.jsp" />

<div class="main-content">
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Profile Header -->
    <div class="profile-header d-flex align-items-center">
        <div class="me-4">
            <img id="profileImg" src="<c:url value='${not empty doctor.profilePicturePath ? doctor.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Picture" style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover;">
        </div>
        <div>
            <h2 class="mb-0">Dr. ${doctor.givenName} ${doctor.surname}</h2>
            <p class="text-muted mb-1">User ID: ${user.userId}</p>
            <span class="badge bg-primary">${doctor.specialization}</span>
        </div>
        <div class="ms-auto">
            <button id="editProfileBtn" class="btn btn-primary"><i class="fas fa-edit me-2"></i>Edit Profile</button>
            <div id="editModeButtons" style="display: none;">
                <button type="button" id="cancelBtn" class="btn btn-secondary me-2"><i class="fas fa-times me-2"></i>Cancel</button>
                <button type="submit" form="profileForm" class="btn btn-success"><i class="fas fa-save me-2"></i>Save Changes</button>
            </div>
        </div>
    </div>

    <!-- Profile Details -->
    <form id="profileForm" action="<c:url value='/update-doctor-profile'/>" method="post" enctype="multipart/form-data">
        <div class="row">
            <div class="col-xl-8">
                <div class="card mb-4">
                    <div class="card-header">Personal Details</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 mb-3"><label class="form-label fw-bold">Given Name</label><input type="text" class="form-control" name="givenName" value="${doctor.givenName}" readonly></div>
                            <div class="col-md-4 mb-3"><label class="form-label fw-bold">Middle Name</label><input type="text" class="form-control" name="middleName" value="${doctor.middleName}" readonly></div>
                            <div class="col-md-4 mb-3"><label class="form-label fw-bold">Surname</label><input type="text" class="form-control" name="surname" value="${doctor.surname}" readonly></div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3"><label class="form-label fw-bold">Date of Birth</label><input type="text" class="form-control" name="dateOfBirth" value="${doctor.dateOfBirth}" readonly></div>
                            <div class="col-md-4 mb-3"><label class="form-label fw-bold">Age</label><input type="text" class="form-control" id="age" name="age" value="${doctor.age}" readonly></div>
                            <div class="col-md-4 mb-3"><label class="form-label fw-bold">Gender</label><input type="text" class="form-control" name="gender" value="${doctor.gender}" readonly></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" for="permanentAddress">Permanent Address</label>
                            <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" readonly><c:out value='${doctor.address}'/></textarea>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="sameAsPermanent" disabled>
                            <label class="form-check-label" for="sameAsPermanent">
                                My current address is the same as my permanent address.
                            </label>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" for="currentAddress">Current Address</label>
                            <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" readonly><c:out value='${currentAddress}'/></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" for="city">City/Town (Aurora)</label>
                                <select class="form-select" id="city" name="city" disabled>
                                    <option value="" disabled>Select a municipality...</option>
                                    <option value="Baler" data-zip="3200" ${city == 'Baler' ? 'selected' : ''}>Baler</option>
                                    <option value="Casiguran" data-zip="3204" ${city == 'Casiguran' ? 'selected' : ''}>Casiguran</option>
                                    <option value="Dilasag" data-zip="3205" ${city == 'Dilasag' ? 'selected' : ''}>Dilasag</option>
                                    <option value="Dinalungan" data-zip="3206" ${city == 'Dinalungan' ? 'selected' : ''}>Dinalungan</option>
                                    <option value="Dingalan" data-zip="3207" ${city == 'Dingalan' ? 'selected' : ''}>Dingalan</option>
                                    <option value="Dipaculao" data-zip="3202" ${city == 'Dipaculao' ? 'selected' : ''}>Dipaculao</option>
                                    <option value="Maria Aurora" data-zip="3203" ${city == 'Maria Aurora' ? 'selected' : ''}>Maria Aurora</option>
                                    <option value="San Luis" data-zip="3201" ${city == 'San Luis' ? 'selected' : ''}>San Luis</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" for="postalCode">Postal/ZIP Code</label>
                                <input type="text" class="form-control" id="postalCode" name="postalCode" readonly value="<c:out value='${postalCode}'/>">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4">
                <div class="card mb-4">
                    <div class="card-header">Account & Professional Details</div>
                    <div class="card-body">
                        <div class="mb-3"><label class="form-label fw-bold">Username</label><input type="text" class="form-control" name="username" value="${user.username}" readonly></div>
                        <div class="mb-3"><label class="form-label fw-bold">Contact Number</label><input type="text" class="form-control" name="contactNumber" value="${user.contactNumber}" readonly></div>
                        <hr>
                        <div class="mb-3"><label class="form-label fw-bold">License Number</label><input type="text" class="form-control" name="licenseNumber" value="${doctor.licenseNumber}" readonly></div>
                        <div><label class="form-label fw-bold">License Expiry Date</label><input type="text" class="form-control" name="licenseExpiryDate" value="${doctor.licenseExpiryDate}" readonly></div>
                    </div>
                </div>
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

        // --- Address Logic ---
        const permanentAddress = document.getElementById('permanentAddress');
        const currentAddress = document.getElementById('currentAddress');
        const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');
        const cityDropdown = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');

        // Function to update current address based on permanent
        function updateCurrentAddress() {
            if (sameAsPermanentCheckbox.checked) {
                currentAddress.value = permanentAddress.value;
                currentAddress.setAttribute('readonly', true);
            } else {
                currentAddress.removeAttribute('readonly');
            }
        }

        // Initialize current address state on load
        if (permanentAddress.value === currentAddress.value && permanentAddress.value !== '') {
            sameAsPermanentCheckbox.checked = true;
            currentAddress.setAttribute('readonly', true);
        }

        sameAsPermanentCheckbox.addEventListener('change', updateCurrentAddress);
        permanentAddress.addEventListener('input', function() {
            if (sameAsPermanentCheckbox.checked) {
                currentAddress.value = this.value;
            }
    });

    // Auto-populate ZIP code based on city selection
    cityDropdown.addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        postalCodeInput.value = selectedOption.getAttribute('data-zip') || '';
        });

        editBtn.addEventListener('click', function() {
            inputs.forEach(input => {
                if (input.name !== 'username') { input.readOnly = false; }
            });

            // Change date inputs to type="date"
            document.querySelector('input[name="dateOfBirth"]').type = 'date';
            document.querySelector('input[name="licenseExpiryDate"]').type = 'date';

            uploadSection.style.display = 'block';
            passwordSection.style.display = 'block';
            editBtn.style.display = 'none';
            editModeButtons.style.display = 'block';

            // Enable address-related fields
            permanentAddress.removeAttribute('readonly');
            sameAsPermanentCheckbox.removeAttribute('disabled');
            cityDropdown.removeAttribute('disabled');
            // currentAddress readonly state is managed by sameAsPermanentCheckbox
            if (!sameAsPermanentCheckbox.checked) {
                currentAddress.removeAttribute('readonly');
            }
        });

        cancelBtn.addEventListener('click', function() {
            if (isFormDirty) {
                if (confirm('You have unsaved changes. Are you sure you want to cancel?')) {
                    window.location.reload();
                }
                // If they don't confirm, do nothing.
            } else {
                // If no changes, just reload.
                window.location.reload();
            }
        });

        // Image preview
        const profilePictureInput = document.getElementById('profilePictureInput');
        if (profilePictureInput) {
            profilePictureInput.onchange = evt => {
                const [file] = profilePictureInput.files;
                if (file) {
                    document.getElementById('profileImg').src = URL.createObjectURL(file);
                }
            }
        }

        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            // Replace any characters that are not letters or spaces.
            const regex = /[^a-zA-Z\s]/g;
            event.target.value = event.target.value.replace(regex, '');
        }

        const givenNameInput = document.querySelector('input[name="givenName"]');
        const middleNameInput = document.querySelector('input[name="middleName"]');
        const surnameInput = document.querySelector('input[name="surname"]');
        givenNameInput.addEventListener('input', restrictNameInput);
        middleNameInput.addEventListener('input', restrictNameInput);
        surnameInput.addEventListener('input', restrictNameInput);

        // --- Contact Number Input Logic ---
        const contactInput = document.querySelector('input[name="contactNumber"]');
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
                        if (!reqEl) continue;
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
    });
</script>
</body>
</html>
