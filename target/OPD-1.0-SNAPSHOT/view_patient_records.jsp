<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.Period"%>
<%@page import="java.time.ZoneId"%>
<%@page import="com.mycompany.opd.models.Patient"%>

<%
    // Security check at the top of the JSP
    if (session == null || !"Doctor".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }

    // Age calculation is better done here than mixing with presentation
    Patient patientProfile = (Patient) request.getAttribute("patientProfile");
    int age = 0;
    if (patientProfile != null && patientProfile.getDateOfBirth() != null) {
        // Convert java.sql.Date to java.util.Date, then to LocalDate
        java.util.Date utilDate = new java.util.Date(patientProfile.getDateOfBirth().getTime());
        LocalDate birthDate = utilDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        age = Period.between(birthDate, LocalDate.now()).getYears();
    }
    pageContext.setAttribute("age", age);
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Patient Medical Records - <c:out value="${patientProfile.givenName} ${patientProfile.surname}"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        body {
            background-color: #f4f7f6;
        }
        .main-content {
            margin-left: 250px; /* This should match the sidebar width from the navbar */
            padding: 2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar-doctor.jsp" />

    <div class="main-content">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0"><i class="bi bi-person-fill"></i> Patient Information</h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty patientProfile}">
                    <div class="row">
                        <div class="col-md-6"><strong>Name:</strong> <c:out value="${patientProfile.givenName} ${patientProfile.surname}"/></div>
                        <div class="col-md-6"><strong>Age:</strong> <c:out value="${age}"/> years</div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-6"><strong>Gender:</strong> <c:out value="${patientProfile.gender}"/></div>
                        <div class="col-md-6"><strong>Date of Birth:</strong> <fmt:formatDate value="${patientProfile.dateOfBirth}" pattern="MMMM dd, yyyy"/></div>
                    </div>
                </c:if>
                <c:if test="${empty patientProfile}">
                    <p class="text-danger">Could not load patient details.</p>
                </c:if>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0"><i class="bi bi-journal-medical"></i> Medical History</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Appointment Date</th>
                                <th>Reason for Visit</th>
                                <th>Assigned Room</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="record" items="${medicalRecords}">
                                <tr>
                                    <td><fmt:formatDate value="${record.preferredDate}" pattern="MMMM dd, yyyy"/></td>
                                    <td><c:out value="${record.reasonForVisit}"/></td>
                                    <td><c:out value="${record.roomName != null ? record.roomName : 'N/A'}"/></td>
                                    <td><span class="badge bg-info text-dark"><c:out value="${record.status}"/></span></td>
                                    <td>
                                        <a href="<c:url value='/view-appointment-doctor?id=${record.appointmentId}'/>" class="btn btn-primary btn-sm">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty medicalRecords}">
                                <tr><td colspan="5" class="text-center text-muted p-3">No medical records found for this patient.</td></tr>
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
