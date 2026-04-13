package com.mycompany.opd.resources;

import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.time.Instant;

public class OtpService {

    private static final int OTP_EXPIRY_MINUTES = 5;

    public static String generateAndSendOtp(HttpSession session, String newContactNumber) {
        String otp = new SecureRandom().ints(100000, 1000000)
                                     .findFirst()
                                     .getAsInt() + "";

        session.setAttribute("otp", otp);
        session.setAttribute("otpExpiry", Instant.now().plusSeconds(OTP_EXPIRY_MINUTES * 60));
        session.setAttribute("newContactNumber", newContactNumber);

        String message = "Your OPD verification code is: " + otp + ". It will expire in " + OTP_EXPIRY_MINUTES + " minutes.";
        SmsService.sendSms(newContactNumber, message);

        return otp; // Returning for potential logging or debugging
    }

    public static boolean verifyOtp(HttpSession session, String submittedOtp) {
        String storedOtp = (String) session.getAttribute("otp");
        Instant expiry = (Instant) session.getAttribute("otpExpiry");
        
        boolean isValid = submittedOtp != null && submittedOtp.equals(storedOtp) && expiry != null && Instant.now().isBefore(expiry);
        if (isValid) {
            // Security best practice: remove OTP after successful verification to prevent reuse.
            session.removeAttribute("otp");
        }
        return isValid;
    }
}