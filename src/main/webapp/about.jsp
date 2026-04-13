<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About Us - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
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
        .page-header {
            background: linear-gradient(135deg, #e8f5e9 0%, #f1f8e9 100%);
            padding: 4rem 0;
            text-align: center;
            margin-bottom: 3rem;
        }
        .content-section {
            padding: 3rem 0;
        }
        .info-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
            margin-bottom: 1.5rem;
            text-align: center;
            padding: 2rem;
            background-color: #fff;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .info-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        .info-card .icon {
            font-size: 3rem;
            color: #28a745;
            margin-bottom: 1rem;
        }
        .history-section {
            background-color: #fff;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
        }
        .footer-light {
            background-color: #f8f9fa;
            border-top: 1px solid #e9ecef;
            color: #555;
        }
        .social-icons .social-icon {
            display: inline-block;
            height: 40px;
            width: 40px;
            line-height: 40px;
            border-radius: 50%;
            background-color: #e9ecef;
            color: #28a745; /* Green icon color to match theme */
            transition: all 0.3s ease;
        }
        .social-icons .social-icon:hover {
            background-color: #28a745;
            color: #fff;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light-custom sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="<c:url value='/'/>">
                <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo" class="me-2" height="40">
                <span class="fw-bold">AMH Hospital OPD</span>
            </a>
            <ul class="navbar-nav ms-auto">
               <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/'/>">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/login.jsp'/>">Login</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/register.jsp'/>">Register</a>
                </li>
            </ul>
        </div>
    </nav>

    <header class="page-header">
        <div class="container">
            <h1 class="display-5 fw-bold text-success">About Aurora Memorial Hospital</h1>
            <p class="lead">Committed to providing compassionate and quality healthcare since 1949.</p>
        </div>
    </header>

    <main class="container content-section">
        <div class="row text-center g-4">
            <!-- Our Mission Card -->
            <div class="col-md-6">
                <div class="info-card h-100">
                    <div class="icon"><i class="fas fa-bullseye"></i></div>
                    <h3 class="fw-bold">Mission</h3>
                    <p class="text-muted">To ensure impartial access to quality, efficient and cost-effective hospital services by means of organizational development in conjunction with continuous enhancement of facilities, equipment and human resources.</p>
                </div>
            </div>
            <!-- Our Vision Card -->
            <div class="col-md-6">
                <div class="info-card h-100">
                    <div class="icon"><i class="fas fa-eye"></i></div>
                    <h3 class="fw-bold">Vision</h3>
                    <p class="text-muted">Aurora Memorial Hospital is envisioned to be the cental health referral facility for the Province. A hospital staffed with highly competent personnel who are efficiently providing excellent quality hospital care and service in the most responsive and professional conduct.</p>
                </div>
            </div>
            <!-- Overall Goal Card -->
            <div class="col-md-6">
                <div class="info-card h-100">
                    <div class="icon"><i class="fas fa-crosshairs"></i></div>
                    <h3 class="fw-bold">Overall Goal</h3>
                    <p class="text-muted">To improve the service capability in order to provide excellent hospital service with compassion.</p>
                </div>
            </div>
            <!-- Our Values Card -->
            <div class="col-md-6">
                <div class="info-card h-100">
                    <div class="icon"><i class="fas fa-heart"></i></div>
                    <h3 class="fw-bold">Our Values</h3>
                    <p class="text-muted" style="text-align: justify;">The staff of Aurora Memorial Hospital are committed to the highest standards of morals, integrity and professionalism. We consider ourselves accountable to our patients and their families, to our co-workers, their families, to the community we serve and to the needs of the weak and unwell; strive for excellence; and humble seek to be humane. We do not make professional or ethical deception in carrying out our pledged commitment. All our manner and conduct should emulate what we profess.</p>
                </div>
            </div>
        </div>

        <!-- History Section -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="history-section">
                    <h2 class="text-center fw-bold mb-4">Our History</h2>
                    <p class="text-center text-muted">
                        Established in 1949, Aurora Memorial Hospital has been a cornerstone of healthcare in the province of Aurora. For over 70 years, we have grown from a small clinic to a comprehensive medical facility, always staying true to our founding principles of service and compassion. This Out-Patient Department (OPD) Management System is our latest step in embracing technology to make healthcare more efficient and accessible for you, our valued patients.
                    </p>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer-light pt-5 pb-4 mt-5">
        <div class="container text-center">
            <div class="social-icons mb-3">
                <a href="https://www.facebook.com/profile.php?id=61553011967008" class="social-icon mx-2"><i class="fab fa-facebook"></i></a>
            </div>
            <p>&copy; 2026 Aurora Memorial Hospital.Out-Patient Department Management System. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
