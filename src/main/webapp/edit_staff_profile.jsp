<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit My Profile - Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: #17a2b8; }
        .form-label { font-weight: 500; }
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

<c:import url="staff_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Edit My Profile</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Update Your Information</h5>
            </div>
            <div class="card-body p-4">
                <form action="update-staff-profile" method="post" enctype="multipart/form-data">
                    <div class="row mb-4">
                        <div class="col-md-3 text-center">
                            <img id="imagePreview" src="<c:url value='${not empty staffProfile.profilePicturePath ? staffProfile.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Preview" class="img-thumbnail rounded-circle" style="width: 150px; height: 150px; object-fit: cover;">
                            <label for="profilePicture" class="btn btn-sm btn-outline-info mt-3">
                                <i class="fas fa-upload me-1"></i> Change Picture
                            </label>
                            <input type="file" class="form-control d-none" id="profilePicture" name="profile_picture" accept="image/*">
                        </div>
                        <div class="col-md-9">
                            <h5 class="mb-3">Personal Information</h5>
                            <div class="row">
                                <div class="col-md-4 mb-3"><label for="surname" class="form-label">Surname</label><input type="text" class="form-control" id="surname" name="surname" value="<c:out value='${staffProfile.surname}'/>" required></div>
                                <div class="col-md-4 mb-3"><label for="givenName" class="form-label">Given Name</label><input type="text" class="form-control" id="givenName" name="givenName" value="<c:out value='${staffProfile.givenName}'/>" required></div>
                                <div class="col-md-4 mb-3"><label for="middleName" class="form-label">Middle Name</label><input type="text" class="form-control" id="middleName" name="middleName" value="<c:out value='${staffProfile.middleName}'/>"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3"><label for="dateOfBirth" class="form-label">Date of Birth</label><input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="${staffProfile.dateOfBirth}" required></div>
                                <div class="col-md-4 mb-3"><label for="age" class="form-label">Age</label><input type="text" class="form-control" id="age" name="age" value="${staffProfile.age} years old" readonly></div>
                                <div class="col-md-4 mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Male" ${staffProfile.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${staffProfile.gender == 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${staffProfile.gender == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="permanentAddress" class="form-label">Permanent Address</label>
                                <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" required readonly><c:out value='${staffProfile.permanentAddress}'/></textarea>
                            </div>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="sameAsPermanent" disabled>
                                <label class="form-check-label" for="sameAsPermanent">
                                    My current address is the same as my permanent address.
                                </label>
                            </div>
                            <div class="mb-3">
                                <label for="currentAddress" class="form-label">Current Address</label>
                                <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" required readonly><c:out value='${currentAddress}'/></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="city" class="form-label">City/Town (Aurora)</label>
                                    <select class="form-select" id="city" name="city" required disabled>
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
                        <div class="col-md-6 mb-3"><label for="username" class="form-label">Username</label><input type="text" class="form-control" id="username" name="username" value="<c:out value='${staffProfile.user.username}'/>" readonly></div>
                        <div class="col-md-6 mb-3"><label for="contactNumber" class="form-label">Contact Number</label><input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="<c:out value='${staffProfile.user.contactNumber}'/>" required></div>
                    </div>

                    <div class="text-end mt-4">
                        <button type="button" id="cancelButton" class="btn btn-secondary me-2">Cancel</button>
                        <button type="submit" class="btn btn-info text-white"><i class="fas fa-save me-2"></i>Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Change Password Card -->
        <div class="card mt-4">
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
                                <button class="password-toggle-btn" type="button" id="toggleCurrentPassword">
                                    <i class="fas fa-eye" id="currentPasswordIcon"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <div class="position-relative">
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <button class="password-toggle-btn" type="button" id="toggleNewPassword">
                                    <i class="fas fa-eye" id="newPasswordIcon"></i>
                                </button>
                            </div>
                            <div class="mt-2">
                                <div id="password-strength-bar" class="progress" style="height: 5px;"></div>
                                <small id="password-strength-text" class="form-text text-muted"></small>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <div class="position-relative">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <button class="password-toggle-btn" type="button" id="toggleConfirmPassword">
                                    <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                </button>
                            </div>
                            <div class="mt-2">
                                <div id="confirm-password-strength-bar" class="progress" style="height: 5px;"></div>
                                <small id="confirm-password-strength-text" class="form-text text-muted"></small>
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
    document.getElementById('profilePicture').addEventListener('change', function(event) {
        const [file] = event.target.files;
        if (file) {
            document.getElementById('imagePreview').src = URL.createObjectURL(file);
        }
    });

    document.getElementById('dateOfBirth').addEventListener('change', function() {
        const dobInput = document.getElementById('dateOfBirth');
        const ageInput = document.getElementById('age');
        const dobValue = dobInput.value;

        if (dobValue) {
            const dob = new Date(dobValue);
            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDiff = today.getMonth() - dob.getMonth();

            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                age--;
            }

            ageInput.value = age + ' years old';
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        let isFormDirty = false;
        function calculateAge() {
            const dobInput = document.getElementById('dateOfBirth');
            const ageInput = document.getElementById('age');
            const dobValue = dobInput.value;
    
            if (dobValue) {
                const dob = new Date(dobValue);
                const today = new Date();
                let age = today.getFullYear() - dob.getFullYear();
                const monthDiff = today.getMonth() - dob.getMonth();
    
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                    age--;
                }
    
                ageInput.value = age + ' years old';
            }
        }
        calculateAge();

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

        // --- Password Strength Meter ---
        const passwordField = document.getElementById('newPassword');
        const strengthBar = document.getElementById('password-strength-bar');
        const strengthText = document.getElementById('password-strength-text');

        if (passwordField && strengthBar && strengthText) {
            passwordField.addEventListener('input', function() {
                const password = this.value;
                const strength = checkPasswordStrength(password);

                strengthBar.innerHTML = ''; // Clear previous bars
                strengthText.textContent = strength.text;

                const bar = document.createElement('div');
                bar.classList.add('progress-bar');
                bar.style.width = strength.width;
                bar.classList.add(strength.color);
                strengthBar.appendChild(bar);
            });
        }

        // --- Password Strength Meter for Confirm Password ---
        const confirmPasswordField = document.getElementById('confirmPassword');
        const confirmStrengthBar = document.getElementById('confirm-password-strength-bar');
        const confirmStrengthText = document.getElementById('confirm-password-strength-text');

        if (confirmPasswordField && confirmStrengthBar && confirmStrengthText) {
            confirmPasswordField.addEventListener('input', function() {
                const password = this.value;
                const strength = checkPasswordStrength(password);

                confirmStrengthBar.innerHTML = ''; // Clear previous bars
                confirmStrengthText.textContent = strength.text;
                const bar = document.createElement('div');
                bar.classList.add('progress-bar');
                bar.style.width = strength.width;
                bar.classList.add(strength.color);
                confirmStrengthBar.appendChild(bar);
            });
        }

        function checkPasswordStrength(password) {
            let score = 0;
            if (password.length >= 8) score++;
            if (password.match(/[a-z]/)) score++;
            if (password.match(/[A-Z]/)) score++;
            if (password.match(/[0-9]/)) score++;
            if (password.match(/[^a-zA-Z0-9]/)) score++;

            switch (score) {
                case 0:
                case 1:
                case 2:
                    return { text: 'Weak', width: '25%', color: 'bg-danger' };
                case 3:
                    return { text: 'Medium', width: '50%', color: 'bg-warning' };
                case 4:
                    return { text: 'Strong', width: '75%', color: 'bg-info' };
                case 5:
                    return { text: 'Very Strong', width: '100%', color: 'bg-success' };
                default:
                    return { text: '', width: '0%', color: '' };
            }
        }

        // Initialize all password toggles on the page
        setupPasswordToggle('toggleCurrentPassword', 'currentPassword', 'currentPasswordIcon');
        setupPasswordToggle('toggleNewPassword', 'newPassword', 'newPasswordIcon');
        setupPasswordToggle('toggleConfirmPassword', 'confirmPassword', 'confirmPasswordIcon');

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

        // --- Unsaved Changes Confirmation ---
        const form = document.querySelector('form[action="update-staff-profile"]');
        form.addEventListener('input', function() {
            isFormDirty = true;
        });

        const cancelButton = document.getElementById('cancelButton');
        cancelButton.addEventListener('click', function(e) {
            if (isFormDirty) {
                if (!confirm('You have unsaved changes. Are you sure you want to cancel?')) {
                    e.preventDefault();
                } else {
                    window.location.href = "<c:url value='/staff-profile'/>";
                }
            } else {
                window.location.href = "<c:url value='/staff-profile'/>";
            }
        });
    });


    // --- Session Timeout ---
    (function() {
        let inactivityTimer;
        const timeoutDuration = 15 * 60 * 1000; // 15 minutes, matches web.xml

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
    })();
</script>
</body>
</html>
