# TODO: Add Show Password Toggle to All Password Fields

## Files to Update:
- [x] src/main/webapp/login.jsp (1 password field)
- [x] src/main/webapp/reset_password.jsp (2 password fields: newPassword, confirmPassword)
- [x] src/main/webapp/register.jsp (2 password fields: password, confirmPassword)
- [x] src/main/webapp/patient_profile.jsp (3 password fields: oldPassword, newPassword, confirmNewPassword)
- [ ] src/main/webapp/edit_super_admin_profile.jsp (3 password fields: currentPassword, newPassword, confirmPassword)
- [x] src/main/webapp/edit_staff_profile.jsp (3 password fields: currentPassword, newPassword, confirmPassword)
- [x] src/main/webapp/edit_admin_profile.jsp (3 password fields: oldPassword, newPassword, confirmNewPassword)
- [ ] src/main/webapp/doctor_profile.jsp (3 password fields: oldPassword, newPassword, confirmNewPassword)

## Implementation Details:
- Wrap each password input in Bootstrap input-group
- Add eye icon button to toggle visibility
- Add JavaScript function to toggle input type between 'password' and 'text'
- Ensure consistent styling and functionality across all files
