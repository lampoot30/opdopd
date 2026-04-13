<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${reportTitle} - ${reportPeriod}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Times New Roman', Times, serif;
            background-color: #fff;
        }
        .report-container {
            width: 210mm; /* A4 width */
            min-height: 297mm; /* A4 height */
            margin: auto;
            padding: 1.5cm;
            background-color: white;
        }
        .report-header {
            text-align: center;
            border-bottom: 2px solid #333;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        .report-header img {
            width: 80px;
            height: 80px;
            margin-bottom: 10px;
        }
        .report-title {
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }
        .report-period {
            font-size: 18px;
            color: #555;
        }
        .report-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12pt;
        }
        .report-table th, .report-table td {
            border: 1px solid #ccc;
            padding: 8px 12px;
            text-align: left;
        }
        .report-table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        .report-footer {
            text-align: center;
            margin-top: 40px;
            font-size: 10pt;
            color: #888;
        }

        @media print {
            body, .report-container {
                margin: 0;
                padding: 0;
                box-shadow: none;
            }
            .no-print {
                display: none;
            }
        }
    </style>
</head>
<body onload="window.print()">

<div class="report-container">
    <div class="report-header">
        <img src="<c:url value='/images/AMHLOGO.png'/>" alt="Hospital Logo">
        <h1 class="report-title">${reportTitle}</h1>
        <p class="report-period">${reportPeriod}</p>
    </div>

    <table class="report-table">
        <thead>
            <tr>
                <th>Patient ID</th>
                <th>Full Name</th>
                <th>Contact Number</th>
                <th>Date Registered</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="patient" items="${registeredPatients}">
                <tr>
                    <td>${patient.userId}</td>
                    <td>${patient.surname}, ${patient.givenName} ${patient.middleName}</td>
                    <td>${patient.contactNumber}</td>
                    <td><fmt:formatDate value="${patient.createdAt}" pattern="MMMM dd, yyyy, hh:mm a"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty registeredPatients}">
                <tr><td colspan="4" class="text-center">No new patient registrations for this period.</td></tr>
            </c:if>
        </tbody>
    </table>

    <div class="report-footer">
        Generated on <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy, hh:mm:ss a" />
    </div>
</div>

</body>
</html>
