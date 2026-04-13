# AMH OPD - Outpatient Department Management System

A comprehensive web-based system for managing outpatient department operations, including patient registration, appointment scheduling, and medical records management for Aurora Memorial Hospital (AMH).

## Features

-   **Role-Based Access Control:** Separate dashboards and functionalities for Patients, Staff, Doctors, Admins, and Super Admins.
-   **Patient Portal:** Patients can register, book appointments, view their medical history, and manage relatives' profiles.
-   **Staff Portal:** Staff can manage appointments (assign doctors, reschedule), handle direct patient scheduling, and access patient records.
-   **Doctor Portal:** Doctors can view their assigned appointments, access patient medical histories, and mark appointments as complete.
-   **Admin Portal:** Admins can manage user accounts (create, archive, restore), view analytics, and generate reports.
-   **Super Admin Portal:** Full system oversight, including database backup and restore capabilities.
-   **Real-time Validations:** Interactive forms with client-side validation for a smooth user experience.
-   **Secure Authentication:** Features include password hashing, OTP verification for password changes, and protection against common web vulnerabilities.

## Technology Stack

-   **Backend:** Java, Jakarta Servlets, JSP
-   **Frontend:** HTML, CSS, JavaScript, Bootstrap 5
-   **Database:** MariaDB / MySQL
-   **Build Tool:** Apache Maven
-   **Server:** Apache Tomcat

---

## Setup and Installation Guide

Follow these steps to set up and run the project on your local machine.

### 1. Prerequisites

Make sure you have the following software installed:
-   **Java Development Kit (JDK):** Version 11 or higher.
-   **Apache Maven:** For building the project.
-   **MariaDB or MySQL:** As the database server.
-   **Apache Tomcat:** Version 10.x or higher as the web server.
-   **Git:** For cloning the repository.

### 2. Clone the Repository

Open your terminal or command prompt and run the following command:
```bash
git clone <your-repository-url>
cd OPD
```

### 3. Database Setup

1.  **Start your MariaDB/MySQL server.**
2.  Create a new database for the project. You can use a tool like phpMyAdmin or run the following SQL command:
    ```sql
    CREATE DATABASE opd_db;
    ```
3.  Import the database schema and data using the provided backup file. You can do this via the command line:
    ```bash
    mysql -u root -p opd_db < opd_db_backup_2025-12-02_15-09-58.sql
    ```
    *(You may be prompted for your database root password.)*

4.  **Configure the Database Connection:**
    -   Open the file `src/main/java/com/mycompany/opd/resources/DBUtil.java`.
    -   Update the `URL`, `USER`, and `PASSWORD` variables to match your database configuration.
    ```java
    private static final String URL = "jdbc:mysql://localhost:3306/opd_db";
    private static final String USER = "root"; // Your DB username
    private static final String PASSWORD = ""; // Your DB password
    ```

### 4. Build the Project

Navigate to the root directory of the project (where the `pom.xml` file is located) and run the following Maven command to build the project:

```bash
mvn clean install
```

This will compile the code and package it into a `.war` file located in the `target/` directory (e.g., `target/OPD-1.0-SNAPSHOT.war`).

### 5. Deploy to Tomcat

1.  **Start your Apache Tomcat server.**
2.  Copy the generated `.war` file from the `target/` directory into the `webapps/` directory of your Tomcat installation.
3.  Tomcat will automatically deploy the application.

### 6. Access the Application

Open your web browser and navigate to:

**`http://localhost:8080/OPD-1.0-SNAPSHOT/`**

*(Note: The context path `/OPD-1.0-SNAPSHOT/` may vary depending on your build configuration. You can rename the `.war` file to `OPD.war` before deploying to get a cleaner URL: `http://localhost:8080/OPD/`)*

---

## Default Admin Credentials

-   **Username:** `admin`
-   **Password:** `admin`

It is highly recommended to change the default password after your first login.

---

Happy coding!
