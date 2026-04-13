package com.mycompany.opd;

import com.mycompany.opd.resources.ConfigUtil;

import com.mycompany.opd.resources.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.mycompany.opd.resources.DBUtil;
import com.mycompany.opd.models.User;
import jakarta.servlet.ServletContext;
import java.io.FileInputStream;
import java.io.File;
import java.io.IOException;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.model.enums.EncryptionMethod;
import net.lingala.zip4j.model.enums.AesKeyStrength;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/BackupServlet")
public class BackupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String confirmationPassword = request.getParameter("confirmationPassword");

        // 1. Check if the user is logged in and is a Super Admin
        if (session == null || session.getAttribute("userId") == null || !"Super Admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Authentication failed. Please log in again.");
            return;
        }

        int loggedInUserId = (int) session.getAttribute("userId");

        if (confirmationPassword == null || confirmationPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=Password confirmation is required.");
            return;
        }

        // 2. Validate the provided password against the user's actual password hash from the database
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT password FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, loggedInUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String storedHashedPassword = rs.getString("password");
                        if (!PasswordUtil.verifyPassword(confirmationPassword, storedHashedPassword)) {
                            response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=Incorrect password. Please try again.");
                            return;
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=User not found.");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/backup_restore.jsp?error=Database error during password verification.");
            return;
        }

        // Database credentials - these should match your DBUtil.java
        String dbName = ConfigUtil.getProperty("db.name");
        String dbUser = ConfigUtil.getProperty("db.user");
        String dbPassword = ConfigUtil.getProperty("db.password");
        
        String mysqlDumpPath = ConfigUtil.getProperty("mysql.bin.path");
        if (mysqlDumpPath == null || mysqlDumpPath.trim().isEmpty()) {
            response.sendRedirect("backup_restore.jsp?error=Backup failed: MySQL binary path is not configured.");
            return;
        }

        File tempSqlFile = null;
        File tempZipFile = null;

        try {
            // Create a temporary file to store the SQL dump
            String timestamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss").format(new Date());
            String sqlFileName = "opd_db_backup_" + timestamp + ".sql";
            tempSqlFile = File.createTempFile("backup-", ".sql");

            // Prepare the mysqldump command
            List<String> command = new ArrayList<>();
            command.add(new File(mysqlDumpPath, "mysqldump").getCanonicalPath());
            command.add("-u" + dbUser);
            if (dbPassword != null && !dbPassword.isEmpty()) {
                command.add("-p" + dbPassword);
            }
            command.add("--result-file=" + tempSqlFile.getAbsolutePath());
            command.add(dbName);

            // Execute the command as a process
            ProcessBuilder processBuilder = new ProcessBuilder(command);
            Process process = processBuilder.start();
            int processComplete = process.waitFor();

            if (processComplete != 0) {
                // Capture and display the error stream for better debugging
                try (InputStream errorStream = process.getErrorStream()) {
                    String errorOutput = new String(errorStream.readAllBytes());
                    if (errorOutput.isEmpty()) {
                        throw new IOException("mysqldump process exited with error code: " + processComplete);
                    } else {
                        throw new IOException("mysqldump error: " + errorOutput);
                    }
                }
            }

            // Create a password-protected ZIP file
            String zipFileName = "opd_db_backup_" + timestamp + ".zip";
            tempZipFile = File.createTempFile("backup-", ".zip");

            ZipParameters zipParameters = new ZipParameters();
            zipParameters.setEncryptFiles(true);
            zipParameters.setEncryptionMethod(EncryptionMethod.AES);
            zipParameters.setAesKeyStrength(AesKeyStrength.KEY_STRENGTH_256);

            new ZipFile(tempZipFile, confirmationPassword.toCharArray()).addFile(tempSqlFile, zipParameters);

            // Set response headers for the ZIP file download
            response.setContentType("application/zip");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + zipFileName + "\"");
            response.setContentLength((int) tempZipFile.length());

            // Stream the ZIP file to the response
            try (FileInputStream fis = new FileInputStream(tempZipFile);
                 OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("backup_restore.jsp?error=Backup failed: " + e.getMessage());
        } finally {
            // Clean up temporary files
            if (tempSqlFile != null) tempSqlFile.delete();
            if (tempZipFile != null) tempZipFile.delete();
        }
    }
}