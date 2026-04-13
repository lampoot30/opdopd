<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <meta charset="UTF-8">
    <title>Add New Admin - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .card-header { background-color: #dc3545; color: white; font-weight: 600; border-top-left-radius: 15px; border-top-right-radius: 15px; }
        .form-section-title { font-weight: 600; color: #dc3545; border-bottom: 2px solid #dc3545; padding-bottom: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <c:import url="super_admin_navbar.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h2"><i class="fas fa-user-plus me-2"></i>Add New Admin</h1>
                <a href="<c:url value='/super-admin-dashboard'/>" class="btn btn-secondary">Back to Dashboard</a>
            </div>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger" role="alert"><c:out value="${param.error}"/></div>
            </c:if>
            <c:if test="${not empty param.success}">
                <div class="alert alert-success" role="alert"><c:out value="${param.success}"/></div>
            </c:if>

            <div class="card">
                <div class="card-body p-4">
                    <form id="addAdminForm" action="AddAdminServlet" method="post" enctype="multipart/form-data">

                        <h5 class="form-section-title">Personal Information</h5>
                        <div class="row">
                            <div class="col-md-4 mb-3"><label for="surname" class="form-label">Surname</label><input type="text" class="form-control" id="surname" name="surname" required></div>
                            <div class="col-md-4 mb-3"><label for="givenName" class="form-label">Given Name</label><input type="text" class="form-control" id="givenName" name="givenName" required></div>
                            <div class="col-md-4 mb-3"><label for="middleName" class="form-label">Middle Name</label><input type="text" class="form-control" id="middleName" name="middleName"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label for="dateOfBirth" class="form-label">Date of Birth</label><input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required></div>
                            <div class="col-md-6 mb-3">
                                <label for="gender" class="form-label">Gender</label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>

                        <hr class="my-4">
                        <h5 class="form-section-title">Address Information</h5>
                        <div class="mb-3">
                            <label for="permanentAddress" class="form-label">Permanent Address</label>
                            <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" required placeholder="e.g., House No., Street, Barangay"></textarea>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="sameAsPermanent">
                            <label class="form-check-label" for="sameAsPermanent">Current address is the same as permanent address.</label>
                        </div>
                        <div class="mb-3">
                            <label for="currentAddress" class="form-label">Current Address</label>
                            <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" required placeholder="e.g., House No., Street, Barangay"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="city" class="form-label">City/Town (Aurora)</label>
                                <select class="form-select" id="city" name="city" required>
                                    <option value="" selected disabled>Select a municipality...</option>
                                    <option value="Baler" data-zip="3200">Baler</option>
                                    <option value="Casiguran" data-zip="3204">Casiguran</option>
                                    <option value="Dilasag" data-zip="3205">Dilasag</option>
                                    <option value="Dinalungan" data-zip="3206">Dinalungan</option>
                                    <option value="Dingalan" data-zip="3207">Dingalan</option>
                                    <option value="Dipaculao" data-zip="3202">Dipaculao</option>
                                    <option value="Maria Aurora" data-zip="3203">Maria Aurora</option>
                                    <option value="San Luis" data-zip="3201">San Luis</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="postalCode" class="form-label">Postal/ZIP Code</label>
                                <input type="text" class="form-control" id="postalCode" name="postalCode" required readonly>
                            </div>
                        </div>

                        <hr class="my-4">
                        <h5 class="form-section-title">Account & Contact</h5>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="contactNumber" class="form-label">Contact Number</label>
                                <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="+63" required pattern="^(09|\+639)\d{9}$" title="Enter a valid Philippine number (e.g., +639... or 09...).">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required readonly>
                                <div class="form-text">Username is auto-generated from the name fields.</div>
                            </div>
                        </div>

                        <hr class="my-4">
                        <h5 class="form-section-title">Profile Picture</h5>
                        <div class="mb-3">
                            <label for="profilePicture" class="form-label">Upload Picture (Optional)</label>
                            <input class="form-control" type="file" id="profilePicture" name="profile_picture" accept="image/*">
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="button" class="btn btn-danger btn-lg" id="addAdminModalBtn" data-bs-toggle="modal" data-bs-target="#confirmationModal" disabled>Add Admin</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="confirmationModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Confirm Action</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to add this new admin?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmSubmitBtn">Yes, Add Admin</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // --- Modal Confirmation Logic ---
        const confirmSubmitBtn = document.getElementById('confirmSubmitBtn');
        const form = document.getElementById('addAdminForm');
        if (confirmSubmitBtn && form) {
            confirmSubmitBtn.addEventListener('click', function() {                
                // Final check before submitting
                if (form.checkValidity()) {
                    form.submit();
                } else {
                    // If form is invalid, hide the modal and trigger browser's native validation UI
                    var confirmationModal = bootstrap.Modal.getInstance(document.getElementById('confirmationModal'));
                    confirmationModal.hide();
                    form.reportValidity(); // This will show which fields are incomplete
                }
            });
        }

        // --- Disable/Enable submit button based on form validity ---
        const addAdminBtn = document.getElementById('addAdminModalBtn');
        const requiredFields = form.querySelectorAll('[required]');

        function validateAdminForm() {
            let allFilled = true;
            requiredFields.forEach(field => {
                if (!field.readOnly && !field.value.trim()) {
                    allFilled = false;
                }
            });
            addAdminBtn.disabled = !allFilled;
        }

        // --- Date of Birth Validation ---
        const dobInputAdmin = document.getElementById('dateOfBirth');
        if (dobInputAdmin) {
            const today = new Date().toISOString().split('T')[0];
            dobInputAdmin.setAttribute('max', today);
        }

        // --- Input validation for name fields ---
        function restrictNameInput(event) {
            event.target.value = event.target.value.replace(/[^a-zA-Z\s]/g, '');
        }
        document.getElementById('surname').addEventListener('input', restrictNameInput);
        document.getElementById('givenName').addEventListener('input', restrictNameInput);
        document.getElementById('middleName').addEventListener('input', restrictNameInput);

        // --- Address Logic ---
        const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');
        const permanentAddress = document.getElementById('permanentAddress');
        const currentAddress = document.getElementById('currentAddress');
        sameAsPermanentCheckbox.addEventListener('change', function() {
            currentAddress.readOnly = this.checked;
            if (this.checked) currentAddress.value = permanentAddress.value;
        });
        permanentAddress.addEventListener('input', function() {
            if (sameAsPermanentCheckbox.checked) currentAddress.value = this.value;
        });

        // --- ZIP Code Logic ---
        const cityDropdown = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');
        cityDropdown.addEventListener('change', function() {
            postalCodeInput.value = this.options[this.selectedIndex].getAttribute('data-zip') || '';
        });

        // --- Username Generation ---
        function generateUsername() {
            const surname = document.getElementById('surname').value.trim().toLowerCase();
            const givenName = document.getElementById('givenName').value.trim().toLowerCase();
            if (surname && givenName) {
                document.getElementById('username').value = surname + '.' + givenName;
            }
        }
        document.getElementById('surname').addEventListener('input', generateUsername);
        document.getElementById('givenName').addEventListener('input', generateUsername);

        // Add listener to the form to check validity on any input
        form.addEventListener('input', validateAdminForm);
        validateAdminForm(); // Initial check on page load
    });
</script>
</body>
</html>