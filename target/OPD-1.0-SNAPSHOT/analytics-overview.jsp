<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Set cache control headers to prevent browser caching of this page.
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    // Security check: only allow Admin users to access this page.
    Object userType = session.getAttribute("userType");
    if (userType == null) {
        // Session has expired or user is not logged in
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Your session has expired. Please log in again.");
    } else if (!"Admin".equals(userType)) {
        // User is logged in but does not have the correct role
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied. You do not have permission to view this page.");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Analytics Overview - AMH Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        .card-header {
            font-weight: 600;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .main-content {
            margin: 0 !important; /* Full screen */
            padding: 30px; /* Add some space around the content */
        }
        .stat-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .stat-card .display-4 {
            font-weight: 700;
        }
        .table-hover tbody tr:hover {
            background-color: #e9f5e9;
        }
        .card-icon {
            font-size: 2.5rem;
            opacity: 0.3;
        }
    </style>
</head>
<body>

<c:import url="admin_navbar.jsp" />
<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Analytics Overview</h1>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h2">Daily Reports</h2>
            <div class="text-muted">
                <i class="fas fa-calendar-alt me-2"></i>
                <span id="currentDate"></span>
            </div>
        </div>

        <!-- Stat Cards Row -->
        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-start border-primary border-4 h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-xs fw-bold text-primary text-uppercase mb-1">Scheduled Today</div>
                            <div id="totalCount" class="display-4">0</div>
                        </div>
                        <i class="fas fa-calendar-check card-icon text-primary"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-start border-success border-4 h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-xs fw-bold text-success text-uppercase mb-1">Completed</div>
                            <div id="completedCount" class="display-4">0</div>
                        </div>
                        <i class="fas fa-check-circle card-icon text-success"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-start border-warning border-4 h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-xs fw-bold text-warning text-uppercase mb-1">Pending</div>
                            <div id="pendingCount" class="display-4">0</div>
                        </div>
                        <i class="fas fa-clock card-icon text-warning"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-start border-danger border-4 h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-xs fw-bold text-danger text-uppercase mb-1">Cancelled</div>
                            <div id="cancelledCount" class="display-4">0</div>
                        </div>
                        <i class="fas fa-times-circle card-icon text-danger"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts and Details Row -->
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Appointments Status Breakdown</h5>
                    </div>
                    <div class="card-body p-3 d-flex justify-content-center align-items-center" style="min-height: 350px;">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-list-alt me-2"></i>Today's Appointment List</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Time</th>
                                        <th>Patient Name</th>
                                        <th>Doctor</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody id="appointmentsTableBody">
                                    <!-- Data will be populated by JavaScript -->
                                    <tr><td colspan="4" class="text-center p-4">Loading appointments...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

        fetch('admin-dashboard?action=getDailyReportData')
            .then(response => response.json())
            .then(data => {
                updateStatCards(data.statusCounts);
                createStatusChart(data.statusCounts);
                populateAppointmentsTable(data.appointments);
            })
            .catch(error => console.error('Error fetching daily report data:', error));
    });

    function updateStatCards(counts) {
        document.getElementById('totalCount').textContent = counts.total || 0;
        document.getElementById('completedCount').textContent = counts.completed || 0;
        document.getElementById('pendingCount').textContent = counts.pending || 0;
        document.getElementById('cancelledCount').textContent = counts.cancelled || 0;
    }

    function createStatusChart(counts) {
        const ctx = document.getElementById('statusChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Completed', 'Pending', 'Cancelled'],
                datasets: [{
                    data: [counts.completed, counts.pending, counts.cancelled],
                    backgroundColor: ['#198754', '#ffc107', '#dc3545'],
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                }
            }
        });
    }

    function populateAppointmentsTable(appointments) {
        const tableBody = document.getElementById('appointmentsTableBody');
        const completedAppointments = appointments ? appointments.filter(appt => appt.status.toLowerCase() === 'completed') : [];

        if (completedAppointments.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="4" class="text-center p-4 text-muted">No completed appointments for today.</td></tr>';
            return;
        }

        let tableHtml = '';
        completedAppointments.forEach(appt => {
            // All appointments here are 'completed', so we use the success badge
            const statusBadge = 'bg-success';
            tableHtml += `
                <tr>
                    <td><c:out value="${appt.time}"/></td>
                    <td><c:out value="${appt.patientName}"/></td>
                    <td><c:out value="${appt.doctorName}"/></td>
                    <td><span class="badge ${statusBadge}"><c:out value="Completed"/></span></td>
                </tr>
            `;
        });
        tableBody.innerHTML = tableHtml;
    }
</script>
</body>
</html>
