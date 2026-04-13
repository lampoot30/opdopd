package com.mycompany.opd;

import com.mycompany.opd.models.UserDao;
import com.mycompany.opd.models.User;
import com.mycompany.opd.models.UserProfile; // Assuming UserProfile will be in this package
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet(name = "UpdatePatientProfileServlet", urlPatterns = {"/update_patient_profile"})
public class UpdatePatientProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login first.");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"Patient".equals(currentUser.getUserType())) {
            response.sendRedirect("login.jsp?error=Unauthorized access.");
            return;
        }

        try {
            // 1. Retrieve form data
            String surname = request.getParameter("surname");
            String givenName = request.getParameter("given_name");
            String middleName = request.getParameter("middle_name");
            String dateOfBirth = request.getParameter("date_of_birth");
            String gender = request.getParameter("gender");
            String religion = request.getParameter("religion");
            String permanentAddress = request.getParameter("permanent_address");
            String currentAddress = request.getParameter("current_address");
            String city = request.getParameter("city");
            String postalCode = request.getParameter("postal_code");
            String contactNumber = request.getParameter("contact_number");

            // Server-side validation for date of birth
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                try {
                    LocalDate dob = LocalDate.parse(dateOfBirth);
                    if (dob.isAfter(LocalDate.now())) {
                        session.setAttribute("errorMessage", "Date of birth cannot be in the future.");
                        response.sendRedirect("patient_profile.jsp");
                        return;
                    }
                } catch (DateTimeParseException e) {
                    session.setAttribute("errorMessage", "Invalid date format for date of birth.");
                    response.sendRedirect("patient_profile.jsp");
                    return;
                }
            }
            // 2. Server-side validation
            try {
                LocalDate dob = LocalDate.parse(dateOfBirth);
                if (dob.isAfter(LocalDate.now())) {
                    session.setAttribute("errorMessage", "Date of birth cannot be in the future.");
                    response.sendRedirect("patient_profile.jsp");
                    return;
                }
            } catch (DateTimeParseException e) {
                session.setAttribute("errorMessage", "Invalid date format for date of birth.");
                response.sendRedirect("patient_profile.jsp");
                return;
            }
            // 2. Populate UserProfile and User objects
            UserProfile profile = new UserProfile();
            profile.setUserId(currentUser.getUserId());
            profile.setSurname(surname);
            profile.setGivenName(givenName);
            profile.setMiddleName(middleName);
            profile.setDateOfBirth(dateOfBirth);
            profile.setGender(gender);
            profile.setReligion(religion);
            profile.setPermanentAddress(permanentAddress);
            profile.setCurrentAddress(currentAddress);
            profile.setCity(city);
            profile.setPostalCode(postalCode);

            User userToUpdate = new User();
            userToUpdate.setUserId(currentUser.getUserId());
            userToUpdate.setContactNumber(contactNumber);

            // 3. Perform the update via DAO
            UserDao userDao = new UserDao();
            boolean isSuccess = userDao.updatePatientProfile(userToUpdate, profile);

            // 4. Redirect with feedback
            if (isSuccess) {
                // Update the user object in the session with the new contact number
                currentUser.setContactNumber(contactNumber);
                session.setAttribute("user", currentUser);
                
                // Also update the profile in the session if it's stored there
                session.setAttribute("userProfile", profile);

                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }

        } catch (SQLException e) {
            // Log the exception
            e.printStackTrace();
            session.setAttribute("errorMessage", "A database error occurred. Please try again later.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred.");
        }

        response.sendRedirect("patient_profile.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Handles patient profile updates.";
    }
}