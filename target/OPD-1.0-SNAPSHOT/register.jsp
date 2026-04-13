<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Patient Registration - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="<c:url value='/css/custom-style.css'/>" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #ffffff;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }
        .registration-wrapper {
            width: 100%;
            max-width: 100%;
            min-height: 100vh;
            margin: 0;
            position: relative;
        }

        @media (min-width: 992px) {
            .registration-wrapper {
                height: 100vh;
                overflow: hidden;
            }
        }

        /* Branded Sidebar */
        .registration-sidebar {
            background: linear-gradient(180deg, #198754 0%, #0d5032 100%);
            padding: 100px 60px 60px;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: space-between;
            text-align: left;
            min-height: 100vh;
        }

        /* Main Form Area */
        .registration-main {
            padding: 0;
            background-color: #ffffff;
        }

        @media (min-width: 992px) {
            .registration-main {
                height: 100vh;
                overflow-y: auto;
            }
        }

        .logo-section {
            text-align: center;
            margin-bottom: 40px;
        }
        .logo-section img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            box-shadow: 0 10px 30px rgba(40, 167, 69, 0.3);
            margin-bottom: 20px;
        }
        .logo-section h2 {
            color: #28a745;
            font-weight: 700;
            font-size: 28px;
        }

        .header-logo {
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
            padding: 8px;
            margin-right: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .header-logo:hover { transform: scale(1.05); }
        
        .form-section-title {
            font-weight: 700;
            color: #198754;
            font-size: 1.5rem;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
            margin-bottom: 30px;
            letter-spacing: -0.5px;
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
            padding: .375rem .75rem; /* Align with form-control padding */
        }
        
        /* Sidebar Steps styling */
        .step-item {
            display: flex;
            align-items: center;
            margin-bottom: 2.5rem;
            opacity: 0.7;
            transition: opacity 0.3s;
        }
        .step-item.active { opacity: 1; }
        .step-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-weight: bold;
            border: 2px solid transparent;
        }
        .active .step-icon {
            background: #ffffff;
            color: #198754;
            border-color: #ffffff;
        }

        .back-button {
            position: absolute;
            top: 25px;
            left: 25px;
            padding: 8px 16px;
            background-color: #f8f9fa;
            color: #198754;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
            z-index: 1000;
        }
        .back-button:hover {
            background-color: #e9ecef;
            color: #157347;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        @media (max-width: 768px) {
            .registration-main { padding: 80px 20px 40px; }
            .logo-section h2 { font-size: 24px; }
            .back-button {
                top: 15px !important;
                left: 15px !important;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50% !important;
                padding: 0 !important;
            }
            .back-button span { display: none; }
        }

        /* Smooth Transitions */
        .fade-in {
            animation: fadeIn 0.8s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="registration-wrapper fade-in">
    <a href="<c:url value='/index.jsp'/>" class="back-button" title="Back to Home">
        <i class="fas fa-arrow-left"></i><span class="ms-2">Back to Home</span>
    </a>

    <div class="row g-0 min-vh-100">
        <!-- Left Sidebar: Visible on Desktop -->
        <div class="col-lg-5 d-none d-lg-flex registration-sidebar shadow-lg">
            <div>
                <div class="mb-5">
                    <img src="<c:url value='/images/AURORA.png'/>" alt="Aurora Logo" class="header-logo">
                    <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo" class="header-logo">
                </div>
                <h2 class="fw-bold display-6 mb-4">Patient Portal Registration</h2>
                
                <div class="step-list mt-5">
                    <div class="step-item active">
                        <div class="step-icon">1</div>
                        <div>
                            <div class="fw-bold text-uppercase small">Step 1</div>
                            <div>Personal Details</div>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-icon">2</div>
                        <div>
                            <div class="fw-bold text-uppercase small">Step 2</div>
                            <div>Residential Info</div>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-icon">3</div>
                        <div>
                            <div class="fw-bold text-uppercase small">Step 3</div>
                            <div>Security Setup</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="small opacity-50">
                &copy; 2025 Aurora Memorial Hospital. <br>All medical data is encrypted and secure.
            </div>
        </div>

        <!-- Right Main Area: The Form -->
        <div class="col-lg-7 col-12 registration-main p-4 p-md-5 d-flex align-items-center justify-content-center">
            <div class="w-100" style="max-width: 900px;">
                <!-- Mobile Header (Hidden on Desktop) -->
                <div class="logo-section d-lg-none">
                    <img src="<c:url value='/images/AURORA.png'/>" alt="Aurora Logo" class="me-2">
                    <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo">
                    <h2 class="mt-3">Create Account</h2>
                    <p class="text-muted">Join our digital healthcare platform</p>
                </div>

                <!-- Desktop Title (Hidden on Mobile) -->
                <div class="d-none d-lg-block mb-4">
                    <h1 class="text-success fw-bold">Registration</h1>
                    <p class="text-muted">Fill in your details to get started.</p>
                </div>

            <form action="RegisterServlet" method="post" enctype="multipart/form-data">
                <!-- SECTION 1 -->
                <div id="section-personal" class="mb-5">
                    <h5 class="form-section-title"><i class="fas fa-user-circle me-3"></i>Personal Information</h5>
                    <div class="row g-4">
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="surname" name="surname" placeholder="Surname" required pattern="[a-zA-Z\s'-]+" title="Only letters, spaces, hyphens, and apostrophes are allowed.">
                                    <label for="surname">Surname</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="givenName" name="givenName" placeholder="Given Name" required pattern="[a-zA-Z\s'-]+" title="Only letters, spaces, hyphens, and apostrophes are allowed.">
                                    <label for="givenName">Given Name</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="middleName" name="middleName" placeholder="Middle Name" pattern="[a-zA-Z\s'.\-]+" title="Only letters, spaces, hyphens, apostrophes, and periods are allowed.">
                                    <label for="middleName">Middle Name</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                                    <label for="dateOfBirth">Date of Birth</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="age" name="age" readonly placeholder="Age will be calculated">
                                    <label for="age">Age</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                    <label for="gender">Gender</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="religion" name="religion" placeholder="Religion" pattern="[a-zA-Z\s]+" title="Only letters and spaces are allowed.">
                                    <label for="religion">Religion</label>
                                </div>
                            </div>
                        </div>
                </div>

                <!-- SECTION 2 -->
                <div id="section-address" class="mb-5 pt-4">
                    <h5 class="form-section-title"><i class="fas fa-map-marker-alt me-3"></i>Address Information</h5>
                        <div class="form-floating mb-3">
                            <textarea class="form-control shadow-sm" id="permanentAddress" name="permanentAddress" style="height: 120px" required placeholder="Permanent Address"></textarea>
                            <label for="permanentAddress">Permanent Address</label>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="sameAsPermanent">
                            <label class="form-check-label small text-muted" for="sameAsPermanent">My current address is same as permanent</label>
                        </div>
                        <div class="form-floating mb-3">
                            <textarea class="form-control shadow-sm" id="currentAddress" name="currentAddress" style="height: 120px" required placeholder="Current Address"></textarea>
                            <label for="currentAddress">Current Address</label>
                        </div>
                        <div class="row g-3 g-md-4">
                            <div class="col-md-6">
                                <div class="form-floating">
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
                                    <label for="city">City/Town (Aurora)</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="postalCode" name="postalCode" required readonly placeholder="Postal Code">
                                    <label for="postalCode">Postal/ZIP Code</label>
                                </div>
                            </div>
                        </div>
                </div>

                <!-- SECTION 3 -->
                <div id="section-security" class="mb-5 pt-4">
                    <h5 class="form-section-title"><i class="fas fa-shield-alt me-3"></i>Account & Security</h5>
                    <div class="row g-4">
                            <div class="col-md-6">
                                <div class="form-floating shadow-sm">
                                    <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="+63" required pattern="^(09|\+639)\d{9}$" title="Enter a valid Philippine number (e.g., +639... or 09...).">
                                    <label for="contactNumber">Contact Number</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating shadow-sm">
                                    <input type="text" class="form-control" id="username" name="username" required readonly placeholder="Username">
                                    <label for="username">Username</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating shadow-sm position-relative">
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                    <label for="password">Password</label>
                                    <button class="password-toggle-btn" type="button" id="togglePassword">
                                        <i class="fas fa-eye" id="passwordIcon"></i>
                                    </button>
                                </div>
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
                            <div class="col-md-6">
                                <div class="form-floating shadow-sm position-relative">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                                    <label for="confirmPassword">Confirm Password</label>
                                    <button class="password-toggle-btn" type="button" id="toggleConfirmPassword">
                                        <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                </div>

                <div class="mb-5 pt-4">
                    <h5 class="form-section-title"><i class="fas fa-camera me-3"></i>Profile Picture</h5>
                        <div class="mb-4">
                            <label for="profilePicture" class="form-label small text-muted">Upload Picture (Optional)</label>
                            <input class="form-control py-3" type="file" id="profilePicture" name="profile_picture" accept="image/*">
                        </div>
                </div>

                <div class="d-grid gap-2 mt-5">
                    <button type="submit" class="btn btn-success btn-lg py-4 fw-bold shadow" style="border-radius: 12px; font-size: 1.3rem;">
                        <i class="fas fa-user-plus me-2"></i> Complete Registration
                    </button>
                </div>
                <div class="text-center mt-5 mb-5">
                    <p class="text-muted">Already have an account? <a href="<c:url value='/login.jsp'/>" class="text-success fw-bold text-decoration-none border-bottom border-success">Login here</a></p>
                </div>
            </form>
        </div>
            </div>
        </div>
    </div>
</div>

<!-- Error Modal -->
<div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px; border-left: 5px solid #dc3545;">
            <div class="modal-header" style="border-bottom: none;">
                <h5 class="modal-title text-danger" id="errorModalLabel"><i class="fas fa-times-circle me-2 text-danger"></i>Error</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="errorModalBody">
                <p class="text-muted">An error occurred.</p>
            </div>
            <div class="modal-footer" style="border-top: none;">
                <button type="button" class="btn btn-danger" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px; border-left: 5px solid #28a745;">
            <div class="modal-header" style="border-bottom: none;">
                <h5 class="modal-title text-success" id="successModalLabel"><i class="fas fa-check-circle me-2 text-success"></i>Success</h5>
            </div>
            <div class="modal-body">
                <p>Registration successful! You can now log in.</p>
            </div>
            <div class="modal-footer" style="border-top: none;">
                <a href="<c:url value='/login.jsp'/>" class="btn btn-success">Proceed to Login</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');

        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            // Replace any characters that are not letters or spaces.
            const regex = /[^a-zA-Z\s]/g;
            event.target.value = event.target.value.replace(regex, '');
        }

        document.getElementById('surname').addEventListener('input', restrictNameInput);
        document.getElementById('givenName').addEventListener('input', restrictNameInput);
        document.getElementById('middleName').addEventListener('input', restrictNameInput);
        document.getElementById('religion').addEventListener('input', restrictNameInput);

        const permanentAddress = document.getElementById('permanentAddress');
        const currentAddress = document.getElementById('currentAddress');

        sameAsPermanentCheckbox.addEventListener('change', function() {
            if (this.checked) {
                // Copy value from permanent to current and make it readonly
                currentAddress.value = permanentAddress.value;
                currentAddress.setAttribute('readonly', true);
            } else {
                // Clear current address and make it editable again
                currentAddress.value = '';
                currentAddress.removeAttribute('readonly');
            }
        });

        // Also update if the permanent address is changed while the box is checked
        permanentAddress.addEventListener('input', function() {
            if (sameAsPermanentCheckbox.checked) {
                currentAddress.value = this.value;
            }
        });

        // Auto-populate ZIP code based on city selection
        const cityDropdown = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');
        cityDropdown.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            postalCodeInput.value = selectedOption.getAttribute('data-zip') || '';
        });

        // Age calculation from Date of Birth
        const dobInput = document.getElementById('dateOfBirth');
        if (dobInput) {
            const today = new Date().toISOString().split('T')[0];
            dobInput.setAttribute('max', today);
        }

        dobInput.addEventListener('change', function() {
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

        // Auto-generate username from name fields
        function generateUsername() {
            const surname = document.getElementById('surname').value.trim().toLowerCase();
            const givenName = document.getElementById('givenName').value.trim().toLowerCase();
            const middleName = document.getElementById('middleName').value.trim().toLowerCase();

            if (surname && givenName) {
                let username = surname + '.' + givenName;
                if (middleName) {
                    username += '.' + middleName.charAt(0);
                }
                document.getElementById('username').value = username;
            }
        }
        document.getElementById('surname').addEventListener('input', generateUsername);
        document.getElementById('givenName').addEventListener('input', generateUsername);
        document.getElementById('middleName').addEventListener('input', generateUsername);

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

        // Initialize password toggles
        setupPasswordToggle('togglePassword', 'password', 'passwordIcon');
        setupPasswordToggle('toggleConfirmPassword', 'confirmPassword', 'confirmPasswordIcon');

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

        // Initialize for both password fields
        setupPasswordStrengthChecker('password', 'password-requirements', '');

        // --- Password confirmation validation ---
        const form = document.querySelector('form');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');

        // Helper function to show the error modal with a custom message
        function showErrorModal(message) {
            const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
            document.getElementById('errorModalBody').innerHTML = `<p>${message}</p>`;
            errorModal.show();
        }

        form.addEventListener('submit', function(e) {
            // Normalize contact number before submission
            const contactNumberInput = document.getElementById('contactNumber');
            let contactNumber = contactNumberInput.value.trim();
            if (contactNumber.startsWith('09') && contactNumber.length === 11) {
                contactNumberInput.value = '+63' + contactNumber.substring(1);
            }

            if (password.value !== confirmPassword.value) {
                e.preventDefault();
                showErrorModal('Passwords do not match. Please re-enter your password.');
                return;
            }

            // Age validation
            const dobInput = document.getElementById('dateOfBirth');
            const dob = new Date(dobInput.value);
            if (!dobInput.value) return; // Let 'required' attribute handle empty field

            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDifference = today.getMonth() - dob.getMonth();
            if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < dob.getDate())) {
                age--;
            }

            if (age < 18) {
                e.preventDefault();
                showErrorModal('You must be 18 years of age or older to register.');
                return;
            }

            // Re-enable the username field just before submission so its value is sent
            document.getElementById('username').readOnly = false;
        });

        // Handle contact number input field logic
        const contactInput = document.getElementById('contactNumber');
        contactInput.addEventListener('focus', function() {
            if (this.value === '') {
                this.value = '+63';
            }
        });
        contactInput.addEventListener('blur', function() {
            // If the user clicks away and the field only contains "+63", clear it
            // so the 'required' validation can catch it if they try to submit.
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
    });

    // Display error modal if error parameter is present in URL
    const urlParams = new URLSearchParams(window.location.search);
    const errorMessage = urlParams.get('error');
    const successParam = urlParams.get('success');

    if (errorMessage) {
        const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
        document.getElementById('errorModalBody').textContent = decodeURIComponent(errorMessage);
        errorModal.show();
        // Optionally, remove the error parameter from the URL after displaying
        history.replaceState(null, '', window.location.pathname);
    }

    if (successParam === 'true') {
        const successModal = new bootstrap.Modal(document.getElementById('successModal'));
        successModal.show();
        // Remove the success parameter from the URL
        history.replaceState(null, '', window.location.pathname);
    }

    // Smooth fade-in animation
    document.addEventListener("DOMContentLoaded", function() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.fade-in').forEach(element => {
            observer.observe(element);
        });
    });
</script>
</body>
</html>