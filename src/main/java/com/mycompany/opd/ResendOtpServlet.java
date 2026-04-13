package com.mycompany.opd;

import com.mycompany.opd.resources.OtpService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/resend-otp")
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("application/json");

        // --- Universal Contact Number Retrieval ---
        String contactNumber = (String) session.getAttribute("newContactNumber");
        if (contactNumber == null) {
            contactNumber = (String) session.getAttribute("otpContactNumber");
        }
        if (contactNumber == null) {
            contactNumber = (String) session.getAttribute("contactForReset");
        }
        if (contactNumber == null && session.getAttribute("registrationData") != null) {
            @SuppressWarnings("unchecked")
            Map<String, Object> regData = (Map<String, Object>) session.getAttribute("registrationData");
            contactNumber = (String) regData.get("contactNumber");
        }

        if (session == null || contactNumber == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Your session is invalid. Please start over.\"}");
            return;
        }

        // --- OTP Rate Limiting ---
        Long lastOtpTime = (Long) session.getAttribute("lastOtpTime");
        long currentTime = System.currentTimeMillis();
        long fiveMinutesInMillis = 5 * 60 * 1000;

        if (lastOtpTime != null && (currentTime - lastOtpTime < fiveMinutesInMillis)) {
            long timeLeftSeconds = (fiveMinutesInMillis - (currentTime - lastOtpTime)) / 1000;
            String errorMessage = String.format("Please wait %d minutes and %d seconds before requesting a new OTP.", timeLeftSeconds / 60, timeLeftSeconds % 60);
            response.setStatus(429); // HTTP 429 Too Many Requests
            response.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
            return;
        }

        try {
            OtpService.generateAndSendOtp(session, contactNumber);
            session.setAttribute("lastOtpTime", currentTime); // Set the new timestamp
            response.getWriter().write("{\"success\": true, \"message\": \"A new OTP has been sent.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred while sending the OTP.\"}");
        }
    }
}