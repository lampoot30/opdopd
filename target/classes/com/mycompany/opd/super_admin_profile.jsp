<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (!"Super Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .main-content {
            padding: 2rem;
        }
        .profile-card {
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
            border: none;
        }
        .profile-header {
            background-color: #dc3545;
            color: white;
            padding: 2rem;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .profile-picture {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            object-fit: cover;
            margin-top: -60px;
            background-color: white;
        }
        .profile-body {
            padding: 2rem;
        }
        .info-item {
            margin-bottom: 1rem;
        }
        .info-item .label {
            font-weight: 600;
            color: #6c757d;
        }
        .info-item .value {
            color: #212529;
        }
    </style>
</head>
<body>
    <%-- Assuming a Super Admin navbar exists --%>
    <%-- <c:import url="super_admin_navbar.jsp" /> --%>

    <div class="main-content container">
        <c:if test="${not empty param.success}">
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle me-2"></i><c:out value="${param.success}"/>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${param.error}"/>
            </div>
        </c:if>

        <div class="card profile-card">
            <div class="profile-header text-center">
                <h2 class="mb-0">Super Admin Profile</h2>
            </div>
            <div class="card-body profile-body">
                <div class="text-center">
                    <img src="<c:url value='/${adminProfile.profilePicturePath}'/>" alt="Profile Picture" class="profile-picture mb-3">
                    <h4 class="card-title">${adminProfile.givenName} ${adminProfile.surname}</h4>
                    <p class="text-muted">@${user.username}</p>
                </div>

                <hr class="my-4">

                <div class="row">
                    <div class="col-md-6 info-item">
                        <div class="label">Full Name</div>
                        <div class="value">${adminProfile.givenName} ${adminProfile.middleName} ${adminProfile.surname}</div>
                    </div>
                    <div class="col-md-6 info-item">
                        <div class="label">Contact Number</div>
                        <div class="value">${user.contactNumber}</div>
                    </div>
                    <div class="col-md-6 info-item">
                        <div class="label">Date of Birth</div>
                        <div class="value"><fmt:formatDate value="${adminProfile.dateOfBirth}" pattern="MMMM dd, yyyy"/></div>
                    </div>
                    <div class="col-md-6 info-item">
                        <div class="label">Gender</div>
                        <div class="value">${adminProfile.gender}</div>
                    </div>
                    <div class="col-12 info-item">
                        <div class="label">Address</div>
                        <div class="value">${adminProfile.address}</div>
                    </div>
                </div>

                <div class="text-end mt-4">
                    <a href="<c:url value='/edit-super-admin-profile'/>" class="btn btn-danger"><i class="fas fa-user-edit me-2"></i>Edit My Profile</a>
                </div>
            </div>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>