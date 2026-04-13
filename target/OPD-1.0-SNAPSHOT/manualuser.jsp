<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OPD System User Manual</title>
    <link rel="icon" href="<c:url value='/images/AMHLOGO.png'/>" type="image/png">
    <style>
        html {
            scroll-behavior: smooth;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f4f7f6;
            color: #333;
        }
        .container {
            max-width: 1000px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            position: relative;
        }
        h1, h2, h3 {
            color: #2c3e50;
            margin-top: 25px;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        h1 { font-size: 2.2em; }
        h2 { font-size: 1.8em; }
        h3 { font-size: 1.4em; }
        p {
            margin-bottom: 10px;
        }
        ul {
            list-style-type: disc;
            margin-left: 20px;
            margin-bottom: 10px;
        }
        ol {
            list-style-type: decimal;
            margin-left: 20px;
            margin-bottom: 10px;
        }
        .note {
            background-color: #e7f3fe;
            border-left: 5px solid #2196F3;
            padding: 10px 15px;
            margin: 15px 0;
            border-radius: 4px;
        }
        #toc ul {
            list-style-type: none;
            padding-left: 0;
        }
        #toc ul li {
            margin-bottom: 8px;
        }
        #toc a {
            text-decoration: none;
            color: #2980b9;
            font-weight: 500;
        }
        #toc a:hover {
            text-decoration: underline;
        }
        .section {
            margin-bottom: 40px;
        }
        .btn-back {
            display: inline-block;
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="javascript:void(0);" onclick="parent.hideManual()" class="btn-back">&larr; Hide Manual</a>
        
        <h1>OPD System User Manual</h1>
        <p>Welcome to the Outpatient Department (OPD) management system. This guide will help you understand how to use the system based on your role.</p>
        <div class="note"><strong>Medical Record Policy:</strong> Your unique OPD Number is automatically generated and assigned to your profile upon the completion of your first consultation.</div>
        
        <div class="section" id="toc">
            <h2>Table of Contents</h2>
            <ul>
                <li><a href="#getting-started">1. Getting Started</a></li>
                <li><a href="#patient-guide">2. Guide for Patients</a></li>
                <li><a href="#staff-guide">3. Guide for Staff</a></li>
                <li><a href="#doctor-guide">4. Guide for Doctors</a></li>
                <li><a href="#admin-guide">5. Guide for Admins & Super Admins</a></li>
            </ul>
        </div>

        <div class="section" id="getting-started">
            <h2>1. Getting Started</h2>
            <h3>1.1. Logging In</h3>
            <p>To access the system, you must first log in with your provided username and password.</p>
            <ol>
                <li>Navigate to the login page.</li>
                <li>Enter your username and password in the respective fields.</li>
                <li>Click the "Login" button.</li>
            </ol>

            <h3>1.2. Resetting Your Password</h3>
            <p>If you have forgotten your password, you can reset it using your registered contact number.</p>
            <ol>
                <li>On the login page, click the "Forgot Password?" link.</li>
                <li>Enter your username and contact number.</li>
                <li>You will receive a One-Time Password (OTP) via SMS.</li>
                <li>Enter the OTP and your new desired password to complete the reset.</li>
            </ol>
        </div>

        <div class="section" id="patient-guide">
            <h2>2. Guide for Patients</h2>
            <p>As a patient, you can manage your appointments, view your medical records, and update your profile.</p>

            <h3>2.1. Viewing Your Dashboard</h3>
            <p>After logging in, you will see your dashboard, which displays your upcoming appointments and provides quick access to other features.</p>

            <h3>2.2. Viewing Medical Records</h3>
            <p>You can view your past appointments and medical history.</p>
            <ol>
                <li>From the main menu, navigate to "Medical Records".</li>
                <li>A list of your past appointments will be displayed.</li>
                <li>You can print details of any "Accepted" appointment.</li>
            </ol>

            <h3>2.3. Managing Relatives</h3>
            <p>You can add relatives to your profile and view their medical records if you are their appointed guardian.</p>
            <ul>
                <li><strong>Add a Relative:</strong> Go to "My Relatives" and fill out the form to add a new relative.</li>
                <li><strong>View Records:</strong> If you are an appointed guardian for a relative, you can view their medical history through the "My Relatives" section.</li>
            </ul>

            <h3>2.4. Updating Your Profile</h3>
            <p>You can keep your personal information up to date.</p>
            <ol>
                <li>Click on your name in the top right corner and select "Profile".</li>
                <li>Update your address, contact number, or password.</li>
                <li class="note"><strong>Note:</strong> Changing your contact number will require OTP verification.</li>
            </ol>
        </div>

        <div class="section" id="staff-guide">
            <h2>3. Guide for Staff</h2>
            <p>As a staff member, you are responsible for managing patient appointments and records.</p>

            <h3>3.1. Staff Dashboard</h3>
            <p>Your dashboard provides an overview of pending appointments that require action and other system notifications.</p>

            <h3>3.2. Managing Appointments</h3>
            <ol>
                <li>From the dashboard, click on a pending appointment or navigate to the "Appointments" section.</li>
                <li>To manage an appointment, click "View Details".</li>
                <li>You can then:
                    <ul>
                        <li><strong>Assign a Doctor and Room:</strong> Select an available doctor and room from the dropdown menus.</li>
                        <li><strong>Accept/Reject:</strong> Change the status of the appointment to "Accepted" or "Rejected".</li>
                        <li><strong>Propose a Reschedule:</strong> Suggest a new date and time for the appointment.</li>
                    </ul>
                </li>
            </ol>

            <h3>3.3. Scheduling a New Appointment</h3>
            <p>You can create a new appointment for a patient directly.</p>
            <ol>
                <li>Navigate to "Schedule Appointment".</li>
                <li>Fill in the patient's details, reason for visit, and preferred date.</li>
                <li>Select the required service and assign a doctor and room.</li>
                <li>Submit the form to create the appointment.</li>
            </ol>

            <h3>3.4. Viewing Patient Records</h3>
            <p>You can look up any patient's profile and appointment history.</p>
            <ol>
                <li>Navigate to "Patient Records".</li>
                <li>A list of all active patients will be displayed.</li>
                <li>Click "View Profile" next to a patient's name to see their detailed information and complete medical history.</li>
            </ol>
        </div>

        <div class="section" id="doctor-guide">
            <h2>4. Guide for Doctors</h2>
            <p>As a doctor, your main focus is on managing your assigned appointments and viewing patient histories.</p>

            <h3>4.1. Doctor Dashboard</h3>
            <p>Your dashboard shows a list of all appointments that have been assigned to you. You can filter them by status (e.g., "Assigned", "Completed").</p>

            <h3>4.2. Viewing Appointment Details</h3>
            <ol>
                <li>From your dashboard, click "View Details" on any appointment.</li>
                <li>You will see all the information related to that appointment, including the patient's reason for visit and any attachments they may have uploaded.</li>
            </ol>

            <h3>4.3. Viewing Patient History</h3>
            <p>When viewing an appointment, you can access the patient's full medical history.</p>
            <ol>
                <li>Inside the appointment details page, click the "View Patient Profile" button.</li>
                <li>This will take you to the patient's complete profile, showing all their past appointments and medical records.</li>
            </ol>

            <h3>4.4. Updating Your Profile</h3>
            <p>You can update your personal and professional information.</p>
            <ol>
                <li>Click on your name in the top right corner and select "Profile".</li>
                <li>You can update your specialization, license number, and other personal details.</li>
            </ol>
        </div>

        <div class="section" id="admin-guide">
            <h2>5. Guide for Admins & Super Admins</h2>
            <p>As an administrator, you have oversight of the entire system, including user management and system maintenance.</p>

            <h3>5.1. Managing User Accounts</h3>
            <p>You can create, manage, and remove user accounts.</p>
            <ul>
                <li><strong>Create Users:</strong> Navigate to the user management section to create new accounts for Admins (Super Admin only), Staff, or Doctors.</li>
                <li><strong>Archive Users:</strong> You can deactivate a user's account, which will prevent them from logging in. This is done from the main user list.</li>
                <li><strong>Manage Archive:</strong> In the "Manage Archive" section, you can either restore an archived user's account or permanently delete it.</li>
            </ul>

            <h3>5.2. System Maintenance (Super Admin only)</h3>
            <p>Super Admins have access to critical system maintenance functions.</p>
            <ul>
                <li><strong>Backup Database:</strong> You can generate a complete backup of the application's database.</li>
                <li>
                    <strong>Restore Database:</strong> You can restore the system to a previous state using a backup file.
                    <div class="note" style="margin-top: 10px; margin-bottom: 5px;"><strong>Caution:</strong> This will overwrite all data created since the backup was made.</div>
                </li>
            </ul>

            <h3>5.3. Viewing Analytics and Reports</h3>
            <p>Admins can view reports on system activity.</p>
            <ul>
                <li><strong>Registration Reports:</strong> Generate reports on patient registration numbers for specific months.</li>
                <li><strong>Audit Logs:</strong> View a complete log of all significant actions taken by users in the system.</li>
            </ul>
        </div>

    </div>
</body>
</html>