<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Print Appointment Details - Aurora Memorial Hospital OPD</title>
    <!-- Google Fonts (Poppins) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/custom-style.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6; /* Match theme background */
        }
        .print-container {
            max-width: 800px;
            margin: 2rem auto;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08); /* Match card shadow */
            padding: 2rem;
        }
        .header {
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 1rem;
            margin-bottom: 2rem;
        }
        .header img {
            height: 60px; /* Slightly larger logo */
            margin-right: 1rem;
        }
        .header h1 {
            color: #333;
            font-weight: 600;
            margin: 0;
            font-size: 1.75rem;
        }
        .list-group-item {
            border-left: 0;
            border-right: 0;
            padding: 0.85rem 0; /* Adjust padding */
        }
        .list-group-item strong {
            min-width: 180px;
            display: inline-block;
            color: #555;
            font-weight: 600;
        }
        .no-print {
            text-align: center;
            margin-top: 2rem;
        }
        @media print {
            body {
                background: white !important;
                margin: 0;
            }
            .print-container {
                box-shadow: none;
                border: none;
                margin: 0;
                padding: 0.5rem;
            }
            .no-print {
                display: none !important;
            }
            .header {
                border-bottom: 2px solid #000;
            }
        }
    </style>
</head>
<body onload="window.print();">

    <c:if test="${empty appointment}">
        <%-- Redirect if appointment object is not found --%>
        <c:redirect url="/staff-dashboard?error=Could not load appointment details."/>
    </c:if>

    <div class="print-container">
        <div class="header">
            <img src="<c:url value='/images/AMHLOGO.png'/>" alt="Hospital Logo">
            <div>
                <h1 class="text-success fw-bold">Aurora Memorial Hospital</h1>
                <p class="lead text-muted mb-0">Out-Patient Department Record</p>
            </div>
        </div>

        <ul class="list-group list-group-flush fs-6">
            <li class="list-group-item py-3"><strong>Appointment ID:</strong> #${appointment.appointmentId}</li>
            <li class="list-group-item py-3"><strong>Patient Name:</strong> ${appointment.givenName} ${appointment.middleName} ${appointment.lastName}</li>
            <li class="list-group-item py-3"><strong>Patient Type:</strong>
                <span class="badge fs-6 ${appointment.patientType == 'New' ? 'bg-primary' : 'bg-secondary'}">${appointment.patientType}</span>
            </li>
            <li class="list-group-item py-3"><strong>Clinic/Service:</strong> ${appointment.servicesClinic}</li>
            <li class="list-group-item py-3"><strong>Preferred Date:</strong>
                <fmt:formatDate value="${appointment.preferredDate}" pattern="MMMM dd, yyyy"/>
            </li>
            <li class="list-group-item py-3"><strong>Reason for Visit:</strong> ${appointment.reasonForVisit}</li>
            <li class="list-group-item py-3"><strong>Status:</strong>
                 <span class="badge fs-6
                    ${appointment.status == 'Accepted' ? 'bg-success' : ''}
                    ${appointment.status == 'Completed' ? 'bg-primary' : ''}
                    ${appointment.status == 'Pending' ? 'bg-warning text-dark' : ''}
                    ${appointment.status == 'Rejected' ? 'bg-danger' : ''}">
                    ${appointment.status}
                </span>
            </li>
            <li class="list-group-item py-3"><strong>Assigned Doctor:</strong> Dr. ${not empty appointment.assignedDoctorName ? appointment.assignedDoctorName : "Not Assigned"}</li>
            <li class="list-group-item py-3"><strong>Assigned Room:</strong> ${not empty appointment.assignedRoomName ? appointment.assignedRoomName : "Not Assigned"}</li>
        </ul>
    </div>

    <div class="no-print" style="text-align:center; margin-top:20px;">
        <p>This page will automatically attempt to print. If it does not, please use your browser's print function (Ctrl+P or Cmd+P).</p>
        <button onclick="window.close();" class="btn btn-secondary"><i class="fas fa-times me-2"></i>Close Tab</button>
    </div>

</body>
</html>
