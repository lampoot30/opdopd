<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login first");
        return; // Stop further processing of the page
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Patient Dashboard - AMH Hospital</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
            min-height: 100vh;
            margin: 0;
        }
        .dashboard-header {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .btn-primary {
            background-color: var(--primary-green);
            border-color: var(--primary-green);
        }

        .btn-primary:hover {
            background-color: var(--primary-green-dark);
            border-color: var(--primary-green-dark);
        }

        @media print {
            .no-print {
                display: none !important;
            }
            .print-only {
                display: block !important;
            }
            body {
                font-size: 12px;
            }
            .print-header {
                text-align: center;
                border-bottom: 2px solid #000;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            .print-content {
                margin: 20px 0;
            }
            .receipt-box {
                border: 1px solid #000;
                padding: 15px;
                margin: 10px 0;
            }
            .sidebar, .main-content {
                margin-left: 0;
            }
        }
        .print-only {
            display: none;
        }
    </style>
</head>
<body>

<c:import url="navbar-patient.jsp" />

<div class="main-content">
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-1">Welcome back, ${sessionScope.displayUsername}!</h1>
                <p class="text-muted mb-0">Here's an overview of your appointments and activities</p>
            </div>
        </div>
    </div>

    <!-- Print Header (hidden in normal view) -->
    <div class="print-only print-header">
        <h2>AMH Hospital - Patient Dashboard</h2>
        <p>Patient: ${sessionScope.displayUsername}</p>
        <p>Date: <%= new java.util.Date() %></p>
    </div>

    <div class="card mb-4" id="appointments-section">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0"><i class="fas fa-calendar-check me-2"></i>Your Todays's Appointment</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>Doctor</th>
                            <th>Room</th>
                            <th>Date</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appt" items="${appointments}">
                            <tr>
                                <td>${appt.assignedDoctorName != null ? appt.assignedDoctorName : 'Not Assigned'}</td>
                                <td>${appt.assignedRoomName != null ? appt.assignedRoomName : 'Not Assigned'}</td>
                                <td>${appt.preferredDate}</td>
                                <td>${appt.reasonForVisit}</td>
                                <td>
                                    <span class="badge bg-${appt.status == 'Accepted' || appt.status == 'Completed' ? 'success' : (appt.status == 'Pending' ? 'warning' : 'danger')}">
                                        ${appt.status}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" onclick="printAppointment(${appt.appointmentId}, '${appt.assignedDoctorName}', '${appt.assignedRoomName}', '${appt.preferredDate}', '${appt.reasonForVisit}', '${appt.status}')">
                                        <i class="fas fa-print"></i> Print
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty appointments}">
                            <tr><td colspan="6" class="text-center text-muted p-3">No appointments found.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<script type="text/javascript">
    function printAppointment(appointmentId, doctorName, roomName, date, reason, status) {
        // Create a new window for printing
        var printWindow = window.open('', '_blank', 'width=600,height=400');

        // Get current date for print date
        var printDate = new Date().toLocaleDateString();

        // HTML content for the printable receipt
        var htmlContent = '<!DOCTYPE html>' +
            '<html lang="en">' +
            '<head>' +
                '<meta charset="UTF-8">' +
                '<title>Appointment Receipt</title>' +
                '<style>' +
                    'body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }' +
                    '.header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 20px; }' +
                    '.receipt-content { margin: 20px 0; }' +
                    '.receipt-box { border: 1px solid #000; padding: 15px; margin: 10px 0; }' +
                    '.footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }' +
                '</style>' +
            '</head>' +
            '<body>' +
                '<div class="header">' +
                    '<h2>AMH Hospital</h2>' +
                    '<p>Appointment Receipt</p>' +
                '</div>' +
                '<div class="receipt-content">' +
                    '<div class="receipt-box">' +
                        '<p><strong>Appointment ID:</strong> ' + appointmentId + '</p>' +
                        '<p><strong>Doctor:</strong> ' + (doctorName || 'Not Assigned') + '</p>' +
                        '<p><strong>Room:</strong> ' + (roomName || 'Not Assigned') + '</p>' +
                        '<p><strong>Date:</strong> ' + date + '</p>' +
                        '<p><strong>Reason for Visit:</strong> ' + reason + '</p>' +
                        '<p><strong>Status:</strong> ' + status + '</p>' +
                        '<p><strong>Patient:</strong> ' + '${sessionScope.displayUsername}' + '</p>' +
                        '<p><strong>Print Date:</strong> ' + printDate + '</p>' +
                    '</div>' +
                '</div>' +
                '<div class="footer">' +
                    '<p>Thank you for choosing AMH Hospital. Please bring this receipt to your appointment.</p>' +
                '</div>' +
            '</body>' +
            '</html>';

        // Write the content to the new window
        printWindow.document.write(htmlContent);
        printWindow.document.close();

        // Wait for content to load, then print
        printWindow.onload = function() {
            printWindow.print();
            printWindow.close();
        };
    }
</script>
</body>
</html>
