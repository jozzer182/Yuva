# Verificación de Email - Guía de Implementación

## 📧 Resumen

Se ha implementado la verificación de correo electrónico obligatoria para ambas aplicaciones (yuva_client y yuva_worker). Los usuarios deben verificar su email antes de poder acceder a la aplicación.

## 🔄 Flujo de Verificación

### 1. Registro (Sign Up)

- Usuario completa el formulario de registro
- Firebase crea la cuenta
- **Se envía automáticamente un email de verificación**
- Usuario es redirigido a `EmailVerificationScreen`

### 2. Inicio de Sesión (Login)

- Usuario ingresa email y contraseña
- Firebase autentica las credenciales
- **Se verifica si el email está confirmado**
- Si NO está verificado → redirige a `EmailVerificationScreen`
- Si SÍ está verificado → accede a la app

### 3. Google Sign-In

- **No requiere verificación** (Google ya verifica los emails)
- Acceso directo a la aplicación

### 4. Modo Invitado

- **No requiere verificación** (no hay email asociado)
- Acceso directo a la aplicación

## 📱 Pantalla de Verificación

### Características:

✅ **Verificación automática** cada 3 segundos
✅ **Botón de reenvío** con cuenta regresiva de 15 minutos
✅ **Instrucciones claras** paso a paso
✅ **Botón de cerrar sesión** para cambiar de cuenta

### Componentes:

```dart
EmailVerificationScreen
├── Timer de verificación (cada 3 segundos)
├── Timer de cuenta regresiva (15 minutos)
├── Botón "Reenviar correo"
├── Botón "Cerrar sesión"
└── Instrucciones visuales
```

## 🔧 Archivos Modificados

### yuva_client y yuva_worker:

1. **email_verification_screen.dart** (NUEVO)

   - Pantalla de espera de verificación
   - Timers y lógica de reenvío

2. **signup_screen.dart** (MODIFICADO)

   - Redirige a EmailVerificationScreen después del registro

3. **login_screen.dart** (MODIFICADO)
   - Verifica el estado del email al iniciar sesión
   - Redirige a EmailVerificationScreen si no está verificado

## ⏱️ Cuenta Regresiva

### Formato: MM:SS

- Tiempo inicial: **15:00** (15 minutos)
- Se actualiza cada segundo
- Al llegar a **00:00**, el botón se habilita nuevamente

### Código:

```dart
String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
```

## 🔐 Seguridad

### Protección contra spam:

- Cuenta regresiva de 15 minutos entre envíos
- Firebase limita el número de emails enviados
- Error específico si hay demasiados intentos: `too-many-requests`

## 🧪 Flujo de Prueba

### Caso 1: Registro nuevo

1. Crea una cuenta nueva
2. Verás la pantalla de verificación automáticamente
3. Revisa tu email (incluyendo spam)
4. Haz clic en el enlace de verificación
5. La app detectará automáticamente la verificación (máximo 3 segundos)
6. Serás redirigido a la pantalla principal

### Caso 2: Login sin verificar

1. Cierra sesión
2. Intenta iniciar sesión con credenciales no verificadas
3. Verás la pantalla de verificación
4. Sigue el mismo proceso anterior

### Caso 3: Reenvío de email

1. En la pantalla de verificación
2. Espera a que la cuenta regresiva llegue a 00:00
3. Presiona "Reenviar correo"
4. Se enviará un nuevo email
5. La cuenta regresiva se reinicia a 15:00

## 📝 Mensajes al Usuario

### Email enviado:

```
Correo de verificación enviado
```

### Demasiados intentos:

```
Demasiados intentos. Espera unos minutos.
```

### Verificando:

```
Verificando...
```

### Nota sobre spam:

```
¿No ves el correo? Revisa tu carpeta de spam o correo no deseado.
```

## 🎨 UI/UX

### Elementos visuales:

- 📧 Icono grande de email
- 🔵 Color primario en acentos
- ⏲️ Contador visible en el botón
- ℹ️ Instrucciones paso a paso numeradas
- 🔄 Indicador de "Verificando..." cuando chequea

## 🚀 Próximos Pasos

Si necesitas personalizar:

- **Tiempo de cuenta regresiva**: Cambiar `_remainingSeconds = 900` (línea 21)
- **Intervalo de verificación**: Cambiar `Duration(seconds: 3)` (línea 95)
- **Textos**: Editar los strings directamente en el widget

## ⚠️ Notas Importantes

1. Los usuarios de **Google Sign-In** NO necesitan verificación
2. Los **invitados** NO necesitan verificación
3. El email de verificación viene de **Firebase Authentication**
4. El enlace de verificación **expira después de cierto tiempo** (configurado en Firebase)
5. La verificación se detecta **automáticamente** sin necesidad de presionar nada
