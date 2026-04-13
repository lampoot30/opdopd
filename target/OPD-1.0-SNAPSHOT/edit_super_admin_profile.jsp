<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit My Profile - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin: 0; padding: 2rem; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: #dc3545; }
        .form-label { font-weight: 500; }
    </style>
    <style>
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

<c:import url="super_admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Edit My Profile</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${param.error}</div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Update Your Information</h5>
            </div>
            <div class="card-body p-4">
                <form action="update-super-admin-profile" method="post" enctype="multipart/form-data">
                    <div class="row mb-4">
                        <div class="col-md-3 text-center">
                            <img id="imagePreview" src="<c:url value='${not empty adminProfile.profilePicturePath ? adminProfile.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Preview" class="img-thumbnail rounded-circle" style="width: 150px; height: 150px; object-fit: cover;">
                            <label for="profilePicture" class="btn btn-sm btn-outline-danger mt-3">
                                <i class="fas fa-upload me-1"></i> Change Picture
                            </label>
                            <input type="file" class="form-control d-none" id="profilePicture" name="profile_picture" accept="image/*">
                        </div>
                        <div class="col-md-9">
                            <h5 class="mb-3">Personal Information</h5>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="surname" class="form-label">Surname</label>
                                    <input type="text" class="form-control" id="surname" name="surname" value="<c:out value='${adminProfile.surname}'/>" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="givenName" class="form-label">Given Name</label>
                                    <input type="text" class="form-control" id="givenName" name="givenName" value="<c:out value='${adminProfile.givenName}'/>" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="middleName" class="form-label">Middle Name</label>
                                    <input type="text" class="form-control" id="middleName" name="middleName" value="<c:out value='${adminProfile.middleName}'/>">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="<fmt:formatDate value='${adminProfile.dateOfBirth}' pattern='yyyy-MM-dd' />" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Male" ${adminProfile.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${adminProfile.gender == 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${adminProfile.gender == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="permanentAddress" class="form-label">Permanent Address</label>
                                <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" required><c:out value='${adminProfile.address}'/></textarea>
                            </div>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="sameAsPermanent">
                                <label class="form-check-label" for="sameAsPermanent">
                                    Current address is the same as permanent address.
                                </label>
                            </div>
                            <div class="mb-3">
                                <label for="currentAddress" class="form-label">Current Address</label>
                                <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" required><c:out value='${currentAddress}'/></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="city" class="form-label">City/Town (Aurora)</label>
                                    <select class="form-select" id="city" name="city" required>
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
                                    <input type="text" class="form-control" id="postalCode" name="postalCode" required readonly value="<c:out value='${postalCode}'/>">
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="mb-3">Account Information</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" value="<c:out value='${user.username}'/>" readonly>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="contactNumber" class="form-label">Contact Number</label>
                            <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="<c:out value='${user.contactNumber}'/>" required>
                        </div>
                    </div>

                    <div class="text-end mt-4">
                        <button type="button" id="cancelButton" class="btn btn-secondary">Cancel</button>
                        <button type="submit" class="btn btn-danger"><i class="fas fa-save me-2"></i>Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Change Password Card -->
        <div class="card mt-4">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0"><i class="fas fa-key me-2"></i>Change Password</h5>
            </div>
            <div class="card-body p-4">
                <form action="change-password" method="post">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <div class="position-relative">
                                <input type="password" class="form-control" id="currentPassword" name="oldPassword" required>
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
                            <!-- Confirm Password Requirements Checklist -->
                            <div id="confirm-password-requirements" class="mt-2" style="display: none;">
                                <ul class="list-unstyled mb-0 small">
                                    <li id="confirm-length" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least 8 characters</li>
                                    <li id="confirm-uppercase" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one uppercase letter (A-Z)</li>
                                    <li id="confirm-lowercase" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one lowercase letter (a-z)</li>
                                    <li id="confirm-number" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one number (0-9)</li>
                                    <li id="confirm-special" class="requirement text-danger"><i class="fas fa-times-circle me-2"></i>At least one special character (!@#$%^&*)</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="text-end"><button type="submit" class="btn btn-warning">Update Password</button></div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('profilePicture').addEventListener('change', function(event) {
        const [file] = event.target.files;
        if (file) {
            document.getElementById('imagePreview').src = URL.createObjectURL(file);
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        let isFormDirty = false;
        // --- Address Logic ---
        const permanentAddress = document.getElementById('permanentAddress');
        const currentAddress = document.getElementById('currentAddress');
        const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');
        const cityDropdown = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');

        // Initialize checkbox state on load
        if (permanentAddress.value === currentAddress.value && permanentAddress.value) {
            sameAsPermanentCheckbox.checked = true;
            currentAddress.setAttribute('readonly', true);
        }

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

        cityDropdown.addEventListener('change', function() {
            postalCodeInput.value = this.options[this.selectedIndex].getAttribute('data-zip') || '';
        });

        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            // Replace any characters that are not letters or spaces.
            const regex = /[^a-zA-Z\s]/g;
            event.target.value = event.target.value.replace(regex, '');
        }
        document.getElementById('surname').addEventListener('input', restrictNameInput);
        document.getElementById('givenName').addEventListener('input', restrictNameInput);
        document.getElementById('middleName').addEventListener('input', restrictNameInput);

        // --- Contact Number Input Logic ---
        const contactInput = document.getElementById('contactNumber');
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
        const form = document.querySelector('form[action="update-super-admin-profile"]');
        form.addEventListener('input', function() {
            isFormDirty = true;
        });

        const cancelButton = document.getElementById('cancelButton');
        cancelButton.addEventListener('click', function(e) {
            if (isFormDirty) {
                if (!confirm('You have unsaved changes. Are you sure you want to cancel?')) {
                    e.preventDefault(); // Stop the navigation
                } else {
                    window.location.href = "<c:url value='/super-admin-profile'/>";
                }
            } else {
                window.location.href = "<c:url value='/super-admin-profile'/>";
            }
        });
    });

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
    setupPasswordToggle('toggleCurrentPassword', 'currentPassword', 'currentPasswordIcon');
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

    // Initialize for both password fields
    setupPasswordStrengthChecker('newPassword', 'password-requirements', '');
</script>
</body>
</html>
