<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f4f7f6;
        }
        .card {
            width: 100%;
            max-width: 450px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
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
    <div class="card p-4">
        <div class="text-center mb-4">
            <h3 class="fw-bold">Enter New Password</h3>
            <p class="text-muted">An OTP was sent to your number. Please verify the code and set a new password.</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert"><i class="fas fa-exclamation-triangle me-2"></i><c:out value="${param.error}"/></div>
        </c:if>

        <form action="ResetPasswordServlet" method="post">
            <div class="mb-3">
                <label for="otp" class="form-label">Verification Code (OTP)</label>
                <input type="text" class="form-control text-center" id="otp" name="otp" required placeholder="6-digit code" maxlength="6" pattern="[0-9]{6}" inputmode="numeric" autofocus>
            </div>
            <div class="mb-3">
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
            <div class="mb-3">
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
            <button type="submit" class="btn btn-primary w-100">Reset Password</button>
        </form>
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div>
                <button id="resendOtpBtn" class="btn btn-link text-decoration-none p-0">Resend OTP</button>
                <span id="countdown" class="text-muted"></span>
            </div>
            <a href="<c:url value='/login.jsp'/>" class="text-decoration-none">Cancel</a>
        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const resendBtn = document.getElementById('resendOtpBtn');
        const countdownSpan = document.getElementById('countdown');
        const fiveMinutesInMillis = 5 * 60 * 1000;
        // The server sets lastOtpTime on the session when it first sends the OTP
        const lastOtpTime = <%= session.getAttribute("lastOtpTime") %>;

        function startCountdown(endTime) {
            resendBtn.disabled = true;
            const interval = setInterval(() => {
                const now = new Date().getTime();
                const distance = endTime - now;

                if (distance < 0) {
                    clearInterval(interval);
                    countdownSpan.textContent = '';
                    resendBtn.disabled = false;
                    return;
                }

                const minutes = Math.floor(distance / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                countdownSpan.textContent = `(Wait ${minutes}m ${seconds}s)`;
            }, 1000);
        }

        if (lastOtpTime) {
            const now = new Date().getTime();
            const timePassed = now - lastOtpTime;
            if (timePassed < fiveMinutesInMillis) {
                startCountdown(lastOtpTime + fiveMinutesInMillis);
            }
        }

        resendBtn.addEventListener('click', function() {
            fetch('resend-otp', { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.success) {
                        const newEndTime = new Date().getTime() + fiveMinutesInMillis;
                        startCountdown(newEndTime);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while trying to resend the OTP.');
                });
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
    setupPasswordToggle('toggleNewPassword', 'newPassword', 'newPasswordIcon');
    setupPasswordToggle('toggleConfirmPassword', 'confirmPassword', 'confirmPasswordIcon');

    // --- Password Strength Meter ---
    const passwordField = document.getElementById('newPassword');
    const strengthBar = document.getElementById('password-strength-bar');
    const strengthText = document.getElementById('password-strength-text');

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
    
    // --- Password Strength Meter for Confirm Password ---
    const confirmPasswordField = document.getElementById('confirmPassword');
    const confirmStrengthBar = document.getElementById('confirm-password-strength-bar');
    const confirmStrengthText = document.getElementById('confirm-password-strength-text');

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
</script>
</body>
</html>
