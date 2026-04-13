<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (!"Patient".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Medical Records - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            background-color: #f4f7f6;
        }
        .main-content {
            margin-left: 260px;
            padding: 2rem;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        .card-header {
            font-weight: 600;
            background-color: #0d6efd;
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
    </style>
</head>
<body>

<c:import url="navbar-patient.jsp" />

<div class="main-content">
    <h1 class="h2 mb-4"><i class="fas fa-file-medical me-2"></i>My Medical Records</h1>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Appointment Date</th>
                            <th>Reason for Visit</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="record" items="${medicalRecords}">
                            <tr>
                                <td><fmt:formatDate value="${record.preferredDate}" pattern="MMMM dd, yyyy"/></td>
                                <td><c:out value="${record.reasonForVisit}"/></td>
                                <td><span class="badge bg-info text-dark"><c:out value="${record.status}"/></span></td>
                                <td>
                                    <%-- Prescription button removed --%>
                                     <c:if test="${record.status == 'Accepted'}">
                                        <a href="<c:url value='/print-appointment?id=${record.appointmentId}'/>" class="btn btn-sm btn-outline-primary" target="_blank"><i class="fas fa-print"></i> Print</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty medicalRecords}">
                            <tr><td colspan="4" class="text-center text-muted p-4">You have no medical records available.</td></tr>
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
