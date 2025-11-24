# Firebase Authentication Testing Checklist

This document provides a comprehensive testing checklist for Firebase Authentication in both Yuva Flutter apps.

## CLIENT APP (yuva_client)

### Registration Flow

- [ ] New client can register with email/password
- [ ] Registration validates:
  - [ ] Name is not empty
  - [ ] Email format is valid
  - [ ] Password is at least 6 characters
- [ ] Duplicate email shows error: "Ya existe una cuenta con este correo electrónico"
- [ ] Weak password shows error: "La contraseña debe tener al menos 6 caracteres"
- [ ] Invalid email shows error: "El correo electrónico no es válido"
- [ ] Successful registration redirects to main navigation screen
- [ ] User display name is updated after registration

### Login Flow

- [ ] Existing client can log in with email/password
- [ ] Wrong credentials show error message:
  - [ ] Wrong password: "Contraseña incorrecta"
  - [ ] Non-existent email: "No existe una cuenta con este correo electrónico"
- [ ] Empty fields show validation errors
- [ ] Loading indicator appears during authentication
- [ ] Button is disabled while loading
- [ ] Successful login redirects to main navigation screen

### Guest Access

- [ ] "Continue as Guest" button works
- [ ] Guest users are authenticated anonymously
- [ ] Guest users can access the app
- [ ] Guest session persists across app restarts (until logout)

### Session Management

- [ ] Logged-in client stays logged in after app restart
- [ ] Auth state is preserved correctly
- [ ] Logout returns to the login screen
- [ ] After logout, user cannot access protected screens
- [ ] Auth state changes are reflected immediately in UI

### Navigation & Protected Routes

- [ ] Unauthenticated users cannot access /main
- [ ] Authenticated users skip login screen on app launch
- [ ] Navigation between /login and /signup works correctly
- [ ] Back button behavior is correct (no back to login after auth)

### Error Handling

- [ ] Network errors show: "Error de conexión. Verifica tu internet"
- [ ] Too many attempts show: "Demasiados intentos. Por favor, intenta más tarde"
- [ ] Disabled accounts show: "Esta cuenta ha sido deshabilitada"
- [ ] Errors display in red SnackBar
- [ ] Error messages are in Spanish
- [ ] Errors clear when user tries again

---

## WORKER APP (yuva_worker)

### Registration Flow

- [ ] New worker can register with email/password
- [ ] Registration validates:
  - [ ] Name is not empty
  - [ ] Email format is valid
  - [ ] Password is at least 6 characters
- [ ] Duplicate email shows error: "Ya existe una cuenta con este correo electrónico"
- [ ] Weak password shows error: "La contraseña debe tener al menos 6 caracteres"
- [ ] Invalid email shows error: "El correo electrónico no es válido"
- [ ] Successful registration redirects to main navigation screen
- [ ] User display name is updated after registration

### Login Flow

- [ ] Existing worker can log in with email/password
- [ ] Wrong credentials show clear error message:
  - [ ] Wrong password: "Contraseña incorrecta"
  - [ ] Non-existent email: "No existe una cuenta con este correo electrónico"
- [ ] Empty fields show validation errors
- [ ] Loading indicator appears during authentication
- [ ] Button is disabled while loading
- [ ] Successful login shows worker dashboard

### Session Management

- [ ] Logged-in worker stays logged in after app restart
- [ ] Auth state is preserved correctly
- [ ] Logout returns to the login screen
- [ ] After logout, worker cannot access protected screens
- [ ] Auth state changes are reflected immediately in UI

### Navigation & Protected Routes

- [ ] Unauthenticated workers cannot access /main
- [ ] Authenticated workers skip login screen on app launch
- [ ] Navigation between /login and /signup works correctly
- [ ] Back button behavior is correct (no back to login after auth)

### Error Handling

- [ ] Network errors show: "Error de conexión. Verifica tu internet"
- [ ] Too many attempts show: "Demasiados intentos. Por favor, intenta más tarde"
- [ ] Disabled accounts show: "Esta cuenta ha sido deshabilitada"
- [ ] Errors display in red SnackBar
- [ ] Error messages are in Spanish
- [ ] Errors clear when user tries again

---

## CROSS-APP TESTS

### Firebase Project Configuration

- [ ] Both apps use the same Firebase project (yuve-es)
- [ ] Each app has its own Firebase Android app registration
- [ ] Package names are correct:
  - [ ] yuva_client: com.example.yuva
  - [ ] yuva_worker: com.example.yuva_worker
- [ ] firebase_options.dart files are present in both apps
- [ ] Firebase is initialized correctly in main.dart for both apps

### Account Isolation

- [ ] Client account and worker account are separate
- [ ] Same email can be used in both apps (different Firebase apps)
- [ ] Logging in one app doesn't affect the other
- [ ] Auth states are independent between apps

### Security

- [ ] Passwords are not visible when typing
- [ ] Auth tokens are managed securely by Firebase
- [ ] No sensitive data is logged to console
- [ ] Email addresses are trimmed before authentication

---

## MANUAL TESTING STEPS

### Test New User Registration (Client App)

1. Open yuva_client app
2. Tap "Sign Up"
3. Enter name: "Test Client"
4. Enter email: "testclient@example.com"
5. Enter password: "password123"
6. Tap "Sign Up" button
7. ✅ Should redirect to main screen
8. ✅ Should stay logged in after app restart

### Test Existing User Login (Client App)

1. Open yuva_client app
2. Enter email: "testclient@example.com"
3. Enter password: "password123"
4. Tap "Login" button
5. ✅ Should redirect to main screen

### Test Wrong Password (Client App)

1. Open yuva_client app
2. Enter email: "testclient@example.com"
3. Enter password: "wrongpassword"
4. Tap "Login" button
5. ✅ Should show error: "Contraseña incorrecta"

### Test New User Registration (Worker App)

1. Open yuva_worker app
2. Tap "Sign Up"
3. Enter name: "Test Worker"
4. Enter email: "testworker@example.com"
5. Enter password: "password123"
6. Tap "Sign Up" button
7. ✅ Should redirect to main screen
8. ✅ Should stay logged in after app restart

### Test Logout

1. Log in to either app
2. Navigate to profile/settings
3. Tap "Logout" (when implemented)
4. ✅ Should return to login screen
5. ✅ Opening app again should show login screen

---

## NOTES

- This checklist assumes Firebase Authentication is properly configured
- Email verification is NOT yet implemented
- Password reset is NOT yet implemented (to be added later)
- Phone authentication is NOT yet implemented
- Social authentication (Google, Apple) is NOT yet implemented
- The worker app currently allows self-registration (may need admin approval in future)
