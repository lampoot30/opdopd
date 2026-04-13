<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Analytics Overview - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        .stat-card { 
            border: none; 
            border-radius: 15px; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.08); 
            text-align: center; 
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeIn 0.5s ease-out forwards;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
        }
        .stat-card .card-body { 
            font-size: 3rem; 
            font-weight: 700; 
        }
        .stat-card .card-footer {
            background-color: rgba(0,0,0,0.1);
            border-bottom-left-radius: 15px;
            border-bottom-right-radius: 15px;
            font-weight: 500;
        }
        .chart-card, .table-card {
            border: 1px solid #72b8feff; /* Add a subtle border */
            border-radius: 15px; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.09); /* Enhance the shadow to make it "pop" */
            animation: fadeIn 0.7s ease-out forwards;
        }
        .table-card .table {
            border-radius: 15px;
            overflow: hidden;
        }
        .chart-card .card-header, .table-card .card-header {
            /* Add more padding to prevent text from overlapping the border */
            padding: 1rem 1.5rem;
        }
        .table-hover tbody tr:hover {
            background-color: #ddeeff; /* A light blue highlight for table rows */
            cursor: pointer;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<c:import url="admin_navbar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <h1 class="h2 mb-4">Analytics Overview</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Stat Cards -->
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #1e90ff, #007bff);">
                    <div class="card-body">${patientCount}</div>
                    <div class="card-footer"><i class="fas fa-users me-2"></i>Total Patients</div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #28a745, #20c997);">
                    <div class="card-body">${doctorCount}</div>
                    <div class="card-footer"><i class="fas fa-user-md me-2"></i>Total Doctors</div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="stat-card" style="background: linear-gradient(135deg, #ffc107, #fd7e14);">
                    <div class="card-body">${staffCount}</div>
                    <div class="card-footer"><i class="fas fa-user-nurse me-2"></i>Total Staff</div>
                </div>
            </div>
        </div>

        <!-- Registration Chart and Data Table -->
        <div class="row">
            <div class="col-lg-12">
                <div class="chart-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 text-primary"><i class="fas fa-chart-bar me-2"></i>Patient Registration Trends</h5>
                        <c:if test="${not empty analyticsList}">
                            <span class="badge bg-secondary">${analyticsList[0].year}</span>
                        </c:if>
                    </div>
                    <div class="card-body">
                        <div style="height: 460px;">
                            <canvas id="registrationChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Patient Distribution by Municipality Chart -->
        <div class="row mt-4">
            <div class="col-lg-12">
                <div class="chart-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 text-primary"><i class="fas fa-map-marker-alt me-2"></i>Patient Distribution by Municipality</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-area" style="height: 350px;">
                            <canvas id="patientDistributionChart"></canvas>
                        </div>
                        <div class="text-center text-muted mt-3">
                            <small>This chart shows the number of registered patients from each municipality in Aurora province.</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="card table-card mt-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0 text-primary"><i class="fas fa-table me-2"></i>Registration Data</h5>
                <c:if test="${not empty analyticsList}">
                    <h5 class="mb-0">${analyticsList[0].year}</h5>
                </c:if>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Month</th>
                                <th class="text-end pe-4">Registrations</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="analytic" items="${analyticsList}">
                                <tr>
                                    <td class="ps-4">${analytic.monthName}</td>
                                    <td class="text-end pe-4">${analytic.count}</td>
                                    <td class="text-center">
                                        <a href="<c:url value='/print-registration-report?month=${analytic.monthName}&year=${analytic.year}'/>" class="btn btn-sm btn-outline-secondary" target="_blank" title="Print ${analytic.monthName} Report">
                                            <i class="fas fa-print"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Directly use the data from the servlet to build the chart labels and data.
        const chartLabels = [
            <c:forEach var="analytic" items="${analyticsList}" varStatus="loop">
                "${analytic.monthName}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const chartData = [<c:forEach var="analytic" items="${analyticsList}">${analytic.count},</c:forEach>];

        const ctx = document.getElementById('registrationChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: 'Patient Registrations',
                    data: chartData,
                    backgroundColor: 'rgba(30, 144, 255, 0.5)',
                    borderColor: 'rgba(30, 144, 255, 0.9)',
                    hoverBackgroundColor: 'rgba(30, 144, 255, 0.8)', /* Color for bar on hover */
                    hoverBorderColor: 'rgba(30, 144, 255, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } // Ensure y-axis starts at 0 and increments by whole numbers
            }
        });

        // Fetch and render Patient Distribution by Municipality Chart
        fetch('<c:url value="/api/patient-distribution"/>')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                const ctxDistribution = document.getElementById('patientDistributionChart').getContext('2d');
                new Chart(ctxDistribution, {
                    type: 'pie',
                    data: {
                        labels: Object.keys(data), // City names
                        datasets: [{
                            label: 'Number of Patients',
                            data: Object.values(data), // Patient counts
                            backgroundColor: [
                                'rgba(40, 167, 69, 0.7)',
                                'rgba(30, 144, 255, 0.7)',
                                'rgba(255, 193, 7, 0.7)',
                                'rgba(220, 53, 69, 0.7)',
                                'rgba(23, 162, 184, 0.7)',
                                'rgba(108, 117, 125, 0.7)',
                                'rgba(253, 126, 20, 0.7)',
                                'rgba(102, 16, 242, 0.7)'
                            ],
                            borderColor: '#fff',
                            borderWidth: 1
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });
            })
            .catch(error => console.error('Error fetching patient distribution data:', error));
    });
</script>
</body>
</html>
