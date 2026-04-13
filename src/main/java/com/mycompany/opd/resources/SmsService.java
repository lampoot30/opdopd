package com.mycompany.opd.resources;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.List;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class SmsService {

    private static final String API_URL = "https://api.semaphore.co/api/v4/messages";
    private static String apiKey;
    private static String senderName;

    static {
        try (InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Sorry, unable to find config.properties");
            } else {
                prop.load(input);
                apiKey = prop.getProperty("semaphore.apikey");
                senderName = prop.getProperty("semaphore.sendername");
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public static boolean sendSms(String phoneNumber, String message) {
        if (apiKey == null || apiKey.isEmpty() || apiKey.equals("YOUR_SEMAPHORE_API_KEY")) {
            System.out.println("SMS not sent. Semaphore API key is not configured in config.properties.");
            return false;
        }

        try {
            HttpClient client = HttpClient.newHttpClient();

            StringBuilder bodyBuilder = new StringBuilder();
            bodyBuilder.append("apikey=").append(URLEncoder.encode(apiKey, StandardCharsets.UTF_8));
            bodyBuilder.append("&number=").append(URLEncoder.encode(phoneNumber, StandardCharsets.UTF_8));
            bodyBuilder.append("&message=").append(URLEncoder.encode(message, StandardCharsets.UTF_8));

            if (senderName != null && !senderName.isEmpty()) {
                bodyBuilder.append("&sendername=").append(URLEncoder.encode(senderName, StandardCharsets.UTF_8));
            }
            String body = bodyBuilder.toString();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // More detailed logging for debugging
            System.out.println("Semaphore API Response | Status: " + response.statusCode() + " | Body: " + response.body());

            return response.statusCode() == 200;

        } catch (IOException | InterruptedException e) {
            System.err.println("Error sending SMS to " + phoneNumber);
            e.printStackTrace();
            return false;
        }
    }

    public static void sendSmsToAdmins(String message) {
        List<String> adminNumbers = getAdminContactNumbers();
        if (adminNumbers.isEmpty()) {
            System.out.println("No admin contact numbers found to send SMS.");
            return;
        }

        System.out.println("Sending registration notification to " + adminNumbers.size() + " admin(s).");
        for (String number : adminNumbers) {
            sendSms(number, message);
        }
    }

    private static List<String> getAdminContactNumbers() {
        List<String> numbers = new ArrayList<>();
        // Fetches active Admins and Super Admins
        String sql = "SELECT contact_number FROM users WHERE (role = 'Admin' OR role = 'Super Admin') AND status = 'active' AND contact_number IS NOT NULL";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String contactNumber = rs.getString("contact_number");
                if (contactNumber != null && !contactNumber.trim().isEmpty()) {
                    numbers.add(contactNumber);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log error
        }
        return numbers;
    }
}