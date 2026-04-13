<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Privacy and Safety - Aurora Memorial Hospital</title>
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
        .policy-container {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        .policy-header {
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
        <div class="policy-container p-4 p-md-5">
            <div class="text-center mb-5">
                <h1 class="policy-header d-inline-block">Privacy and Safety Policy</h1>
                <p class="text-muted mt-3">Last Updated: November 2025</p>
            </div>

            <h4 class="text-success fw-bold">1. Introduction</h4>
            <p>The Aurora Memorial Hospital (AMH) Out-Patient Department Management System is committed to protecting the privacy and security of your personal and health information. This policy outlines how we collect, use, and safeguard your data.</p>

            <h4 class="text-success fw-bold mt-4">2. Information We Collect</h4>
            <p>We collect information that you provide during registration and use of our services, including:</p>
            <ul>
                <li><strong>Personal Identification Information:</strong> Name, date of birth, gender, address, and contact details.</li>
                <li><strong>Health Information:</strong> Medical history, appointment details, and other health-related data required for your treatment.</li>
                <li><strong>Account Information:</strong> Username and password for accessing the portal.</li>
            </ul>

            <h4 class="text-success fw-bold mt-4">3. How We Use Your Information</h4>
            <p>Your information is used to:</p>
            <ul>
                <li>Provide and manage your healthcare services and appointments.</li>
                <li>Verify your identity and secure your account.</li>
                <li>Communicate with you regarding your appointments and health status.</li>
                <li>Comply with legal and regulatory requirements.</li>
            </ul>

            <h4 class="text-success fw-bold mt-4">4. Data Security</h4>
            <p>We implement robust security measures to protect your data from unauthorized access, alteration, or disclosure. These include data encryption, access controls, and regular security assessments. Your password is encrypted, and we urge you to keep it confidential.</p>

            <h4 class="text-success fw-bold mt-4">5. Your Responsibilities</h4>
            <ul>
                <li>Keep your login credentials (username and password) secure and do not share them with anyone.</li>
                <li>Ensure the information you provide is accurate and up-to-date.</li>
                <li>Log out of your account after each session, especially on shared devices.</li>
            </ul>

            <h4 class="text-success fw-bold mt-4">6. Your Rights</h4>
            <p>You have the right to access, review, and request corrections to your personal information stored in our system. For any such requests, please contact our hospital administration.</p>

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