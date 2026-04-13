<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Verify Your Account</title>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: #f4f7f6; }
        .card { width: 100%; max-width: 450px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        #resendOtpBtn:disabled { cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="card p-4">
        <div class="text-center mb-4">
            <h3 class="fw-bold">Enter Verification Code</h3>
            <p class="text-muted">An OTP was sent to your number. Please enter the 6-digit code to complete your registration.</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert"><i class="fas fa-exclamation-triangle me-2"></i><c:out value="${param.error}"/></div>
        </c:if>

        <form action="VerifyRegistrationOtpServlet" method="post">
            <div class="mb-3">
                <label for="otp" class="form-label">Verification Code (OTP)</label>
                <input type="text" class="form-control text-center" id="otp" name="otp" required placeholder="6-digit code" maxlength="6" pattern="[0-9]{6}" inputmode="numeric" autofocus>
            </div>
            <button type="submit" class="btn btn-primary w-100">Verify & Register</button>
        </form>
        <div class="text-center mt-3">
            <button id="resendOtpBtn" class="btn btn-link text-decoration-none">Resend OTP</button>
            <span id="countdown" class="text-muted"></span>
        </div>
    </div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const resendBtn = document.getElementById('resendOtpBtn');
        const countdownSpan = document.getElementById('countdown');
        const fiveMinutesInMillis = 5 * 60 * 1000;
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
</script>
</body>
</html>