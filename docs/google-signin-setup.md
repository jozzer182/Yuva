# Configuración de Google Sign-In para Yuva

Este documento describe cómo se configuró Google Sign-In en las aplicaciones Yuva.

## Resumen

Google Sign-In está habilitado para ambas aplicaciones Flutter (yuva_client y yuva_worker) usando Firebase Authentication.

---

## Configuración de Firebase

### Proyecto Firebase

- **Project ID:** `yuve-es`
- **Project Number:** `83359937854`

### OAuth Client ID

- **Client ID:** `83359937854-80tpcfe3gbcogb6e4oglnqn5cmq9hil4.apps.googleusercontent.com`
- **Client Type:** Web (tipo 3)

Este Client ID es compartido por ambas aplicaciones (yuva_client y yuva_worker).

---

## Dependencias Agregadas

Se agregó la siguiente dependencia en `pubspec.yaml` de ambas apps:

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.9.0
  firebase_auth: ^5.3.4
  google_sign_in: ^6.2.2
```

---

## Implementación

### 1. Auth Repository Interface

Se agregó el método `signInWithGoogle()` al repositorio de autenticación:

**`lib/data/repositories/auth_repository.dart`:**

```dart
abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password, String name);
  Future<User> signInWithGoogle();  // ← NUEVO
  Future<void> signOut();
  Future<User> continueAsGuest();  // Solo yuva_client
}
```

### 2. Firebase Auth Repository Implementation

**`lib/data/repositories/firebase_auth_repository.dart`:**

#### Constructor actualizado:

```dart
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;  // ← NUEVO

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,  // ← NUEVO
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
```

#### Método signInWithGoogle:

```dart
@override
Future<User> signInWithGoogle() async {
  try {
    // 1. Iniciar flujo de Google Sign-In
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Inicio de sesión con Google cancelado');
    }

    // 2. Obtener detalles de autenticación
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // 3. Crear credencial para Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 4. Iniciar sesión en Firebase con la credencial de Google
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.user == null) {
      throw Exception('Error al iniciar sesión con Google');
    }

    return _mapFirebaseUserToUser(userCredential.user!);
  } on FirebaseAuthException catch (e) {
    throw _mapFirebaseException(e);
  } catch (e) {
    throw 'Error al iniciar sesión con Google: ${e.toString()}';
  }
}
```

#### Método signOut actualizado:

```dart
@override
Future<void> signOut() async {
  await Future.wait([
    _firebaseAuth.signOut(),
    _googleSignIn.signOut(),  // ← Cerrar sesión de Google también
  ]);
}
```

### 3. UI - Login Screen

Se agregó un botón de Google Sign-In debajo del botón de login:

**`lib/features/auth/login_screen.dart`:**

#### Método del controlador:

```dart
Future<void> _handleGoogleSignIn() async {
  setState(() => _isLoading = true);

  try {
    final authRepo = ref.read(authRepositoryProvider);
    final user = await authRepo.signInWithGoogle();
    ref.read(currentUserProvider.notifier).state = user;

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

#### Botón en la UI:

```dart
// Divider con "O"
Row(
  children: [
    const Expanded(child: Divider()),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text('O', style: ...),
    ),
    const Expanded(child: Divider()),
  ],
),
const SizedBox(height: 24),

// Botón de Google Sign-In
SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: _isLoading ? null : _handleGoogleSignIn,
    icon: Image.network(
      'https://www.google.com/favicon.ico',
      height: 24,
      width: 24,
      errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.g_mobiledata, size: 24),
    ),
    label: const Text('Continuar con Google'),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: BorderSide(color: YuvaColors.textSecondary.withAlpha(77)),
    ),
  ),
),
```

---

## Flujo de Autenticación con Google

```
1. Usuario toca "Continuar con Google"
   ↓
2. Se abre el diálogo de selección de cuenta de Google
   ↓
3. Usuario selecciona o ingresa sus credenciales de Google
   ↓
4. Google devuelve tokens de acceso e ID
   ↓
5. Se crea una credencial de Firebase con los tokens
   ↓
6. Firebase autentica al usuario con la credencial
   ↓
7. Se mapea el FirebaseUser a nuestro modelo User
   ↓
8. AuthStateNotifier actualiza el estado
   ↓
9. Usuario es redirigido a /main
```

---

## Configuración de Android (SHA-1)

Para que Google Sign-In funcione en Android, **es necesario agregar el certificado SHA-1** al proyecto de Firebase.

### Obtener SHA-1 en desarrollo:

```bash
cd android
./gradlew signingReport
```

Buscar la línea que dice `SHA1:` en la sección `debug` y copiar el valor.

### Agregar SHA-1 a Firebase:

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar proyecto `yuve-es`
3. Ir a **Configuración del proyecto** > **Tus apps**
4. Seleccionar la app Android correspondiente
5. Hacer clic en **"Agregar huella digital"**
6. Pegar el SHA-1 y guardar

**Repetir para ambas apps:**

- `com.example.yuva` (yuva_client)
- `com.example.yuva_worker` (yuva_worker)

> **Nota:** Para producción, necesitarás obtener el SHA-1 del keystore de release.

---

## Verificación

### Verificar que todo esté configurado:

1. **Firebase Console:**

   - Ir a **Authentication** > **Sign-in method**
   - Google debe estar **habilitado** ✅

2. **Apps registradas:**

   - Verificar que ambas apps tengan sus SHA-1 configurados

3. **Código:**
   - Verificar que `google_sign_in` esté en `pubspec.yaml`
   - Verificar que `signInWithGoogle()` esté implementado en ambos repositorios
   - Verificar que el botón de Google aparezca en las pantallas de login

---

## Pruebas

### Probar Google Sign-In:

1. **En yuva_client:**

   ```bash
   cd yuva_client
   flutter run
   ```

   - Tocar "Continuar con Google"
   - Seleccionar cuenta de Google
   - Verificar que se inicie sesión correctamente

2. **En yuva_worker:**
   ```bash
   cd yuva_worker
   flutter run
   ```
   - Tocar "Continuar con Google"
   - Seleccionar cuenta de Google
   - Verificar que se inicie sesión correctamente

### Verificar cierre de sesión:

1. Iniciar sesión con Google
2. Navegar a perfil/configuración
3. Cerrar sesión
4. Verificar que el usuario sea redirigido al login
5. Verificar que volver a tocar "Continuar con Google" muestre el selector de cuentas

---

## Errores Comunes

### 1. "API_NOT_CONNECTED" o "DEVELOPER_ERROR"

**Causa:** SHA-1 no configurado o incorrecto en Firebase.

**Solución:**

1. Obtener SHA-1 correcto con `./gradlew signingReport`
2. Agregarlo en Firebase Console para la app correspondiente
3. Descargar el nuevo `google-services.json`
4. Reemplazarlo en `android/app/google-services.json`
5. Ejecutar `flutter clean && flutter run`

### 2. "PlatformException(sign_in_failed)"

**Causa:** OAuth Client ID no configurado correctamente.

**Solución:**

1. Verificar en Firebase Console > Authentication > Sign-in method > Google
2. Verificar que el Web Client ID esté presente
3. Volver a ejecutar `flutterfire configure`

### 3. Usuario cancela el login

**Esperado:** Se muestra mensaje "Inicio de sesión con Google cancelado"

No es un error - el usuario simplemente cerró el diálogo.

### 4. En iOS no funciona

**Causa:** Falta configurar el URL Scheme en iOS.

**Solución:**

1. Abrir `ios/Runner/Info.plist`
2. Agregar el reversed Client ID como URL scheme
3. Ver documentación de FlutterFire para iOS

---

## Seguridad

### Datos obtenidos de Google:

- **ID único** (Firebase UID)
- **Nombre completo**
- **Email**
- **Foto de perfil** (URL)

### Permisos:

Google Sign-In solicita permisos básicos de perfil:

- Nombre
- Email
- Foto de perfil

**No** se solicitan permisos adicionales como acceso a Drive, Calendar, etc.

### Tokens:

- Los tokens de Google son manejados automáticamente por Firebase
- No se almacenan en la app
- Se refrescan automáticamente cuando expiran

---

## Próximos Pasos

- [ ] Agregar SHA-1 de certificado de release para producción
- [ ] Configurar Google Sign-In para iOS (si se implementa)
- [ ] Agregar más opciones de login social (Apple, Facebook)
- [ ] Implementar vinculación de cuentas (link email con Google)
- [ ] Agregar opción de desconectar cuenta de Google

---

## Referencias

- [FlutterFire Auth - Google Sign-In](https://firebase.flutter.dev/docs/auth/social/#google)
- [Google Sign-In Flutter Package](https://pub.dev/packages/google_sign_in)
- [Firebase Console](https://console.firebase.google.com/)

---

**Última actualización:** 21 de noviembre, 2025  
**Configurado por:** GitHub Copilot  
**Estado:** ✅ Implementado y listo para pruebas
