<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check
    String userType = (String) session.getAttribute("userType");
    if (!"Admin".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Daily Reports - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin-left: 250px; padding: 30px; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08); }
        .card-header { font-weight: 600; background-color: #0d6efd; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; }
        .table-hover tbody tr:hover { background-color: #f8f9fa; }
    </style>
</head>
<body>

<c:import url="admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4"><i class="fas fa-file-pdf me-2"></i>Daily Appointment Reports</h1>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Generated Reports</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Report Date</th>
                                <th>Generated At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${reportList}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${report.reportDate}" pattern="MMMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${report.generatedAt}" pattern="hh:mm a" />
                                    </td>
                                    <td>
                                        <a href="<c:url value='/${report.filePath}'/>" class="btn btn-sm btn-outline-primary" target="_blank" title="Download Report">
                                            <i class="fas fa-download me-1"></i> Download PDF
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty reportList}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted p-4">
                                        No daily reports have been generated yet. The first report will be created at the end of the day.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
