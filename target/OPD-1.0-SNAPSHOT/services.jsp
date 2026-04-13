<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Our Services - AMH Hospital</title>
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
        .service-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
            margin-bottom: 1.5rem;
        }
        .service-card .card-header {
            font-weight: 600;
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .header-weekly { background-color: #28a745; }
        .header-monthly { background-color: #17a2b8; }
        .header-daily { background-color: #dc3545; }
        .service-item {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #eee;
        }
        .service-item:last-child {
            border-bottom: none;
        }
        .service-name {
            font-weight: 600;
            color: #333;
        }
        .service-schedule {
            color: #555;
        }
        .service-notes {
            font-size: 0.9rem;
            color: #6c757d;
            white-space: pre-wrap; /* To respect newlines in notes */
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
            <h1 class="display-5 fw-bold text-success">Our Services & Schedules</h1>
            <p class="lead">Find the schedule for our Out-Patient Department services.</p>
        </div>
    </header>

    <main class="container">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Weekly Services -->
        <div class="card service-card">
            <div class="card-header header-weekly"><i class="fas fa-calendar-week me-2"></i>Weekly Services</div>
            <div class="card-body p-0">
                <c:forEach var="service" items="${weeklyServices}">
                    <div class="service-item">
                        <div class="d-flex justify-content-between">
                            <span class="service-name">${service.serviceName}</span>
                            <span class="service-schedule">${service.scheduleDetails}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Monthly Services -->
        <div class="card service-card">
            <div class="card-header header-monthly"><i class="fas fa-calendar-day me-2"></i>Monthly Services</div>
            <div class="card-body p-0">
                <c:forEach var="service" items="${monthlyServices}">
                    <div class="service-item">
                        <div class="d-flex justify-content-between">
                            <span class="service-name">${service.serviceName}</span>
                            <span class="service-schedule">${service.scheduleDetails}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Daily Services -->
        <div class="card service-card">
            <div class="card-header header-daily"><i class="fas fa-first-aid me-2"></i>Daily Services</div>
            <div class="card-body p-0">
                <c:forEach var="service" items="${dailyServices}">
                    <div class="service-item">
                        <div class="d-flex justify-content-between">
                            <span class="service-name">${service.serviceName}</span>
                            <span class="service-schedule">${service.scheduleDetails}</span>
                        </div>
                        <c:if test="${not empty service.notes}">
                            <div class="service-notes mt-2">${service.notes}</div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
