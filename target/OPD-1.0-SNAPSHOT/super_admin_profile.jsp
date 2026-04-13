<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Security check
    if (!"Super Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>My Profile - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .profile-header {
            padding: 2rem;
            background-color: #fff;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        .profile-header img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        .card-header {
            font-weight: 600;
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            color: #dc3545; /* Super Admin primary color */
        }
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        .detail-item {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
        }
        .detail-item .label {
            font-weight: 600;
            color: #6c757d;
            font-size: 0.9rem;
            display: block;
            margin-bottom: 0.25rem;
        }
        .detail-item .value {
            font-size: 1.1rem;
            color: #343a40;
        }
    </style>
</head>
<body>

<c:import url="super_admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Profile Header -->
        <div class="profile-header d-flex align-items-center">
            <div class="me-4">
                <img src="<c:url value='${not empty adminProfile.profilePicturePath ? adminProfile.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Picture">
            </div>
            <div>
                <h2 class="mb-0">${adminProfile.givenName} ${adminProfile.surname}</h2>
                <p class="text-muted mb-1">User ID: ${user.userId}</p>
                <span class="badge bg-danger">${userType}</span>
            </div>
            <div class="ms-auto">
                <a href="<c:url value='/edit-super-admin-profile'/>" class="btn btn-danger"><i class="fas fa-edit me-2"></i>Edit Profile</a>
            </div>
        </div>

        <!-- Profile Details -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Your Information</h5>
            </div>
            <div class="card-body p-4">
                <h5 class="mb-3">Personal Details</h5>
                <div class="details-grid">
                    <div class="detail-item"><span class="label">Full Name</span><span class="value"><c:out value="${adminProfile.givenName} ${adminProfile.middleName} ${adminProfile.surname}"/></span></div>
                    <div class="detail-item"><span class="label">Date of Birth</span><span class="value"><fmt:formatDate value="${adminProfile.dateOfBirth}" pattern="MMMM dd, yyyy"/></span></div>
                    <div class="detail-item"><span class="label">Gender</span><span class="value"><c:out value="${adminProfile.gender}"/></span></div>
                </div>

                <hr class="my-4">

                <h5 class="mb-3">Address Details</h5>
                <div class="details-grid">
                    <div class="detail-item" style="grid-column: 1 / -1;"><span class="label">Permanent Address</span><span class="value"><c:out value="${adminProfile.address}"/></span></div>
                    <div class="detail-item" style="grid-column: 1 / -1;"><span class="label">Current Address</span><span class="value"><c:out value="${currentAddress}"/></span></div>
                    <div class="detail-item"><span class="label">City/Town</span><span class="value"><c:out value="${city}"/></span></div>
                    <div class="detail-item"><span class="label">Postal/ZIP Code</span><span class="value"><c:out value="${postalCode}"/></span></div>
                </div>

                <hr class="my-4">

                <h5 class="mb-3">Account Details</h5>
                <div class="details-grid">
                    <div class="detail-item"><span class="label">Username</span><span class="value"><c:out value="${user.username}"/></span></div>
                    <div class="detail-item"><span class="label">Contact Number</span><span class="value"><c:out value="${user.contactNumber}"/></span></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>