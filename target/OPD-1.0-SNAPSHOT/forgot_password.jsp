<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
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
    </style>
</head>
<body>
    <div class="card p-4">
        <div class="text-center mb-4">
            <h3 class="fw-bold">Reset Your Password</h3>
            <p class="text-muted">Please enter your registered contact number. We will send an OTP to verify your identity.</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert"><i class="fas fa-exclamation-triangle me-2"></i><c:out value="${param.error}"/></div>
        </c:if>

        <form action="ForgotPasswordServlet" method="post">
            <div class="mb-3">
                <label for="contactNumber" class="form-label">Contact Number</label>
                <input type="tel" class="form-control" id="contactNumber" name="contactNumber" required value="+63" pattern="^(09|\+639)\d{9}$" title="Enter a valid Philippine contact number (09... or +639...).">
            </div>
            <button type="submit" class="btn btn-primary w-100">Send Verification Code</button>
        </form>
        <div class="text-center mt-3">
            <a href="<c:url value='/login.jsp'/>" class="text-decoration-none"><i class="fas fa-arrow-left me-1"></i>Back to Login</a>
        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Handle contact number input field logic
    const contactInput = document.getElementById('contactNumber');
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
</script>
</body>
</html>
