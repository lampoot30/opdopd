<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check: Only allow Staff users to access this page.
    if (!"Staff".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>My Profile - Staff Portal</title>
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
            color: #17a2b8; /* Staff primary color */
        }
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
        .form-control[readonly] {
            background-color: #e9ecef;
            opacity: 1;
        }
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        .detail-item {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
        }
        .detail-item .label {
            font-weight: 600;
            color: #6c757d;
            font-size: 0.9rem;
            display: block;
            margin-bottom: 0.25rem;
        }
        .detail-item .value {
            font-size: 1.1rem;
            color: #343a40;
        }
    </style>
</head>
<body>

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Profile Header -->
        <div class="profile-header d-flex align-items-center">
            <div class="me-4 position-relative">
                <img id="profileImg" src="<c:url value='${not empty staffProfile.profilePicturePath ? staffProfile.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Picture" style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover;">
            </div>
            <div>
                <h2 class="mb-0">${staffProfile.givenName} ${staffProfile.surname}</h2>
                <p class="text-muted mb-1">User ID: ${staffProfile.user.userId}</p>
                <span class="badge bg-info">${staffProfile.user.userType}</span>
            </div>
            <div class="ms-auto">
                <button id="editProfileBtn" class="btn btn-info text-white"><i class="fas fa-edit me-2"></i>Edit Profile</button>
                <div id="editModeButtons" style="display: none;">
                    <button type="button" id="cancelBtn" class="btn btn-secondary me-2"><i class="fas fa-times me-2"></i>Cancel</button>
                    <button type="submit" form="profileForm" class="btn btn-success"><i class="fas fa-save me-2"></i>Save Changes</button>
                </div>
            </div>
        </div>

        <!-- Profile Details -->
        <form id="profileForm" action="<c:url value='/update-staff-profile'/>" method="post" enctype="multipart/form-data">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Your Information</h5>
                </div>
                <div class="card-body p-4">
                    <h5 class="mb-3">Personal Details</h5>
                    <div class="row">
                        <div class="col-md-4 mb-3"><label class="form-label">Given Name</label><input type="text" class="form-control" id="givenName" name="givenName" value="<c:out value='${staffProfile.givenName}'/>" readonly></div>
                        <div class="col-md-4 mb-3"><label class="form-label">Middle Name</label><input type="text" class="form-control" id="middleName" name="middleName" value="<c:out value='${staffProfile.middleName}'/>" readonly></div>
                        <div class="col-md-4 mb-3"><label class="form-label">Surname</label><input type="text" class="form-control" id="surname" name="surname" value="<c:out value='${staffProfile.surname}'/>" readonly></div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3"><label class="form-label">Date of Birth</label><input type="text" class="form-control" name="dateOfBirth" value="<fmt:formatDate value='${staffProfile.dateOfBirth}' pattern='yyyy-MM-dd'/>" readonly></div>
                        <div class="col-md-4 mb-3"><label class="form-label">Age</label><input type="text" class="form-control" name="age" value="${staffProfile.age}" readonly></div>
                        <div class="col-md-4 mb-3"><label class="form-label">Gender</label><input type="text" class="form-control" name="gender" value="<c:out value='${staffProfile.gender}'/>" readonly></div>
                    </div>

                    <hr class="my-4">

                    <h5 class="mb-3">Address Details</h5>
                    <div class="mb-3">
                        <label for="permanentAddress" class="form-label">Permanent Address</label>
                        <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" readonly><c:out value='${staffProfile.address}'/></textarea>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="sameAsPermanent" disabled>
                        <label class="form-check-label" for="sameAsPermanent">Current address is the same as permanent address.</label>
                    </div>
                    <div class="mb-3">
                        <label for="currentAddress" class="form-label">Current Address</label>
                        <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" readonly><c:out value='${currentAddress}'/></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="city" class="form-label">City/Town (Aurora)</label>
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
                            <label for="postalCode" class="form-label">Postal/ZIP Code</label>
                            <input type="text" class="form-control" id="postalCode" name="postalCode" value="<c:out value='${postalCode}'/>" readonly>
                        </div>
                    </div>

                    <hr class="my-4">

                    <h5 class="mb-3">Account Details</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3"><label class="form-label">Username</label><input type="text" class="form-control" name="username" value="<c:out value='${staffProfile.user.username}'/>" readonly></div>
                        <div class="col-md-6 mb-3"><label class="form-label">Contact Number</label><input type="text" class="form-control" name="contactNumber" value="<c:out value='${staffProfile.user.contactNumber}'/>" readonly></div>
                    </div>
                </div>
            </div>
        </form>

        <!-- Profile Picture Upload Card (Initially Hidden) -->
        <div id="upload-section" class="card mt-4" style="display: none;">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-image me-2"></i>Profile Picture</h5>
            </div>
            <div class="card-body text-center">
                <input class="form-control form-control-sm" type="file" id="profilePictureInput" name="profile_picture" accept="image/*" form="profileForm">
            </div>
        </div>

        <!-- Change Password Card (Initially Hidden) -->
        <div id="changePasswordSection" class="card mt-4" style="display: none;">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-key me-2"></i>Change Password</h5>
            </div>
            <div class="card-body">
                <form action="change-password" method="post">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <div class="position-relative">
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <button class="password-toggle-btn" type="button" id="toggleCurrentPassword"><i class="fas fa-eye" id="currentPasswordIcon"></i></button>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <div class="position-relative">
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <button class="password-toggle-btn" type="button" id="toggleNewPassword"><i class="fas fa-eye" id="newPasswordIcon"></i></button>
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
                        <div class="col-md-4 mb-3">
                            <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                            <div class="position-relative">
                                <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                                <button class="password-toggle-btn" type="button" id="toggleConfirmNewPassword"><i class="fas fa-eye" id="confirmNewPasswordIcon"></i></button>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-info text-white"><i class="fas fa-key me-2"></i>Change Password</button>
                </form>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function() {
        // --- Edit Mode Toggle ---
        const editBtn = document.getElementById('editProfileBtn');
        const editModeButtons = document.getElementById('editModeButtons');
        const cancelBtn = document.getElementById('cancelBtn');
        const passwordSection = document.getElementById('changePasswordSection');
        const uploadSection = document.getElementById('upload-section');
        const form = document.getElementById('profileForm');
        const inputs = form.querySelectorAll('input, textarea, select');
        const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');

        editBtn.addEventListener('click', function() {
            inputs.forEach(input => {
                if (input.name !== 'username' && input.name !== 'age') {
                    input.readOnly = false;
                    input.disabled = false;
                }
            });
            document.querySelector('input[name="dateOfBirth"]').type = 'date';
            passwordSection.style.display = 'block';
            uploadSection.style.display = 'block';
            editBtn.style.display = 'none';
            editModeButtons.style.display = 'block';
        });

        cancelBtn.addEventListener('click', function() {
            window.location.reload();
        });

        // --- Session Timeout ---
        let inactivityTimer;
        const timeoutDuration = 15 * 60 * 1000; // 15 minutes

        function redirectToSessionExpired() {
            window.location.href = '<c:url value="/session_expired.jsp"/>';
        }

        function resetTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(redirectToSessionExpired, timeoutDuration);
        }

        window.onload = resetTimer;
        document.onmousemove = resetTimer;
        document.onkeypress = resetTimer;
        document.onclick = resetTimer;
        document.onscroll = resetTimer;
        document.onfocus = resetTimer;

        // --- Address Logic ---
        const permanentAddress = document.getElementById('permanentAddress');
        const currentAddress = document.getElementById('currentAddress');
        const cityDropdown = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');

        if (permanentAddress.value === currentAddress.value && permanentAddress.value) {
            sameAsPermanentCheckbox.checked = true;
        }

        sameAsPermanentCheckbox.addEventListener('change', function() {
            if (this.checked) {
                currentAddress.value = permanentAddress.value;
                currentAddress.readOnly = true;
            } else {
                currentAddress.readOnly = false;
            }
        });

        permanentAddress.addEventListener('input', function() {
            if (sameAsPermanentCheckbox.checked) {
                currentAddress.value = this.value;
            }
        });

        cityDropdown.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            postalCodeInput.value = selectedOption.getAttribute('data-zip') || '';
        });

        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            // Replace any characters that are not letters or spaces.
            const regex = /[^a-zA-Z\s]/g;
            event.target.value = event.target.value.replace(regex, '');
        }

        const givenNameInput = document.getElementById('givenName');
        const middleNameInput = document.getElementById('middleName');
        const surnameInput = document.getElementById('surname');
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

        // Initialize for both password fields
        setupPasswordStrengthChecker('newPassword', 'password-requirements', '');

    })();
</script>
</body>
</html>