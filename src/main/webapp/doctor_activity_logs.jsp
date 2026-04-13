<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check: Only allow Doctor users to access this page.
    if (!"Doctor".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>My Activity - Doctor Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .main-content {
            margin-left: 260px;
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
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
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
        <h1 class="h2 mb-1"><i class="fas fa-history me-2"></i>My Activity Log</h1>
        <p class="text-muted mb-0">A record of your recent actions within the system.</p>
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
                            <th>Action</th>
                            <th>Timestamp</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${activityLogs}">
                            <tr>
                                <td><c:out value="${log.action}"/></td>
                                <td><fmt:formatDate value="${log.timestamp}" pattern="MMM dd, yyyy, hh:mm:ss a"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty activityLogs}">
                            <tr><td colspan="2" class="text-center text-muted p-4">No activity has been recorded for your account.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination Controls -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="p-3">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/doctor-activity-logs?page=${currentPage - 1}'/>">Previous</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="<c:url value='/doctor-activity-logs?page=${i}'/>">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/doctor-activity-logs?page=${currentPage + 1}'/>">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
