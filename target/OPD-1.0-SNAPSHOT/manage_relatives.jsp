<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Relatives - AMH Patient Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        :root {
            --primary-green: #28a745;
            --primary-green-dark: #218838;
        }
    </style>
</head>
<body>

<c:import url="navbar-patient.jsp" />

<div class="main-content">
    <div class="container-fluid"> 
        <h1 class="h2 mb-4"><i class="fas fa-users-cog me-2"></i>Manage Relatives</h1> 

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert"> <i class="fas fa-exclamation-triangle me-2"></i>${param.error} <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button> </div>
        </c:if>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert"> <i class="fas fa-check-circle me-2"></i>${param.success} <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button> </div>
        </c:if>

        <div class="row">
            <!-- Register New Relative Card -->
            <div class="col-lg-5 mb-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user-plus me-2"></i>Register a New Relative</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted">Fill out the form to create a patient account for your relative. This will allow you to book appointments on their behalf.</p>
                        <form action="manage-relatives" method="POST" id="addRelativeForm">
                            <input type="hidden" name="action" value="registerAndAppoint">

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="surname" class="form-label">Surname</label>
                                    <input type="text" class="form-control" id="surname" name="surname" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="givenName" class="form-label">Given Name</label>
                                    <input type="text" class="form-control" id="givenName" name="givenName" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="middleName" class="form-label">Middle Name</label>
                                    <input type="text" class="form-control" id="middleName" name="middleName">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="contactNumber" class="form-label">Contact Number</label>
                                <input type="tel" class="form-control" id="contactNumber" name="contactNumber" placeholder="e.g., 09123456789 or +639123456789" pattern="^(\+63|0)9\d{9}$" title="Enter a valid Philippine mobile number (e.g., 09123456789 or +639123456789)." required>
                            </div>

                            <div class="mb-3">
                                <label for="birthday" class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" id="birthday" name="birthday" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Gender</label>
                                <select class="form-select" name="gender" required>
                                    <option value="" selected disabled>-- Select Gender --</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Permanent Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2" required placeholder="Street, Barangay, City/Town"></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="relationshipType" class="form-label">Relationship to You</label>
                                <select class="form-select" id="relationshipType" name="relationshipType" required>
                                    <option value="" selected disabled>-- Select Relationship --</option>
                                    <option value="Spouse">Spouse</option>
                                    <option value="Child">Child</option>
                                    <option value="Parent">Parent</option>
                                    <option value="Sibling">Sibling</option>
                                    <option value="Grandparent">Grandparent</option>
                                    <option value="Grandchild">Grandchild</option>
                                    <option value="Guardian">Guardian</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div class="text-end mt-4">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-user-check me-2"></i>Register Relative
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Your Relatives List -->
            <div class="col-lg-7 mb-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-list-ul me-2"></i>Your Relatives</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty appointedRelatives}">
                                <ul class="list-group list-group-flush">
                                    <c:forEach var="relative" items="${appointedRelatives}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center p-3">
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}/${relative.profilePicturePath}" alt="Avatar" class="rounded-circle me-3" style="width: 50px; height: 50px;">
                                                <div>
                                                    <div class="fw-bold">${relative.givenName} ${relative.surname}</div>
                                                    <small class="text-muted">@${relative.username}</small>
                                                </div>
                                            </div>
                                            <form action="manage-relatives" method="POST" onsubmit="return confirm('Are you sure you want to remove this relative?');">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="relativeUserId" value="${relative.userId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash-alt"></i> Remove
                                                </button>
                                            </form>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center p-5">
                                    <p class="text-muted">You have not registered any relatives yet. Use the form on the left to add a relative.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set max date for birthday to today to prevent future dates
        const birthdayInput = document.getElementById('birthday');
        if (birthdayInput) {
            const today = new Date().toISOString().split('T')[0];
            birthdayInput.setAttribute('max', today);
        }
    });
</script>
</body>
</html>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-users-slash fa-3x text-muted mb-3"></i>
                            <h5 class="fw-bold">No Relatives Appointed</h5>
                            <p class="text-muted">You haven't appointed any relatives yet. You can add relatives to book appointments for them.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-user-plus me-2"></i>Add a New Relative</h5>
            </div>
            <div class="card-body p-4">
                <p class="mb-3">To add a new relative, go to the "Book for Relative" page where you can register and appoint a new relative.</p>
                <a href="<c:url value='/appoint-relatives'/>" class="btn btn-success">
                    <i class="fas fa-calendar-day me-2"></i>Go to Book for Relative
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
