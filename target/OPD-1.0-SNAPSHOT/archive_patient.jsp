<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check is handled by SecurityFilter.
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Archive Patient Accounts - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f8f9fa; }
        .main-content { padding: 2rem; }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card-header { background-color: #0d6efd; color: white; font-weight: 600; border-top-left-radius: 15px; border-top-right-radius: 15px; }
    </style>
</head>
<body>
    <c:import url="admin_navbar.jsp" />

    <div class="main-content container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2"><i class="fas fa-user-slash me-2"></i>Archive Patient Accounts</h1>
            <a href="<c:url value='/analytics-overview'/>" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${param.error}"/>
            </div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success" role="alert">
                <c:out value="${param.success}"/>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                Select a Patient to Archive
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Name</th>
                                <th>Contact Number</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${patientList}">
                                <tr>
                                    <td><c:out value="${patient.givenName} ${patient.surname}"/></td>
                                    <td><c:out value="${patient.contactNumber}"/></td>
                                    <td class="text-end">
                                        <form action="archive-patient" method="post" onsubmit="return confirm('Are you sure you want to archive this patient?');" style="display: inline;">
                                            <input type="hidden" name="userId" value="${patient.userId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fas fa-archive me-1"></i> Archive
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty patientList}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted p-4">No active patient accounts found.</td>
                                </tr>
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
