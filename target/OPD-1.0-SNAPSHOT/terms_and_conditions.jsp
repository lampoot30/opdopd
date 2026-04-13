<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Terms and Conditions - Aurora Memorial Hospital</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <!-- Favicon -->
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
        }
        .navbar-light-custom {
            background-color: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
        }
        .terms-container {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        .terms-header {
            color: #28a745;
            font-weight: 600;
            border-bottom: 2px solid #28a745;
            padding-bottom: 10px;
        }
        .footer-light {
            background-color: #f1f3f5;
            border-top: 1px solid #e9ecef;
        }
        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
        }
    </style>
</head>
<body>

    <!-- Public Navigation Bar -->
    <jsp:include page="navbar-public.jsp" />

    <div class="container my-5 fade-in">
        <div class="terms-container p-4 p-md-5">
            <div class="text-center mb-5">
                <h1 class="terms-header d-inline-block">Terms and Conditions</h1>
                <p class="text-muted mt-3">Last Updated: November 2025</p>
            </div>

            <h4 class="text-success fw-bold">1. Acceptance of Terms</h4>
            <p>By accessing and using the Aurora Memorial Hospital (AMH) Out-Patient Department Management System ("Service"), you accept and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the Service.</p>

            <h4 class="text-success fw-bold mt-4">2. User Account and Responsibilities</h4>
            <p>You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account. You must be 18 years of age or older to register for an account.</p>

            <h4 class="text-success fw-bold mt-4">3. Use of Service</h4>
            <p>The Service is intended for personal, non-commercial use to manage your health records and appointments at AMH. You agree not to use the Service for any unlawful purpose or in any way that could damage, disable, or impair the Service.</p>

            <h4 class="text-success fw-bold mt-4">4. Medical Disclaimer</h4>
            <p>This Service provides access to your medical information but does not constitute medical advice. Always seek the direct advice of your physician or other qualified health providers with any questions you may have regarding a medical condition.</p>

            <h4 class="text-success fw-bold mt-4">5. Limitation of Liability</h4>
            <p>AMH is not liable for any direct, indirect, incidental, or consequential damages resulting from the use or inability to use the Service, including but not limited to, reliance by a user on any information obtained from the Service.</p>

            <h4 class="text-success fw-bold mt-4">6. Changes to Terms</h4>
            <p>We reserve the right to modify these Terms and Conditions at any time. We will notify you of any changes by posting the new terms on this page. Your continued use of the Service after any such changes constitutes your acceptance of the new terms.</p>

            <h4 class="text-success fw-bold mt-4">7. Contact Information</h4>
            <p>If you have any questions about these Terms, please contact us at 
    <a href="https://mail.google.com/mail/?view=cm&fs=1&to=Auroramemhos@gmail.com&su=Inquiry regarding Terms and Conditions" 
       target="_blank" 
       rel="noopener noreferrer" 
       class="text-decoration-none fw-bold text-success">
        Auroramemhos@gmail.com
    </a>.
</p>


            <div class="text-center mt-5">
                <a href="<c:url value='/index.jsp'/>" class="btn btn-outline-success"><i class="fas fa-arrow-left me-2"></i>Back to Home</a>
            </div>
        </div>
    </div>

    <footer class="footer-light pt-4 pb-3 mt-5">
        <div class="container text-center">
            <p class="text-muted mb-0">&copy; 2025 Out-Patient Department Management System. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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