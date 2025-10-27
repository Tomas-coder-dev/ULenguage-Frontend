# 🔧 API Configuration - ULenguage

Esta carpeta contiene toda la configuración centralizada para el backend de ULenguage.

## 📁 Archivos

### `api_config.dart`
Configuración principal de la API, endpoints y constantes del sistema.

**Características:**
- ✅ Gestión de entornos (development/production)
- ✅ Detección automática de plataforma (Android/iOS)
- ✅ Endpoints tipados y centralizados
- ✅ Headers comunes y autenticados
- ✅ Constantes para almacenamiento local
- ✅ Validación de tokens JWT
- ✅ Google OAuth configuración

### `app_config.dart` ⚠️ DEPRECATED
Archivo antiguo que será reemplazado por `api_config.dart`. 

**No usar en código nuevo.** Ver [Migración](#migración) más abajo.

### `SECURITY_GUIDE.md`
Guía completa de seguridad, autenticación y almacenamiento.

Incluye:
- Manejo de tokens JWT
- Google OAuth en producción
- Almacenamiento seguro vs básico
- Estrategias de caché
- Mejores prácticas de seguridad

---

## 🚀 Uso Rápido

### 1. Configurar Entorno

```dart
// En api_config.dart, cambiar esta línea:

// Para desarrollo local
static const Environment currentEnvironment = Environment.development;

// Para producción (AWS)
static const Environment currentEnvironment = Environment.production;
```

### 2. Usar Endpoints

```dart
import '../config/api_config.dart';

// Obtener URL de login
final loginUrl = ApiConfig.authLogin;

// Hacer petición con headers comunes
final response = await http.get(
  Uri.parse(ApiConfig.culturalContent),
  headers: ApiConfig.commonHeaders,
);

// Petición autenticada
final token = await SecureStorageService.getToken();
final response = await http.get(
  Uri.parse(ApiConfig.authProfile),
  headers: ApiConfig.authHeaders(token!),
);
```

### 3. Almacenamiento Seguro

```dart
import '../services/secure_storage_service.dart';

// Guardar token (datos sensibles)
await SecureStorageService.saveToken('jwt_token_here');

// Obtener token
final token = await SecureStorageService.getToken();

// Verificar autenticación
final isAuth = await SecureStorageService.isAuthenticated();
```

### 4. Caché de Contenido

```dart
import '../services/cache_service.dart';

// Guardar contenido en caché
await CacheService.saveCachedContent(culturalData);

// Verificar si el caché está vigente
final isExpired = await CacheService.isCacheExpired();

// Obtener contenido del caché
final content = await CacheService.getCachedContent();
```

---

## 🔄 Migración desde `app_config.dart`

Si tienes código usando el antiguo `app_config.dart`, sigue estos pasos:

### Antes:
```dart
import '../config/app_config.dart';

final url = '${AppConfig.baseUrl}/auth/login';
final headers = {'Content-Type': 'application/json'};
```

### Después:
```dart
import '../config/api_config.dart';

final url = ApiConfig.authLogin;
final headers = ApiConfig.commonHeaders;
```

### Tabla de Migración

| app_config.dart | api_config.dart |
|----------------|-----------------|
| `AppConfig.baseUrl` | `ApiConfig.baseUrl` |
| `AppConfig.authUrl` | `ApiConfig.authLogin` / `authRegister` |
| `AppConfig.ocrUrl` | `ApiConfig.ocrAnalyze` |
| `AppConfig.translateUrl` | `ApiConfig.translate` |
| `AppConfig.googleClientId` | `ApiConfig.googleClientId` |
| `AppConfig.requestTimeout` | `ApiConfig.requestTimeout` |
| `AppConfig.userTokenKey` | `ApiConfig.userTokenKey` |

---

## 📚 Endpoints Disponibles

### Autenticación
- `ApiConfig.authLogin` → `/api/auth/login`
- `ApiConfig.authRegister` → `/api/auth/register`
- `ApiConfig.authProfile` → `/api/auth/profile`

### Traducción
- `ApiConfig.translate` → `/api/translate`

### OCR
- `ApiConfig.ocrAnalyze` → `/api/ocr/analyze`

### Exploración
- `ApiConfig.explorer` → `/api/explorer`
- `ApiConfig.explorerSearch('query')` → `/api/explorer?query=...`

### Contenido Cultural
- `ApiConfig.culturalContent` → `/api/content`
- `ApiConfig.culturalContentById('id')` → `/api/content/id`

### Logros
- `ApiConfig.achievements` → `/api/achievements`

---

## 🔑 Constantes de Almacenamiento

### Autenticación
- `userTokenKey` → Token JWT
- `refreshTokenKey` → Refresh token
- `userDataKey` → Datos del usuario (JSON)
- `userEmailKey` → Email del usuario
- `isLoggedInKey` → Estado de sesión

### Preferencias
- `userLocaleKey` → Idioma seleccionado (es/en/qu)
- `themeModeKey` → Modo de tema (light/dark)
- `notificationsEnabledKey` → Notificaciones habilitadas

### Caché
- `cachedContentKey` → Contenido cultural en caché
- `lastSyncDateKey` → Fecha de última sincronización
- `offlineModeKey` → Modo offline activado

### Onboarding
- `hasSeenOnboardingKey` → Usuario vio el tutorial
- `firstLaunchKey` → Primer lanzamiento de la app

---

## 🛠️ Utilidades

### Debugging

```dart
// Imprimir configuración actual
ApiConfig.printConfig();

// Output:
// ====================================
// 🦙 ULenguage API Configuration
// ====================================
// Environment: Environment.production
// Platform: android
// Base URL: http://15.228.188.14:5000
// Timeout: 0:00:30.000000
// ====================================
```

### Validar Token JWT

```dart
final token = await SecureStorageService.getToken();

if (ApiConfig.isTokenExpired(token)) {
  // Token expirado, renovar o logout
  await AuthService().signOut();
  Navigator.pushReplacementNamed(context, '/login');
}
```

### Verificar URL Segura

```dart
final url = 'http://example.com';

if (!ApiConfig.isSecureUrl(url)) {
  print('⚠️ Advertencia: URL no segura en producción');
}
```

---

## 🌍 Configuración por Plataforma

### Android Emulator
```
URL: http://10.0.2.2:5000
Nota: 10.0.2.2 es la IP especial del emulador para acceder a localhost del host
```

### iOS Simulator
```
URL: http://localhost:5000
Nota: El simulador iOS puede acceder directamente a localhost
```

### Dispositivo Físico
```
URL: http://[IP_DE_TU_PC]:5000
Ejemplo: http://192.168.100.7:5000
Nota: Asegúrate de que el dispositivo y PC estén en la misma red WiFi
```

### Producción (AWS EC2)
```
URL: http://15.228.188.14:5000
Nota: En producción real, usar HTTPS con certificado SSL
```

---

## ⚙️ Variables de Configuración

### Timeouts
```dart
ApiConfig.requestTimeout      // 30 segundos (peticiones normales)
ApiConfig.uploadTimeout       // 60 segundos (upload de imágenes)
ApiConfig.getTimeout(isUpload: true)  // Obtener timeout apropiado
```

### Caché
```dart
ApiConfig.cacheExpirationDays  // 7 días
ApiConfig.maxCacheSizeMB       // 50 MB
```

---

## 📝 Checklist de Seguridad

Antes de desplegar a producción, verificar:

- [ ] Cambiar entorno a `Environment.production`
- [ ] Usar HTTPS en producción (no HTTP)
- [ ] Configurar Google OAuth Client ID correcto
- [ ] Implementar `flutter_secure_storage` para tokens
- [ ] Validar expiración de tokens con `isTokenExpired()`
- [ ] Implementar manejo de errores de red
- [ ] Configurar timeouts apropiados
- [ ] Limpiar tokens al hacer logout
- [ ] Habilitar caché para modo offline
- [ ] Verificar URLs según plataforma

---

## 🔗 Enlaces Útiles

- [Guía de Seguridad Completa](./SECURITY_GUIDE.md)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [Google Sign-In](https://pub.dev/packages/google_sign_in)

---

✅ **Última actualización:** Octubre 2025  
🦙 **ULenguage - Tecsup 2025**
