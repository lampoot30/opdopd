<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Print Appointment Slip</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .print-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: .25rem;
        }
        .print-header {
            text-align: center;
            margin-bottom: 2rem;
            border-bottom: 2px solid #000;
            padding-bottom: 1rem;
        }
        .print-header h2 {
            margin-bottom: 0;
        }
        .print-header p {
            margin-bottom: 0;
            font-size: 0.9rem;
        }
        .details-section {
            margin-bottom: 1.5rem;
        }
        .details-section h5 {
            border-bottom: 1px solid #ccc;
            padding-bottom: 0.5rem;
            margin-bottom: 1rem;
        }
        .detail-item {
            display: flex;
            margin-bottom: 0.5rem;
        }
        .detail-item strong {
            width: 180px;
            flex-shrink: 0;
        }
        .print-footer {
            text-align: center;
            margin-top: 2rem;
            font-style: italic;
            font-size: 0.9rem;
        }
        @media print {
            @page {
                size: A4;
                margin: 1in;
            }
            .no-print {
                display: none;
            }
            body {
                background-color: #fff;
            }
            .print-container {
                border: none;
                margin: 0;
                max-width: 100%;
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>

    <div class="print-container">
        <div class="print-header">
            <h2>Appointment Confirmation Slip</h2>
            <p>Out-Patient Department</p>
        </div>

        <div class="details-section">
            <h5>Appointment Details</h5>
            <div class="detail-item"><strong>Appointment ID:</strong> <span>${appointment.appointmentId}</span></div>
            <div class="detail-item"><strong>Appointment Date:</strong> <span><fmt:formatDate value="${appointment.preferredDate}" pattern="MMMM dd, yyyy"/></span></div>
            <div class="detail-item"><strong>Reason for Visit:</strong> <span><c:out value="${appointment.reasonForVisit}"/></span></div>
        </div>

        <div class="details-section">
            <h5>Patient Information</h5>
            <div class="detail-item"><strong>Patient Name:</strong> <span><c:out value="${appointment.givenName} ${appointment.middleName} ${appointment.lastName}"/></span></div>
        </div>

        <div class="details-section">
            <h5>Assigned Personnel & Location</h5>
            <div class="detail-item"><strong>Assigned Doctor:</strong> <span>Dr. <c:out value="${doctor.givenName} ${doctor.surname}"/></span></div>
            <div class="detail-item"><strong>Specialization:</strong> <span><c:out value="${doctor.specialization}"/></span></div>
            <div class="detail-item"><strong>Assigned Room:</strong> <span><c:out value="${room.roomNumber}"/> - <c:out value="${room.roomName}"/></span></div>
        </div>

        <div class="print-footer">
            <p>Please bring this slip on the day of your appointment. Thank you.</p>
        </div>

        <div class="text-center mt-4 no-print">
            <button onclick="window.print()" class="btn btn-primary">Print Slip</button>
            <a href="${pageContext.request.contextPath}/medical-records" class="btn btn-secondary">Back to Medical Records</a>
        </div>
    </div>

</body>
</html>
