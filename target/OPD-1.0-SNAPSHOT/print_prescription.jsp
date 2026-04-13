<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Period" %>
<%@ page import="java.time.ZoneId" %>
<%
    // Security check is handled by the servlet, but this is a fallback.
    if (!"Patient".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }

    com.mycompany.opd.models.Appointment appointment = (com.mycompany.opd.models.Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect(request.getContextPath() + "/medical-records?error=Appointment data not available.");
        return;
    }

    java.util.List prescriptions = (java.util.List) request.getAttribute("prescriptions");
    if (prescriptions == null) {
        prescriptions = new java.util.ArrayList();
        request.setAttribute("prescriptions", prescriptions);
    }


%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Print Prescription - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        @media print {
            .no-print {
                display: none;
            }
            body {
                margin: 0;
                padding: 20px;
                font-family: 'Arial', sans-serif;
            }
            .print-container {
                box-shadow: none;
                border: none;
            }
        }
        body {
            background: linear-gradient(135deg, #a5ffbaff 0%, #b6f66cff 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .print-container {
            max-width: 850px;
            margin: 2rem auto;
            background: white;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        .print-header {
            display: flex;
            align-items: center;
            border-bottom: 3px solid #007bff;
            padding-bottom: 1.5rem;
            margin-bottom: 2.5rem;
            background: linear-gradient(90deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-radius: 10px;
        }
        .print-header img {
            width: 90px;
            height: 90px;
            margin-right: 25px;
            border-radius: 50%;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .print-header .hospital-info h3 {
            margin: 0;
            color: #495057;
            font-weight: 700;
        }
        .print-header .hospital-info p {
            margin: 0.5rem 0 0 0;
            color: #6c757d;
        }
        .print-header .hospital-info h4 {
            margin: 1rem 0 0 0;
            color: #007bff;
            font-weight: 600;
        }
        .patient-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            border-left: 5px solid #28a745;
        }
        .patient-info .row > div {
            margin-bottom: 0.5rem;
        }
        .patient-info strong {
            color: #495057;
        }
        .rx-symbol {
            font-size: 4rem;
            font-weight: bold;
            line-height: 1;
            color: #dc3545;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        .prescription-item {
            border-left: 4px solid #007bff;
            padding-left: 20px;
            margin-left: 10px;
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .prescription-item h5 {
            color: #495057;
            margin-bottom: 1rem;
        }
        .prescription-item p {
            margin-bottom: 0.5rem;
            color: #6c757d;
        }
        .prescription-item strong {
            color: #007bff;
        }
        .doctor-signature {
            margin-top: 3rem;
            text-align: right;
            padding: 2rem;
            background: #f8f9fa;
            border-radius: 10px;
            border-top: 3px solid #6c757d;
        }
        .doctor-signature p {
            margin: 0;
            font-weight: 600;
            color: #495057;
        }
        .no-print .btn {
            border-radius: 25px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .no-print .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .no-print .btn-primary {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
        }
        .no-print .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #495057);
            border: none;
        }
    </style>
</head>
<body>

<div class="print-container">
    <div class="print-header">
        <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo">
        <div class="hospital-info">
            <h3 class="fw-bold">Aurora Memorial Hospital</h3>
            <p class="text-muted">Purok 6, Reserva, Baler, Aurora</p>
            <h4 class="mt-2">Medical Prescription</h4>
        </div>
    </div>

    <div class="patient-info">
        <div class="row">
            <div class="col-md-6">
                <strong>Patient:</strong> <c:out value="${appointment.givenName} ${appointment.lastName}"/><br>
                <strong>Date of Birth:</strong> <c:choose><c:when test="${appointment.patientDateOfBirth != null}"><fmt:formatDate value="${appointment.patientDateOfBirth}" pattern="MMMM dd, yyyy"/></c:when><c:otherwise>N/A</c:otherwise></c:choose>
            </div>
            <div class="col-md-6 text-md-end">
                <strong>Date:</strong> <fmt:formatDate value="${appointment.preferredDate}" pattern="MMMM dd, yyyy"/>
            </div>
        </div>
    </div>
    
    <c:forEach var="p" items="${prescriptions}">
        <div class="d-flex align-items-start mb-4">
            <div class="rx-symbol me-3">Rx</div>
            <div class="prescription-item flex-grow-1">
                <h5 class="fw-bold mb-2"><c:out value="${p.medicationName}"/></h5>
                <p class="mb-1"><strong>Dosage:</strong> <c:out value="${p.dosage}"/></p>
                <p class="mb-1"><strong>Frequency:</strong> <c:out value="${p.frequency}"/></p>
                <p class="mb-1"><strong>Duration:</strong> <c:out value="${p.duration}"/></p>
                <c:if test="${not empty p.notes}">
                    <p class="mb-0 text-muted"><em><strong>Notes:</strong> <c:out value="${p.notes}"/></em></p>
                </c:if>
            </div>
        </div>
        <hr/>
    </c:forEach>

    <div class="doctor-signature">
        <p class="mb-0">_________________________</p>
        <p><strong><c:out value="${doctorName}"/></strong></p>
    </div>
</div>

<div class="text-center my-4 no-print">
    <button onclick="window.print()" class="btn btn-primary"><i class="fas fa-print me-2"></i>Print Prescription</button>
    <a href="<c:url value='/medical-records'/>" class="btn btn-secondary">Back to Medical Records</a>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/js/all.min.js"></script>
</body>
</html>
