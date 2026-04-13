<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Security check: only allow Super Admin users to access this page.
    if (!"Super Admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Backup & Restore - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .card-header { font-weight: 600; color: white; border-top-left-radius: 15px; border-top-right-radius: 15px; }
        .form-label { font-weight: 500; }
        .password-toggle-btn {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            z-index: 10;
            border: none;
            background: transparent;
            cursor: pointer;
            padding: .375rem .75rem;
        }
    </style>
</head>
<body>

<c:import url="super_admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Backup & Restore Database</h1>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- Backup Card -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary">
                        <h5 class="mb-0"><i class="fas fa-download me-2"></i>Create a Backup</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">Create a complete backup of the database. This will generate a downloadable ZIP file containing the database schema and data.</p>
                        <form id="backupForm" action="<c:url value='/BackupServlet'/>" method="post">
                            <!-- The password will be added here by JavaScript -->
                        </form>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#passwordConfirmModal" data-action="backup">
                            <i class="fas fa-database me-2"></i>Create Backup
                        </button>
                    </div>
                </div>
            </div>

            <!-- Restore Card -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="fas fa-upload me-2"></i>Restore from Backup</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text text-danger fw-bold">Warning: Restoring will overwrite the current database. This action cannot be undone.</p>
                        <form id="restoreForm" action="<c:url value='/RestoreServlet'/>" method="post" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label for="backupFile" class="form-label">Select Backup File (.sql)</label>
                                <input class="form-control" type="file" id="backupFile" name="backupFile" accept=".sql" required>
                            </div>
                            <!-- The password will be added here by JavaScript -->
                        </form>
                        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#passwordConfirmModal" data-action="restore">
                            <i class="fas fa-exclamation-triangle me-2"></i>Restore Database
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Password Confirmation Modal -->
<div class="modal fade" id="passwordConfirmModal" tabindex="-1" aria-labelledby="passwordConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="passwordConfirmModalLabel"><i class="fas fa-shield-alt me-2"></i>Confirm Your Identity</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>For security, please enter your password to proceed.</p>
                <div class="form-floating">
                    <input type="password" class="form-control" id="confirmationPassword" placeholder="Password" required>
                    <label for="confirmationPassword">Password</label>
                </div>
                <div id="passwordError" class="text-danger mt-2" style="display: none;">Password cannot be empty.</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmActionButton">
                    <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true" style="display: none;"></span>
                    <span class="button-text">Confirm</span>
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="successModalLabel"><i class="fas fa-check-circle me-2"></i>Operation Successful</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="successModalBody">
                <!-- Success message will be injected here by JavaScript -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const passwordModal = new bootstrap.Modal(document.getElementById('passwordConfirmModal'));
        const confirmActionButton = document.getElementById('confirmActionButton');
        const passwordInput = document.getElementById('confirmationPassword');
        const passwordError = document.getElementById('passwordError');
        let currentAction = null;

        // Listen for modal show event to set the action
        document.getElementById('passwordConfirmModal').addEventListener('show.bs.modal', function (event) {
            // Button that triggered the modal
            const button = event.relatedTarget;
            currentAction = button.getAttribute('data-action');
            
            // Clear previous state
            passwordInput.value = '';
            passwordError.style.display = 'none';
        });

        // Handle the final confirmation click
        confirmActionButton.addEventListener('click', function () {
            const password = passwordInput.value;
            if (!password) {
                passwordError.style.display = 'block';
                return;
            }
            passwordError.style.display = 'none';

            // Show loading spinner and disable button
            const spinner = confirmActionButton.querySelector('.spinner-border');
            const buttonText = confirmActionButton.querySelector('.button-text');
            spinner.style.display = 'inline-block';
            buttonText.textContent = 'Processing...';
            confirmActionButton.disabled = true;

            let form;
            if (currentAction === 'backup') {
                form = document.getElementById('backupForm');
            } else if (currentAction === 'restore') {
                form = document.getElementById('restoreForm');
                // Check if a file is selected for restore
                if (!document.getElementById('backupFile').files.length) {
                    alert('Please select a backup file to restore.');
                    passwordModal.hide();
                    // Reset button state
                    spinner.style.display = 'none';
                    buttonText.textContent = 'Confirm';
                    confirmActionButton.disabled = false;
                    return;
                }
            }

            if (form) {
                // Remove any existing password field to prevent duplicates
                const existingPasswordField = form.querySelector('input[name="confirmationPassword"]');
                if (existingPasswordField) {
                    existingPasswordField.remove();
                }

                // Add the password as a hidden input to the form
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'confirmationPassword';
                hiddenInput.value = password;
                form.appendChild(hiddenInput);

                // Hide the modal before submitting
                passwordModal.hide();

                // Submit the form
                form.submit();
            }
        });

        // Check for success parameter in URL and show modal
        const urlParams = new URLSearchParams(window.location.search);
        const successMessage = urlParams.get('success');
        const downloadFileName = urlParams.get('downloadFileName');

        if (successMessage) {
            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
            document.getElementById('successModalBody').textContent = successMessage;
            successModal.show();

            if (downloadFileName) {
                // If a download is triggered, initiate it after the modal is shown
                successModal._element.addEventListener('shown.bs.modal', function () {
                    window.location.href = `<c:url value="/temp_downloads/"/>${downloadFileName}`;
                }, { once: true });
            }

            // Clean the URL to prevent the modal from showing again on refresh
            history.replaceState(null, '', window.location.pathname + (urlParams.has('error') ? `?error=${urlParams.get('error')}` : ''));
        }
    });
</script>
</body>
</html>