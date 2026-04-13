<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .service-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
            margin-bottom: 20px;
            background-color: #fff;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .service-card-header {
            font-weight: 600;
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            color: #28a745; /* Primary Green */
            padding: 1rem 1.5rem;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .service-card-body {
            padding: 1.5rem;
        }
        .schedule-details {
            font-weight: 500;
            color: #343a40;
        }
        .schedule-type {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body>

<!-- Public Navigation Bar -->
<c:import url="navbar-public.jsp" />

<div class="container my-5">
    <h1 class="text-center mb-5">Our Services</h1>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row">
        <c:forEach var="service" items="${services}">
            <div class="col-md-6 col-lg-4">
                <div class="service-card">
                    <div class="service-card-header">${service.serviceName}</div>
                    <div class="service-card-body">
                        <p class="schedule-details">${service.scheduleDetails}</p>
                        <p class="schedule-type text-uppercase">${service.scheduleType}</p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
