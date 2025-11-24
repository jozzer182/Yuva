# Guía de Configuración de Autenticación Multi-Factor (MFA)

## Estado Actual

✅ **Completado:**

- MFA habilitado en Firebase Console
- Métodos MFA implementados en `FirebaseAuthRepository` para ambas apps
- Interfaces de repositorio actualizadas con métodos MFA

⚠️ **Limitación Actual:**

- firebase_auth 5.7.0 tiene API limitada para MFA
- Los métodos `isMultiFactorUser()` y `unenrollMFA()` requieren actualización a firebase_auth 6.0+
- Por ahora, estas funciones tienen implementaciones simplificadas

🔄 **Pendiente:**

- Crear UI para configurar MFA (pantalla de ajustes)
- Crear UI para verificar código MFA durante login
- Actualizar `login_screen.dart` para manejar excepciones MFA
- Agregar certificado SHA-1 en Firebase Console
- Testing end-to-end del flujo MFA

## Métodos MFA Implementados

### 1. enrollMFA(String phoneNumber)

**Propósito:** Iniciar el proceso de inscripción MFA con un número de teléfono

**Flujo:**

1. Verifica que el usuario esté autenticado
2. Crea una sesión de MFA
3. Envía código SMS al número proporcionado
4. El `verificationId` debe guardarse en el UI para usarlo en `verifyMFAEnrollment`

**Uso en UI:**

```dart
try {
  await ref.read(authRepositoryProvider).enrollMFA('+1234567890');
  // Mostrar pantalla para ingresar código SMS
} catch (e) {
  // Mostrar error
}
```

### 2. verifyMFAEnrollment(String verificationId, String smsCode)

**Propósito:** Completar la inscripción MFA verificando el código SMS

**Parámetros:**

- `verificationId`: ID recibido en el callback `codeSent` de `enrollMFA`
- `smsCode`: Código de 6 dígitos que el usuario recibió por SMS

**Retorna:** Mensaje de éxito

**Uso en UI:**

```dart
try {
  final message = await ref.read(authRepositoryProvider)
    .verifyMFAEnrollment(verificationId, '123456');
  // Mostrar mensaje de éxito
  // Regresar a pantalla de ajustes
} catch (e) {
  // Mostrar error (código inválido, etc.)
}
```

### 3. verifyMFASignIn(String verificationId, String smsCode, dynamic resolver)

**Propósito:** Verificar código MFA durante el inicio de sesión

**Cuándo se usa:** Cuando `signInWithEmail` o `signInWithGoogle` lanza `FirebaseAuthMultiFactorException`

**Flujo:**

1. Usuario intenta login con email/password o Google
2. Firebase detecta MFA habilitado
3. Lanza `FirebaseAuthMultiFactorException` con un `MultiFactorResolver`
4. App muestra pantalla para código SMS
5. Usuario ingresa código
6. Se llama `verifyMFASignIn` con el resolver de la excepción

**Uso en UI:**

```dart
try {
  await ref.read(authRepositoryProvider)
    .signInWithEmail(email, password);
} on firebase_auth.FirebaseAuthMultiFactorException catch (e) {
  // Guardar e.resolver para usarlo después
  final resolver = e.resolver;
  // Enviar código SMS automáticamente
  await _sendMFACode(resolver);
  // Mostrar pantalla de verificación MFA
  final code = await showMFACodeDialog();
  final user = await ref.read(authRepositoryProvider)
    .verifyMFASignIn(verificationId, code, resolver);
  // Login exitoso
}
```

### 4. isMultiFactorUser()

**Propósito:** Verificar si el usuario actual tiene MFA configurado

**Retorna:** `bool` - true si MFA está habilitado

**Limitación:** En firebase_auth 5.7.0, esta implementación es simplificada

**Uso en UI:**

```dart
final hasMFA = ref.read(authRepositoryProvider).isMultiFactorUser();
// Mostrar toggle en ajustes: "MFA: Activo" vs "MFA: Inactivo"
```

### 5. unenrollMFA(String factorUid)

**Propósito:** Desactivar MFA para el usuario

**Limitación:** Requiere firebase_auth >= 6.0.0 para funcionalidad completa

**Estado Actual:** Lanza `UnimplementedError` con mensaje de actualización necesaria

## Flujo Completo de MFA

### A. Configurar MFA (Primera vez)

```
1. Usuario autenticado va a Ajustes → Seguridad
2. Ve opción "Autenticación de dos factores" (desactivada)
3. Toca para activar
4. Pantalla solicita número de teléfono: +52 XXX XXX XXXX
5. Usuario ingresa número y confirma
6. App llama enrollMFA(phoneNumber)
7. Usuario recibe SMS con código
8. Pantalla solicita código de 6 dígitos
9. Usuario ingresa código
10. App llama verifyMFAEnrollment(verificationId, code)
11. Mensaje: "Autenticación de dos factores configurada exitosamente"
12. Regresa a Ajustes (ahora muestra MFA como activo)
```

### B. Login con MFA Habilitado

```
1. Usuario ingresa email/password o usa Google Sign-In
2. Firebase detecta MFA configurado
3. Se lanza FirebaseAuthMultiFactorException
4. App captura la excepción y obtiene resolver
5. Muestra pantalla: "Verifica tu identidad - Código SMS enviado"
6. Usuario ingresa código de 6 dígitos
7. App llama verifyMFASignIn(verificationId, code, resolver)
8. Login exitoso → navega a home
```

