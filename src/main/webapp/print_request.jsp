<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check: Only allow Staff to access this page.
    if (!"Staff".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Print Appointment Request #${appointment.appointmentId}</title>
    <style>
        @page {
            size: A4;
            margin: 2cm;
        }
        body {
            font-family: 'Times New Roman', Times, serif;
            font-size: 12pt;
            line-height: 1.5;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .header img {
            width: 80px;
            height: 80px;
        }
        .header h1 {
            margin: 0;
            font-size: 18pt;
        }
        .header h2 {
            margin: 5px 0;
            font-size: 14pt;
            font-weight: normal;
        }
        .content-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .content-table td {
            padding: 8px;
            border: 1px solid #ccc;
        }
        .content-table .label {
            font-weight: bold;
            width: 30%;
        }
        .reason-box {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            min-height: 100px;
        }
        .footer {
            text-align: center;
            margin-top: 50px;
            font-size: 10pt;
            color: #555;
        }
    </style>
</head>
<body onload="window.print()">

    <div class="header">
        <img src="<c:url value='/images/AMHLOGO.png'/>" alt="AMH Logo">
        <h1>Aurora Memorial Hospital</h1>
        <h2>Out-Patient Department</h2>
        <h3>Appointment Request Form</h3>
    </div>

    <table class="content-table">
        <tr>
            <td class="label">Appointment ID:</td>
            <td>#<c:out value="${appointment.appointmentId}"/></td>
        </tr>
        <tr>
            <td class="label">Patient Name:</td>
            <td><c:out value="${appointment.lastName}, ${appointment.givenName} ${appointment.middleName}"/></td>
        </tr>
        <tr>
            <td class="label">Date of Birth:</td>
            <td><fmt:formatDate value="${printBirthday}" pattern="MMMM dd, yyyy"/></td>
        </tr>
        <tr>
            <td class="label">Contact Number:</td>
            <td><c:out value="${printContactNumber}"/></td>
        </tr>
        <tr>
            <td class="label">Preferred Date:</td>
            <td><fmt:formatDate value="${appointment.preferredDate}" pattern="EEEE, MMMM dd, yyyy"/></td>
        </tr>
    </table>

    <div class="reason-box">
        <strong>Reason for Visit:</strong>
        <p><c:out value="${appointment.reasonForVisit}"/></p>
    </div>

    <div class="footer">
        This is a system-generated document.
    </div>

</body>
</html>
