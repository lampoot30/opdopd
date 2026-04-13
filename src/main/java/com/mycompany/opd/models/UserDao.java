package com.mycompany.opd.models;

import com.mycompany.opd.models.User;
import com.mycompany.opd.models.UserProfile;
import com.mycompany.opd.resources.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDao {

    public boolean updatePatientProfile(User user, UserProfile profile) throws SQLException {
        String profileSql = "UPDATE user_profiles SET surname=?, given_name=?, middle_name=?, date_of_birth=?, gender=?, religion=?, permanent_address=?, current_address=?, city=?, postal_code=? WHERE user_id=?";
        String userSql = "UPDATE users SET contact_number=? WHERE user_id=?";

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Update user_profiles table
            try (PreparedStatement psProfile = conn.prepareStatement(profileSql)) {
                psProfile.setString(1, profile.getSurname());
                psProfile.setString(2, profile.getGivenName());
                psProfile.setString(3, profile.getMiddleName());
                psProfile.setDate(4, Date.valueOf(profile.getDateOfBirth()));
                psProfile.setString(5, profile.getGender());
                psProfile.setString(6, profile.getReligion());
                psProfile.setString(7, profile.getPermanentAddress());
                psProfile.setString(8, profile.getCurrentAddress());
                psProfile.setString(9, profile.getCity());
                psProfile.setString(10, profile.getPostalCode());
                psProfile.setInt(11, user.getUserId());
                psProfile.executeUpdate();
            }

            // 2. Update users table
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setString(1, user.getContactNumber());
                psUser.setInt(2, user.getUserId());
                psUser.executeUpdate();
            }

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e; // Re-throw the exception to be handled by the servlet
        } finally {
            if (conn != null) conn.close();
        }
    }
}