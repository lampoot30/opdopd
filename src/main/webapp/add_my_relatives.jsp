<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Relative</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .main-content { margin-left: 260px; padding: 2rem; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; background-color: var(--primary-green, #28a745); }
        .form-label { font-weight: 500; }
        .relative-row:hover {
            background-color: #e9f5ec; /* Light green on hover */
            cursor: pointer;
            color: #155724;
        }
    </style>
</head>
<body>

    <c:import url="navbar-patient.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <h1 class="h2 mb-4">Manage Relatives</h1>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row">
                <!-- Add New Relative Form -->
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <i class="fas fa-user-plus me-2"></i>Add New Relative
                        </div>
                        <div class="card-body p-4">
                            <form action="<c:url value='/my-relatives'/>" method="post">
                                 <div class="mb-3">
                                    <label for="relationship" class="form-label">Relationship</label>
                                    <select class="form-select" id="relationship" name="relationship" required>
                                        <option value="" selected disabled>Select a relationship...</option>
                                        <option value="Spouse">Spouse</option>
                                        <option value="Child">Child</option>
                                        <option value="Parent">Parent</option>
                                        <option value="Sibling">Sibling</option>
                                        <option value="Guardian">Guardian</option>
                                        <option value="Others">Others</option>
                                    </select>
                                </div>
                                <div class="mb-3" id="otherRelationshipContainer" style="display: none;">
                                    <label for="otherRelationship" class="form-label">Please Specify Relationship</label>
                                    <input type="text" class="form-control" id="otherRelationship" name="otherRelationship" placeholder="e.g., Grandparent, Cousin">
                                </div>
                                <div class="mb-3">
                                    <label for="surname" class="form-label">Surname</label>
                                    <input type="text" class="form-control" id="surname" name="surname" placeholder="e.g., Dela Cruz" required>
                                </div>
                                <div class="mb-3">
                                    <label for="givenName" class="form-label">Given Name</label>
                                    <input type="text" class="form-control" id="givenName" name="givenName" placeholder="e.g., Juan" required>
                                </div>
                                <div class="mb-3">
                                    <label for="middleName" class="form-label">Middle Name</label>
                                    <input type="text" class="form-control" id="middleName" name="middleName" placeholder="e.g., Santos">
                                </div>
                                <div class="mb-3">
                                    <label for="contactNumber" class="form-label">Contact Number</label>
                                    <input type="tel" class="form-control" id="contactNumber" name="contactNumber" placeholder="e.g., 09123456789" required pattern="^(09|\+639)\d{9}$" title="Enter a valid Philippine number (e.g., +639... or 09...).">
                                </div>
                                <div class="mb-3">
                                    <label for="birthday" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="birthday" name="birthday" required>
                                </div>
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="" disabled selected>Select Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="religion" class="form-label">Religion</label>
                                    <input type="text" class="form-control" id="religion" name="religion" placeholder="e.g., Roman Catholic">
                                </div>
                                <div class="mb-3">
                                    <label for="permanentAddress" class="form-label">Permanent Address</label>
                                    <textarea class="form-control" id="permanentAddress" name="permanentAddress" rows="2" placeholder="e.g., 123 Rizal Street, Barangay 1" required></textarea>
                                </div>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="sameAsPermanent">
                                    <label class="form-check-label" for="sameAsPermanent">
                                        Current address is the same as permanent address.
                                    </label>
                                </div>
                                 <div class="mb-3">
                                    <label for="currentAddress" class="form-label">Current Address</label>
                                    <textarea class="form-control" id="currentAddress" name="currentAddress" rows="2" placeholder="Enter current address if different"></textarea>
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
                                    <div class="col-md-6 mb-3"><label for="zipCode" class="form-label">Zip Code</label><input type="text" class="form-control" id="zipCode" name="zipCode" placeholder="Auto-generated" required readonly></div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100">Add Relative</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Relatives List -->
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <i class="fas fa-users me-2"></i>Your Added Relatives
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Name</th>
                                            <th class="text-center">Relationship</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="relative" items="${relativesList}" varStatus="loop">
                                            <tr>
                                                <td><c:out value="${relative.given_name} ${relative.surname}"/></td>
                                                <td class="text-center"><c:out value="${relative.relationship}"/></td>
                                                <td class="text-end">
                                                    <a href="<c:url value='/view-relative-records?relativeId=${relative.relative_id}'/>" class="btn btn-sm btn-outline-info"><i class="fas fa-file-medical"></i> View Records</a>
                                                    <a href="<c:url value='/book-for-relative?relativeId=${relative.relative_id}'/>" class="btn btn-sm btn-outline-primary"><i class="fas fa-calendar-plus"></i> Book</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty relativesList}">
                                            <tr>
                                                <td colspan="3" class="text-center text-muted p-4">You have not added any relatives yet.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="successModalLabel"><i class="fas fa-check-circle me-2"></i>Success</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="successModalBody">
                    <!-- Success message will be injected here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-populate ZIP code based on city selection
            const cityDropdown = document.getElementById('city');
            const postalCodeInput = document.getElementById('zipCode');
            cityDropdown.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                postalCodeInput.value = selectedOption.getAttribute('data-zip') || '';
            });

            // Handle "Same as Permanent Address" checkbox
            const permanentAddressInput = document.getElementById('permanentAddress');
            const currentAddressInput = document.getElementById('currentAddress');
            const sameAddressCheckbox = document.getElementById('sameAsPermanent');

            sameAddressCheckbox.addEventListener('change', function() {
                if (this.checked) {
                    currentAddressInput.value = permanentAddressInput.value;
                    currentAddressInput.readOnly = true;
                } else {
                    currentAddressInput.value = '';
                    currentAddressInput.readOnly = false;
                }
            });

            permanentAddressInput.addEventListener('input', function() {
                if (sameAddressCheckbox.checked) {
                    currentAddressInput.value = this.value;
                }
            });
            
            // Handle "Others" in relationship dropdown
            const relationshipDropdown = document.getElementById('relationship');
            const otherRelationshipContainer = document.getElementById('otherRelationshipContainer');
            const otherRelationshipInput = document.getElementById('otherRelationship');

            relationshipDropdown.addEventListener('change', function() {
                const isOther = this.value === 'Others';
                otherRelationshipContainer.style.display = isOther ? 'block' : 'none';
                otherRelationshipInput.required = isOther;
            });

            // --- New: Handle Success Modal ---
            const urlParams = new URLSearchParams(window.location.search);
            const successMessage = urlParams.get('success');

            if (successMessage) {
                const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                document.getElementById('successModalBody').textContent = successMessage;
                successModal.show();

                // Clean the URL to prevent the modal from re-appearing on refresh
                const newUrl = window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            }
        });
    </script>
</body>
</html>
