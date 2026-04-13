<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Departments - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .department-card { 
            border: none; 
            border-radius: 15px; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.08); 
            margin-bottom: 20px; 
            background-color: #fff;
        }
        .department-card-header { 
            font-weight: 600; 
            background-color: #f8f9fa; 
            border-bottom: 1px solid #e9ecef; 
            color: #28a745; /* Primary Green */
            padding: 1rem; 
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .department-card-body { 
            padding: 1.5rem; 
        }
        .department-card-body p {
            margin-bottom: 0.5rem;
            white-space: pre-line; /* This will respect the newlines from the database */
        }
    </style>
</head>
<body>

<!-- Public Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="<c:url value='/'/>">
            <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo" class="me-2" height="40">
            <span class="fw-bold">Aurora Memorial Hospital OPD</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
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
    </div>
</nav>

<div class="container mt-5">
    <h1 class="mb-4">Departments & Units</h1>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:forEach var="dept" items="${departmentList}">
        <div class="department-card">
            <div class="department-card-header">${dept.serviceName}</div>
            <div class="department-card-body">
                <p>${dept.notes}</p>
            </div>
        </div>
    </c:forEach>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