## Configuración Requerida en Firebase Console

### 1. Habilitar MFA (✅ Completado)

- Ir a Authentication → Settings → Multi-factor authentication
- Click "Enable"
- Seleccionar SMS como método

### 2. Agregar Certificado SHA-1

**Certificado obtenido:**

```
DC:85:09:8B:2D:84:7A:56:CC:E1:42:3A:D6:02:41:94:97:68:89:F8
```

**Pasos:**

1. Ir a Project Settings
2. Seleccionar app Android (yuva_client o yuva_worker)
3. Scroll a "SHA certificate fingerprints"
4. Click "Add fingerprint"
5. Pegar: `DC:85:09:8B:2D:84:7A:56:CC:E1:42:3A:D6:02:41:94:97:68:89:F8`
6. Repetir para la otra app si es necesario

### 3. Descargar google-services.json Actualizado

Después de agregar SHA-1, descargar nuevo `google-services.json` y reemplazar en:

- `yuva_client/android/app/google-services.json`
- `yuva_worker/android/app/google-services.json`

## Próximos Pasos de Implementación

### Paso 1: Crear MFA Enrollment Screen

Crear `lib/features/settings/mfa_enrollment_screen.dart`:

```dart
// Pantalla para configurar MFA
// - Input de número de teléfono con formato +52 XXX XXX XXXX
// - Botón "Enviar código"
// - Input de código SMS de 6 dígitos
// - Botón "Verificar"
// - Loading states
// - Manejo de errores
```

### Paso 2: Crear MFA Verification Screen

Crear `lib/features/auth/mfa_verification_screen.dart`:

```dart
// Pantalla mostrada durante login cuando MFA está activo
// - Mensaje: "Ingresa el código enviado a tu teléfono"
// - Input de 6 dígitos con auto-focus
// - Timer de reenvío (60 segundos)
// - Botón "Reenviar código"
// - Loading state
```

### Paso 3: Actualizar Login Screen

Modificar `lib/features/auth/login_screen.dart`:

```dart
Future<void> _handleLogin() async {
  try {
    await ref.read(authNotifierProvider.notifier)
      .signInWithEmail(_emailController.text, _passwordController.text);
    // Login exitoso
  } on firebase_auth.FirebaseAuthMultiFactorException catch (e) {
    // MFA requerido
    final resolver = e.resolver;

    // Enviar código SMS automáticamente
    final hint = resolver.hints.first as firebase_auth.PhoneMultiFactorInfo;
    await firebase_auth.FirebaseAuth.instance.verifyPhoneNumber(
      multiFactorSession: resolver.session,
      multiFactorInfo: hint,
      verificationCompleted: (_) {},
      verificationFailed: (e) => showError(e.message),
      codeSent: (verificationId, _) {
        // Navegar a MFA verification screen
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => MFAVerificationScreen(
            verificationId: verificationId,
            resolver: resolver,
          ),
        ));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  } catch (e) {
    showError(e.toString());
  }
}
```

### Paso 4: Agregar Settings Screen

Crear `lib/features/settings/settings_screen.dart`:

```dart
// Pantalla de ajustes con sección de seguridad
// - Switch "Autenticación de dos factores"
// - Mostrar número de teléfono si MFA activo
// - Opción para cambiar número
// - Opción para desactivar (si firebase_auth >= 6.0)
```

### Paso 5: Testing

**Test de Inscripción:**

1. Login con email/password
2. Ir a Ajustes → Seguridad
3. Activar MFA
4. Ingresar número de teléfono válido
5. Verificar que llega SMS
6. Ingresar código correcto
7. Verificar mensaje de éxito

**Test de Login con MFA:**

1. Cerrar sesión
2. Login con mismo email/password
3. Verificar que pide código SMS
4. Ingresar código correcto
5. Verificar acceso a app

**Test de Errores:**

1. Código SMS incorrecto → mensaje de error
2. Código expirado → opción de reenviar
3. Número inválido → validación antes de enviar

## Actualización a Firebase Auth 6.0+ (Recomendado)

Para funcionalidad completa de MFA:

1. Actualizar `pubspec.yaml`:

```yaml
firebase_auth: ^6.0.0
google_sign_in: ^7.0.0
```

2. Ejecutar:

```bash
flutter pub upgrade
```

3. Actualizar código que use Google Sign-In (API cambió en v7.0.0)

4. Habilitar implementación completa de `isMultiFactorUser()` y `unenrollMFA()`

## Errores Comunes y Soluciones

### "invalid-phone-number"

- Verificar formato: debe incluir código de país (+52 para México)
- Usar librería `intl_phone_number_input` para validación

### "code-expired"

- Códigos expiran en 5 minutos
- Implementar botón "Reenviar código"

### "invalid-verification-code"

- Usuario ingresó código incorrecto
- Mostrar error y permitir reintentar
- Después de 3 intentos, sugerir reenviar código

### "too-many-requests"

- Firebase bloqueó temporalmente por demasiados intentos
- Mostrar mensaje: "Espera unos minutos antes de intentar de nuevo"

## Referencias

- [Firebase Auth MFA Documentation](https://firebase.google.com/docs/auth/flutter/multi-factor)
- [Phone Number Verification](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [MultiFactorResolver API](https://pub.dev/documentation/firebase_auth/latest/firebase_auth/MultiFactorResolver-class.html)
