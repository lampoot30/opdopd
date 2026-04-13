<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.time.*, java.util.*, com.mycompany.opd.resources.*" %>
<%
    // Determine today's clinic availability using the backend validator
    java.sql.Date todaySql = new java.sql.Date(System.currentTimeMillis());
    String unavailableReason = null;
    try (Connection conn = DBUtil.getConnection()) {
        unavailableReason = ScheduleValidator.getUnavailableReason(todaySql, conn);
    } catch (Exception e) {
        // Handle potential database connection issues gracefully for the landing page
    }
    int currentYear = LocalDate.now().getYear();
    request.setAttribute("holidays", ScheduleValidator.getPhilippineHolidays(currentYear));
    request.setAttribute("isTodayOpen", unavailableReason == null);
    request.setAttribute("todayReason", unavailableReason);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AMH Hospital - Out-Patient Department</title>
    <!-- Google Fonts (Poppins) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css" rel="stylesheet">
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="<c:url value='/css/custom-style.css'/>" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        :root {
            --primary-green: #198754;
            --primary-green-dark: #157347;
            --primary-green-light: rgba(25, 135, 84, 0.1);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fdfdfd;
        }

        /* --- Navigation Bar --- */
        .navbar-light-custom {
            background-color: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            transition: background-color 0.3s ease;
        }
        .navbar-light-custom .navbar-brand,
        .navbar-light-custom .nav-link {
            color: #333;
            font-weight: 500;
        }
        .navbar-light-custom .nav-link:hover {
            color: var(--primary-green);
        }

        /* --- Hero Section --- */
        .hero-section {
            background: linear-gradient(135deg, #e8f5e9 0%, #f1f8e9 100%);
            padding: 6rem 0;
        }

        /* --- Feature Cards --- */
        .feature-card {
            border: 1px solid #e0e0e0;
            border-top: 4px solid var(--primary-green);
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.08);
        }

        /* --- Footer --- */
        .footer-light {
            background-color: #f8f9fa;
            border-top: 1px solid #e9ecef;
            color: #555;
        }
        .footer-light .text-success {
            color: var(--primary-green-dark) !important;
        }
        .footer-light a {
            color: #555;
            transition: color 0.2s;
        }
        .footer-light a:hover {
            color: var(--primary-green);
        }

        /* --- Scroll Animation --- */
        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
        }

        /* --- Floating About Developer Button --- */
        .about-dev-container {
            position: fixed !important;
            bottom: 30px !important;
            right: 30px !important;
            z-index: 10000 !important;
        }
        .about-dev-link {
            display: inline-block;
            background-color: #f8f9fa;
            color: #333;
            padding: 10px 20px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            font-weight: 600;
            border: 1px solid #e9ecef;
        }
        .about-dev-link:hover {
            background-color: #198754; /* Bootstrap success color */
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(25, 135, 84, 0.3);
            border-color: #198754;
        }

        @media (max-width: 576px) {
            .about-dev-container {
                bottom: 15px !important;
                right: 15px !important;
            }
            .fc-toolbar-title { font-size: 1.2rem !important; }
            .fc .fc-button { padding: 0.4em 0.5em !important; font-size: 0.85em !important; }
        }

        /* --- Calendar Styling --- */
        .calendar-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border-top: 5px solid var(--primary-green);
        }
        .fc .fc-button-primary {
            background-color: var(--primary-green);
            border-color: var(--primary-green);
            text-transform: capitalize;
        }
        .fc .fc-button-primary:hover {
            background-color: var(--primary-green-dark);
            border-color: var(--primary-green-dark);
        }
        .fc .fc-daygrid-day.fc-day-today {
            background-color: var(--primary-green-light);
        }
        /* --- Weekend Coloring --- */
        .fc-day-sat, .fc-day-sun {
            background-color: #fff9c4 !important; /* Light Yellow */
        }
        
        .fc-toolbar-title { font-weight: 700; color: #333; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light-custom sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <img src="<c:url value='/images/AURORA.png'/>" alt="Aurora Logo" class="me-3" height="40">
                <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo" class="me-2" height="40">
                <span class="fw-bold d-none d-sm-inline">Aurora Memorial Hospital OPD</span>
                <span class="fw-bold d-inline d-sm-none">AMH OPD</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/login.jsp'/>">Login</a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/register.jsp'/>">Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section text-dark text-center">
        <div class="container">
            <h1 class="display-4 fw-bold text-success fade-in">Welcome to Aurora Memorial Hospital OPD</h1>
            <p class="lead my-4 fade-in" style="transition-delay: 0.1s;">Your health is our priority. Access patient services, book appointments, and manage your medical records with ease.</p>
            <a href="<c:url value='/login.jsp'/>" class="btn btn-success btn-lg">
                <i class="fas fa-sign-in-alt me-2"></i>Access Your Portal
            </a>
        </div>
    </header>

    <main class="container my-5">
        <section id="features" class="text-center py-5">
            <h2 class="mb-4 fw-bold text-success">OUR DIGITAL SERVICES</h2>
            <div class="row g-4 justify-content-center">
                <div class="col-md-6 col-lg-4 fade-in" style="transition-delay: 0.2s;">
                    <div class="card feature-card h-100">
                        <div class="card-body">
                            <div class="feature-icon text-white bg-success rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                <i class="fas fa-users fa-2x"></i>
                            </div>
                            <h3 class="card-title h5 fw-bold">Patient Management</h3>
                            <p class="card-text text-muted">Efficiently manage your personal and medical information in one secure place.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 fade-in" style="transition-delay: 0.3s;">
                    <div class="card feature-card h-100">
                        <div class="card-body">
                            <div class="feature-icon text-white bg-success rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                <i class="fas fa-calendar-check fa-2x"></i>
                            </div>
                            <h3 class="card-title h5 fw-bold">Appointment Booking</h3>
                            <p class="card-text text-muted">Schedule, view, and manage your appointments with our specialists seamlessly.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 fade-in" style="transition-delay: 0.4s;">
                    <div class="card feature-card h-100">
                        <div class="card-body">
                            <div class="feature-icon text-white bg-success rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                <i class="fas fa-file-medical fa-2x"></i>
                            </div>
                            <h3 class="card-title h5 fw-bold">Medical Records</h3>
                            <p class="card-text text-muted">Access your complete medical history, prescriptions, and lab results anytime.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Calendar Section -->
        <section id="hospital-calendar" class="py-5 fade-in" style="transition-delay: 0.5s;">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="fw-bold text-success">HOSPITAL SCHEDULE</h2>
                    <p class="text-muted">Check our operating days and scheduled holidays.</p>
                </div>
                <div class="calendar-container">
                    <div class="mb-4 d-flex align-items-center">
                        <h5 class="m-0 me-3 fw-bold"><i class="fas fa-info-circle text-success me-2"></i>Today's Status:</h5>
                        <c:choose>
                            <c:when test="${isTodayOpen}">
                                <span class="badge bg-success fs-6"><i class="fas fa-check-circle me-1"></i> Open: 8:00 AM - 5:00 PM</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger fs-6"><i class="fas fa-times-circle me-1"></i> Closed (${todayReason})</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div id="calendar"></div>
                    
                    <!-- Calendar Legend -->
                    <div class="mt-4 pt-3 border-top d-flex flex-wrap justify-content-center gap-4">
                        <div class="d-flex align-items-center">
                            <span style="width: 18px; height: 18px; background-color: #198754; display: inline-block; border-radius: 3px; margin-right: 8px;"></span>
                            <span class="small text-muted fw-bold">Clinic Open</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span style="width: 18px; height: 18px; background-color: #dc3545; display: inline-block; border-radius: 3px; margin-right: 8px;"></span>
                            <span class="small text-muted fw-bold">Holiday / Closed</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span style="width: 18px; height: 18px; background-color: #fff9c4; border: 1px solid #dee2e6; display: inline-block; border-radius: 3px; margin-right: 8px;"></span>
                            <span class="small text-muted fw-bold">Weekends / Closed</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span style="width: 18px; height: 18px; background-color: rgba(25, 135, 84, 0.1); border: 1px solid #198754; display: inline-block; border-radius: 3px; margin-right: 8px;"></span>
                            <span class="small text-muted fw-bold">Today</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer-light pt-5 pb-4">
        <div class="container text-center text-md-start">
            <div class="row text-center text-md-start">
                <div class="col-md-3 col-lg-3 col-xl-3 mx-auto mt-3">
                    <h5 class="text-uppercase mb-4 fw-bold text-success">Aurora Memorial Hospital</h5>
                    <p>Providing quality healthcare services to the community with dedication and compassion. Our digital platform aims to make healthcare more accessible for you.</p>
                </div>

                <div class="col-md-2 col-lg-2 col-xl-2 mx-auto mt-3">
                    <h5 class="text-uppercase mb-4 fw-bold text-success">Quick Links</h5>
                    <p><a href="<c:url value='/about.jsp'/>" class="text-decoration-none">About Us</a></p>
                    <p><a href="<c:url value='/services'/>" class="text-decoration-none">Services</a></p>
                    <p><a href="<c:url value='/departments'/>" class="text-decoration-none">Departments</a></p>
                </div>

                <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mt-3">
                    <h5 class="text-uppercase mb-4 fw-bold text-success">Contact</h5>
                    <p><i class="fas fa-home me-3"></i><a href="https://maps.app.goo.gl/iAtTgXaxgRrTuAdM8" target="_blank" class="text-decoration-none">Purok 6 ,Reserva Baler Aurora</a></p>
                    <p><i class="fas fa-envelope me-3"></i><a href="https://mail.google.com/mail/?view=cm&fs=1&to=Auroramemhos@gmail.com&su=Support Request - AMH OPD" target="_blank" rel="noopener noreferrer" class="text-decoration-none">Auroramemhos@gmail.com</a></p>
                    <p><i class="fas fa-phone me-3"></i><a href="tel:+639695702024" class="text-decoration-none" title="Click to call">09695702024</a></p>
                    <p><i class="fab fa-facebook me-3"></i><a href="https://www.facebook.com/profile.php?id=61587414046580" target="_blank" class="text-decoration-none">Visit our Facebook page</a></p>
                </div>
            </div>

            <hr class="mb-4">

            <div class="row align-items-center">
                <div class="col-md-6 col-lg-6">
                    <p class="text-center text-md-start">&copy; 2025 Out-Patient Department Management System. All rights reserved.</p>
                </div>
                <div class="col-md-6 col-lg-6">
                    <div class="text-center"> 
                        <ul class="list-unstyled list-inline">
                            <li class="list-inline-item">
                                <a href="<c:url value='/terms_and_conditions.jsp'/>" class="text-decoration-none me-3">Terms and Condition</a>
                            </li>
                            <li class="list-inline-item">
                                <a href="<c:url value='/privacy_safety.jsp'/>" class="text-decoration-none me-3">Privacy and Safety</a>
                            </li>
                            <li class="list-inline-item">
                                <a href="<c:url value='/About_Developer.jsp'/>" class="text-decoration-none">About Developer</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                        observer.unobserve(entry.target);
                    }
                });
            }, {
                threshold: 0.1
            });

            document.querySelectorAll('.fade-in').forEach(element => {
                observer.observe(element);
            });

            // Initialize Calendar
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth'
                },
                themeSystem: 'bootstrap5',
                height: 'auto',
                events: [
                    {
                        title: "${isTodayOpen ? 'Clinic Available: 8AM-5PM' : 'Clinic Closed: '.concat(todayReason)}",
                        start: new Date().toISOString().split('T')[0],
                        allDay: true,
                        backgroundColor: '${isTodayOpen ? "#198754" : "#dc3545"}',
                        borderColor: '${isTodayOpen ? "#198754" : "#dc3545"}'
                    },
                    <c:forEach var="entry" items="${holidays}">
                    {
                        title: "${entry.value}",
                        start: '${entry.key}',
                        allDay: true,
                        backgroundColor: '#dc3545',
                        borderColor: '#dc3545'
                    },
                    </c:forEach>
                ],
                eventDidMount: function(info) {
                    // Add a browser tooltip to show the full holiday name on hover
                    if (info.event.title) {
                        info.el.setAttribute('title', info.event.title);
                    }
                }
            });
            calendar.render();
        });
    </script>
</body>
</html>
