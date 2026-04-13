<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check: Only allow Doctor users to access this page.
    if (!"Doctor".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
    // Set current date for display
    pageContext.setAttribute("today", new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Doctor Dashboard - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .main-content {
            margin-left: 250px; /* This should match the sidebar's width */
            padding: 2rem;
        }
        .dashboard-header {
            margin-bottom: 2rem;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        .card-header {
            font-weight: 600;
            background-color: #28a745;
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
            cursor: pointer;
        }
        .table th {
            font-weight: 600;
        }
    </style>
</head>
<body>

<c:import url="navbar-doctor.jsp" />

<div class="main-content">
    <div class="dashboard-header">
        <h1 class="h2 mb-1"><i class="fas fa-calendar-day me-2"></i>Today's Appointments</h1>
        <p class="text-muted mb-0">
            <fmt:formatDate value="${today}" pattern="EEEE, MMMM dd, yyyy" />
        </p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Patient Name</th>
                            <th>Reason for Visit</th>
                            <th>Assigned Room</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appt" items="${todayAppointments}">
                            <tr onclick="window.location='<c:url value="/view-appointment-doctor?id=${appt.appointmentId}"/>';" style="cursor: pointer;">
                                <td><c:out value="${appt.givenName} ${appt.lastName}"/></td>
                                <td><c:out value="${appt.reasonForVisit}"/></td>
                                <td><i class="fas fa-door-open me-2 text-muted"></i><c:out value="${appt.roomName}"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty todayAppointments}">
                            <tr><td colspan="3" class="text-center text-muted p-4">You have no appointments scheduled for today.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Future Appointments -->
    <div class="card mt-4">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Future Appointments</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Date</th>
                            <th>Patient Name</th>
                            <th>Reason for Visit</th>
                            <th>Assigned Room</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appt" items="${futureAppointments}">
                            <tr onclick="window.location='<c:url value="/view-appointment-doctor?id=${appt.appointmentId}"/>';" style="cursor: pointer;">
                                <td><fmt:formatDate value="${appt.preferredDate}" pattern="MMMM dd, yyyy"/></td>
                                <td><c:out value="${appt.givenName} ${appt.lastName}"/></td>
                                <td><c:out value="${appt.reasonForVisit}"/></td>
                                <td><i class="fas fa-door-open me-2 text-muted"></i><c:out value="${appt.roomName}"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty futureAppointments}">
                            <tr><td colspan="4" class="text-center text-muted p-4">You have no future appointments scheduled.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
