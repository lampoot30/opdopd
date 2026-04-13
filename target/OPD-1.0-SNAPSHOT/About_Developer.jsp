<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About Developer - AMH OPD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fff;
            margin: 0;
            overflow-x: hidden;
        }
        .main-container {
            width: 100%;
            min-height: 100vh;
            padding: 0;
        }
        .dev-card {
            width: 100%;
            min-height: 100vh;
            background: white;
            border: none;
            border-radius: 0;
            box-shadow: none;
        }
        .row-full-height {
            min-height: 100vh;
        }
        /* Slanted Gallery Styles */
        .slanted-wrapper {
            display: flex;
            height: 100%;
            width: 100%;
            background: #6e6e6e;
            overflow: hidden;
        }
        .slanted-item {
            flex: 1;
            height: 100%;
            position: relative;
            transform: skewX(-10deg);
            overflow: hidden;
            border-right: 1px solid rgba(255,255,255,0.1);
            margin-right: -1px; /* fix border gap */
            transition: flex 0.5s cubic-bezier(0.25, 1, 0.5, 1);
            cursor: pointer;
            text-decoration: none;
        }
        /* Fix the first and last items filling gaps */
        .slanted-item:first-child { margin-left: -50px; flex: 1.5; }
        .slanted-item:last-child { margin-right: -50px; flex: 1.5; }
        
        .slanted-item:hover {
            flex: 4;
        }
        
        .slanted-img-wrap {
            width: 150%;
            height: 100%;
            transform: skewX(10deg); /* Counter-skew */
            position: relative;
            left: -25%;
        }
        
        .slanted-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: grayscale(100%) brightness(0.6);
            transition: filter 0.5s ease, transform 0.5s ease;
        }
        
        .slanted-item:hover .slanted-img {
            filter: grayscale(0%) brightness(1);
            transform: scale(1.1);
        }
        
        .slanted-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            transform: skewX(10deg); /* Counter-skew text */
            opacity: 0.7;
            transition: opacity 0.3s ease;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            pointer-events: none;
        }
        .slanted-item:hover .slanted-overlay {
            opacity: 1;
            background: linear-gradient(to top, rgba(25, 135, 84, 0.9), rgba(25, 135, 84, 0.3));
        }
        .dev-body {
            padding: 80px 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%;
        }
        .skill-badge {
            background-color: rgba(25, 135, 84, 0.1);
            color: #198754;
            border: 1px solid transparent;
            padding: 10px 20px;
            border-radius: 30px;
            margin: 0 10px 10px 0;
            display: inline-flex;
            align-items: center;
            font-weight: 500;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        .skill-badge:hover {
            background-color: #198754;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(25, 135, 84, 0.2);
        }
        .section-title {
            position: relative;
            display: inline-block;
            margin-bottom: 1.5rem;
            color: #198754;
            font-weight: 700;
        }
        .section-title::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -8px;
            width: 40px;
            height: 3px;
            background-color: #198754;
            border-radius: 2px;
        }
        /* Tooltip styles for skill badges */
        .skill-badge {
            position: relative;
        }
        .skill-badge[data-desc]:hover::after {
            content: attr(data-desc);
            position: absolute;
            bottom: 135%;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(33, 37, 41, 0.95);
            color: #fff;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 400;
            white-space: normal;
            width: max-content;
            max-width: 220px;
            text-align: center;
            z-index: 100;
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            pointer-events: none;
            opacity: 0;
            animation: tooltipFadeIn 0.2s forwards;
        }
        .skill-badge[data-desc]:hover::before {
            content: '';
            position: absolute;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
            border: 6px solid transparent;
            border-top-color: rgba(33, 37, 41, 0.95);
            z-index: 100;
            opacity: 0;
            animation: tooltipFadeIn 0.2s forwards;
        }
        @keyframes tooltipFadeIn {
            from { opacity: 0; transform: translate(-50%, 5px); }
            to { opacity: 1; transform: translate(-50%, 0); }
        }
        @media (max-width: 768px) {
            .dev-body {
                padding: 40px 20px;
                height: auto;
            }
            .row-full-height {
                height: auto;
            }
            .slanted-wrapper {
                flex-direction: column;
                height: 50vh;
            }
            .slanted-item {
                transform: none;
                margin: 0;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                flex: 1 !important;
            }
            .slanted-img-wrap {
                width: 100%;
                transform: none;
                left: 0;
            }
            .slanted-overlay {
                transform: none;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="dev-card">
            <div class="row g-0 row-full-height">
                <!-- Left Sidebar -->
                <div class="col-md-5 col-lg-4 p-0">
                    <div class="slanted-wrapper">
                        <!-- Photo 1: samerei -->
                        <a href="#" class="slanted-item" data-target="samerei-content">
                            <div class="slanted-img-wrap">
                                <img src="<c:url value='/images/sam.jpg'/>" alt="Profile" class="slanted-img">
                            </div>
                            <div class="slanted-overlay">
                                <i class="fas fa-user-secret fa-2x text-white mb-2"></i>
                                <span class="text-white fw-bold">SAMEREI</span>
                            </div>
                        </a>
                        <!-- Photo 2: raphael -->
                        <a href="#" class="slanted-item" data-target="raphael-content">
                            <div class="slanted-img-wrap">
                                <img src="<c:url value='/images/cenon.jpg'/>" alt="Code" class="slanted-img" style="filter: hue-rotate(90deg) grayscale(100%) brightness(0.6);">
                            </div>
                            <div class="slanted-overlay">
                                <i class="fas fa-file-alt fa-2x text-white mb-2"></i>
                                <span class="text-white fw-bold">RAPHAEL</span>
                            </div>
                        </a>
                        <!-- Photo 3: Via -->
                        <a href="#" class="slanted-item" data-target="via-content">
                            <div class="slanted-img-wrap">
                                <img src="<c:url value='/images/via.jpg'/>" alt="Tester" class="slanted-img" style="filter: hue-rotate(270deg) grayscale(100%) brightness(0.6);">
                            </div>
                            <div class="slanted-overlay">
                                <i class="fas fa-clipboard-check fa-2x text-white mb-2"></i>
                                <span class="text-white fw-bold">VIA</span>
                            </div>
                        </a>
                        <!-- Photo 4: Jade -->
                        <a href="#" class="slanted-item" data-target="jade-content">
                            <div class="slanted-img-wrap">
                                <img src="<c:url value='/images/jade.jpg'/>" alt="Coordinator" class="slanted-img" style="filter: hue-rotate(180deg) grayscale(100%) brightness(0.6);">
                            </div>
                            <div class="slanted-overlay">
                                <i class="fas fa-handshake fa-2x text-white mb-2"></i>
                                <span class="text-white fw-bold">JADE</span>
                            </div>
                        </a>
                        
                    </div>
                </div>

                <!-- Right Content -->
                <div class="col-md-7 col-lg-8">
                    <div class="dev-body">
                        
                        <!-- Default Content -->
                        <div id="default-content" class="developer-content">
                            <h4 class="section-title">Meet the Creators</h4>
                            <h2 class="fw-bold mb-1 text-dark">System Developers</h2>
                            <p class="mb-4 text-muted">Full Stack Java Development</p>

                            <p class="text-muted mb-5 lead" style="line-height: 1.8;">
                                This Out-Patient Department (OPD) Management System was architected and developed to streamline hospital operations, 
                                enhance patient data security, and improve the overall healthcare experience at Aurora Memorial Hospital.
                                Hover over a profile on the left to see individual contributions.
                            </p>

                            <h5 class="text-dark fw-bold mb-4">Core Technologies</h5>
                            <div class="mb-5">
                                <span class="skill-badge" data-desc="Enterprise-grade backend logic and object-oriented architecture."><i class="fab fa-java me-2"></i>Java EE</span>
                                <span class="skill-badge" data-desc="Relational database management for secure patient records."><i class="fas fa-database me-2"></i>MySQL/MariaDB</span>
                                <span class="skill-badge" data-desc="Responsive frontend framework for consistent UI design."><i class="fab fa-bootstrap me-2"></i>Bootstrap 5</span>
                                <span class="skill-badge" data-desc="Server-side rendering for dynamic web content."><i class="fab fa-html5 me-2"></i>JSP & Servlets</span>
                                <span class="skill-badge" data-desc="Client-side validation and interactive user experience."><i class="fab fa-js me-2"></i>JavaScript</span>
                                <span class="skill-badge" data-desc="Robust web container for application deployment."><i class="fas fa-server me-2"></i>Tomcat</span>
                            </div>
                        </div>
                        
                        <!-- Samerei's Content (Hidden by default) -->
                        <div id="samerei-content" class="developer-content" style="display: none;">
                            <h4 class="section-title">Profile Overview</h4>
                            <h2 class="fw-bold mb-1 text-dark">Samerei (Sam) P. Orande</h2>
                            <p class="mb-4 text-muted">Lead Full Stack Developer & System Architect</p>
                            <p class="text-muted mb-5 lead" style="line-height: 1.8;">
                                Samerei is the primary architect and developer of the AMH OPD Management System. He was responsible for the end-to-end development, from database design and backend Java logic to the frontend user interface. His work focused on building a secure, robust, and efficient system to modernize the hospital's outpatient workflow.
                            </p>
                            <h5 class="text-dark fw-bold mb-4">Core Contributions</h5>
                            <div class="mb-5">
                                <span class="skill-badge"><i class="fab fa-java me-2"></i>Backend Architecture (Java EE)</span>
                                <span class="skill-badge"><i class="fas fa-database me-2"></i>Database Management (MySQL)</span>
                                <span class="skill-badge"><i class="fas fa-shield-alt me-2"></i>Security & Authentication</span>
                                <span class="skill-badge"><i class="fab fa-bootstrap me-2"></i>Frontend Development (JSP/Bootstrap)</span>
                                <span class="skill-badge"><i class="fas fa-server me-2"></i>Server Deployment (Tomcat)</span>
                            </div>
                        </div>

                        <!-- Raphael's Content (Hidden by default) -->
                        <div id="raphael-content" class="developer-content" style="display: none;">
                             <h4 class="section-title">Profile Overview</h4>
                            <h2 class="fw-bold mb-1 text-dark">Raphael Leinard (Raph) V. Cenon</h2>
                            <p class="mb-4 text-muted">System Documentation & Project Management</p>
                            <p class="text-muted mb-5 lead" style="line-height: 1.8;">
                                Raphael was primarily responsible for the project's comprehensive documentation. His contributions spanned the entire project lifecycle, from initial title brainstorming and conceptualization to writing the final deployment guide for the capstone manuscript (Chapters 1-5).
                            </p>
                            <h5 class="text-dark fw-bold mb-4">Core Contributions</h5>
                            <div class="mb-5">
                                <span class="skill-badge"><i class="fas fa-file-alt me-2"></i>Project Documentation</span>
                                <span class="skill-badge"><i class="fas fa-book me-2"></i>Capstone Manuscript (Chapters 1-5)</span>
                                <span class="skill-badge"><i class="fas fa-lightbulb me-2"></i>Title Brainstorming</span>
                                <span class="skill-badge"><i class="fas fa-rocket me-2"></i>Deployment Planning</span>
                            </div>
                        </div>

                        <!-- Via's Content (Hidden by default) -->
                        <div id="via-content" class="developer-content" style="display: none;">
                             <h4 class="section-title">Profile Overview</h4>
                            <h2 class="fw-bold mb-1 text-dark">Via (Via) DS. Livioco</h2>
                            <p class="mb-4 text-muted">Quality Assurance & System Tester</p>
                            <p class="text-muted mb-5 lead" style="line-height: 1.8;">
                                Via was responsible for testing the functionalities added to the system as the programmer progressed. By doing verification of features and bug reporting ensured the system's stability and operational readiness throughout the development lifecycle.
                            </p>
                            <h5 class="text-dark fw-bold mb-4">Core Contributions</h5>
                            <div class="mb-5">
                                <span class="skill-badge"><i class="fas fa-vial me-2"></i>Functional Testing</span>
                                <span class="skill-badge"><i class="fas fa-bug me-2"></i>Bug Reporting</span>
                                <span class="skill-badge"><i class="fas fa-tasks me-2"></i>System Verification</span>
                                <span class="skill-badge"><i class="fas fa-clipboard-check me-2"></i>Quality Assurance</span>
                            </div>
                        </div>

                        <!-- Jade's Content (Hidden by default) -->
                        <div id="jade-content" class="developer-content" style="display: none;">
                             <h4 class="section-title">Profile Overview</h4>
                            <h2 class="fw-bold mb-1 text-dark">Crysthel Jade (Jade) C. Balinbin</h2>
                            <p class="mb-4 text-muted">Group Coordinator & Client Liaison</p>
                            <p class="text-muted mb-5 lead" style="line-height: 1.8;">
                                Crysthel served as the group's coordinator and the primary point of contact for the client. She facilitated communication between the development team and stakeholders, gathering requirements and ensuring the system met all operational needs.
                            </p>
                            <h5 class="text-dark fw-bold mb-4">Core Contributions</h5>
                            <div class="mb-5">
                                <span class="skill-badge"><i class="fas fa-handshake me-2"></i>Client Communication</span>
                                <span class="skill-badge"><i class="fas fa-users-cog me-2"></i>Team Coordination</span>
                                <span class="skill-badge"><i class="fas fa-clipboard-list me-2"></i>Requirements Gathering</span>
                                <span class="skill-badge"><i class="fas fa-headset me-2"></i>Stakeholder Support</span>
                            </div>
                        </div> 

                        <div class="mt-auto d-flex gap-2 flex-wrap">
                            <a href="<c:url value='/index.jsp'/>" class="btn btn-outline-success rounded-pill px-4 py-2 fw-bold">
                                <i class="fas fa-arrow-left me-2"></i>Back to Home
                            </a>
                            <a href="<c:url value='/OPD_User_Manual.jsp'/>" target="_blank" class="btn btn-success rounded-pill px-4 py-2 fw-bold shadow-sm">
                                <i class="fas fa-book-reader me-2"></i>User Manual
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const slantedItems = document.querySelectorAll('.slanted-item');
            const contentPanels = document.querySelectorAll('.developer-content');
            const wrapper = document.querySelector('.slanted-wrapper');
            const defaultContent = document.getElementById('default-content');

            slantedItems.forEach(item => {
                item.addEventListener('mouseenter', function () {
                    // Hide all content panels
                    contentPanels.forEach(panel => {
                        panel.style.display = 'none';
                    });

                    // Get the target ID from the data attribute
                    const targetId = this.getAttribute('data-target');
                    const targetPanel = document.getElementById(targetId);

                    // Show the corresponding panel if it exists, otherwise show default
                    if (targetPanel) {
                        targetPanel.style.display = 'block';
                    } else {
                        defaultContent.style.display = 'block';
                    }
                });
            });

            // Revert to default when mouse leaves the entire left container
            wrapper.addEventListener('mouseleave', function() {
                contentPanels.forEach(panel => {
                    panel.style.display = 'none';
                });
                defaultContent.style.display = 'block';
            });
        });
    </script>
</body>
</html>