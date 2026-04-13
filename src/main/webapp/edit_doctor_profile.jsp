<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (!"Doctor".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit My Profile - Doctor Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin-left: 260px; padding: 2rem; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: #007bff; }
        .form-label { font-weight: 500; }
    </style>
</head>
<body>

<c:import url="navbar-doctor.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Edit My Profile</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>${param.error}</div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Update Your Information</h5>
            </div>
            <div class="card-body p-4">
                <form action="update-doctor-profile" method="post" enctype="multipart/form-data">
                    <div class="row mb-4">
                        <div class="col-md-3 text-center">
                            <img id="imagePreview" src="<c:url value='${not empty doctor.profilePicturePath ? doctor.profilePicturePath : "uploads/profile_pictures/default_avatar.png"}'/>" alt="Profile Preview" class="img-thumbnail rounded-circle" style="width: 150px; height: 150px; object-fit: cover;">
                            <label for="profilePicture" class="btn btn-sm btn-outline-primary mt-3">
                                <i class="fas fa-upload me-1"></i> Change Picture
                            </label>
                            <input type="file" class="form-control d-none" id="profilePicture" name="profile_picture" accept="image/*">
                        </div>
                        <div class="col-md-9">
                            <h5 class="mb-3">Personal Information</h5>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="surname" class="form-label">Surname</label>
                                    <input type="text" class="form-control" id="surname" name="surname" value="<c:out value='${doctor.surname}'/>" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="givenName" class="form-label">Given Name</label>
                                    <input type="text" class="form-control" id="givenName" name="givenName" value="<c:out value='${doctor.givenName}'/>" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="middleName" class="form-label">Middle Name</label>
                                    <input type="text" class="form-control" id="middleName" name="middleName" value="<c:out value='${doctor.middleName}'/>">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="${doctor.dateOfBirth}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Male" ${doctor.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${doctor.gender == 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${doctor.gender == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="permanent_address" rows="2" required><c:out value='${doctor.address}'/></textarea>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="mb-3">Professional & Account Details</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="specialization" class="form-label">Specialization</label>
                            <input type="text" class="form-control" id="specialization" name="specialization" value="<c:out value='${doctor.specialization}'/>" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="licenseNumber" class="form-label">License Number</label>
                            <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" value="<c:out value='${doctor.licenseNumber}'/>" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="licenseExpiryDate" class="form-label">License Expiry Date</label>
                            <input type="date" class="form-control" id="licenseExpiryDate" name="licenseExpiryDate" value="${doctor.licenseExpiryDate}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="contactNumber" class="form-label">Contact Number</label>
                            <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="<c:out value='${user.contactNumber}'/>" required>
                        </div>
                    </div>

                    <div class="text-end mt-4">
                        <a href="<c:url value='/doctor-profile'/>" class="btn btn-secondary me-2">Cancel</a>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('profilePicture').addEventListener('change', function(event) {
        const [file] = event.target.files;
        if (file) {
            document.getElementById('imagePreview').src = URL.createObjectURL(file);
        }
    });
</script>
</body>
</html>
