# 🔒 Guía de Seguridad y Almacenamiento - ULenguage

## 📋 Índice
1. [Configuración de Entornos](#configuración-de-entornos)
2. [Autenticación en Producción](#autenticación-en-producción)
3. [Almacenamiento Seguro](#almacenamiento-seguro)
4. [Detección de Plataforma](#detección-de-plataforma)
5. [Mejores Prácticas](#mejores-prácticas)

---

## 🌍 Configuración de Entornos

### Cambiar entre Development y Production

En `api_config.dart`, modificar esta línea:

```dart
// Para desarrollo (local)
static const Environment currentEnvironment = Environment.development;

// Para producción (AWS EC2)
static const Environment currentEnvironment = Environment.production;
```

### URLs por Entorno

| Entorno | Plataforma | URL Base |
|---------|-----------|----------|
| **Development** | Android Emulator | `http://10.0.2.2:5000` |
| **Development** | iOS Simulator | `http://localhost:5000` |
| **Development** | Dispositivo físico | `http://[IP_DE_TU_PC]:5000` |
| **Production** | Todas | `http://15.228.188.14:5000` |

> ⚠️ **IMPORTANTE**: En producción, siempre usar **HTTPS** si tienes certificado SSL configurado.

---

## 🔐 Autenticación en Producción

### 1. JWT Token Management

#### ✅ Almacenamiento Seguro (Recomendado)

Para datos sensibles (tokens, passwords), usar **flutter_secure_storage**:

```dart
// pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
// services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Guardar token JWT
  static Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConfig.userTokenKey, value: token);
  }

  // Obtener token JWT
  static Future<String?> getToken() async {
    return await _storage.read(key: ApiConfig.userTokenKey);
  }

  // Eliminar token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: ApiConfig.userTokenKey);
  }

  // Verificar si el token está vigente
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;
    return !ApiConfig.isTokenExpired(token);
  }
}
```

#### ⚠️ Almacenamiento Básico (Solo para desarrollo)

Para datos no sensibles, usar **SharedPreferences**:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class PreferencesService {
  // Guardar preferencias de usuario
  static Future<void> saveUserLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.userLocaleKey, locale);
  }

  // Obtener preferencias de usuario
  static Future<String?> getUserLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.userLocaleKey);
  }
}
```

### 2. Validación de Token JWT

El `ApiConfig` incluye un método para validar tokens:

```dart
import '../config/api_config.dart';

// Verificar si el token está expirado
final token = await SecureStorageService.getToken();
if (ApiConfig.isTokenExpired(token)) {
  // Token expirado, redirigir a login
  Navigator.pushReplacementNamed(context, '/login');
}
```

### 3. Google OAuth en Producción


#### Configuración en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un proyecto de Firebase (o usa uno existente).
3. Agrega tu app Android y/o iOS:

**Android:**
  - Ingresa el nombre de paquete (ejemplo: com.tecsup.ulenguage)
  - Ingresa el SHA-1 de tu clave de firma (usa: `keytool -list -v -keystore ~/.android/debug.keystore`)
  - Descarga el archivo `google-services.json` y colócalo en `android/app/`

**iOS:**
  - Ingresa el Bundle ID (ejemplo: com.tecsup.ulenguage)
  - Descarga el archivo `GoogleService-Info.plist` y colócalo en `ios/Runner/`

4. Firebase genera automáticamente las credenciales necesarias para Google Sign-In y Firebase Auth.
5. No necesitas crear credenciales OAuth2 manualmente en Google Cloud Console para autenticación móvil estándar.

6. Si usas Google APIs fuera de Firebase, entonces sí debes crear credenciales en Google Cloud Console y vincularlas a tu proyecto de Firebase.

7. En tu código Flutter, usa el flujo de Google Sign-In/Firebase Auth normalmente. El archivo `google-services.json` es suficiente para la autenticación móvil.

> ⚠️ **IMPORTANTE:** El Client ID de Google para el backend debe coincidir con el configurado en Firebase si tu backend valida tokens de Google/Firebase.

#### Implementación con google_sign_in

```dart
// pubspec.yaml
dependencies:
  google_sign_in: ^6.1.5

// services/auth_service.dart
import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_config.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: ApiConfig.googleClientId,
    scopes: ['email', 'profile'],
  );

  // Login con Google
  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        // Enviar token al backend para validación
        final auth = await account.authentication;
        final idToken = auth.idToken;
        
        // Llamar a tu backend
        final response = await http.post(
          Uri.parse(ApiConfig.authLogin),
          headers: ApiConfig.commonHeaders,
          body: json.encode({'googleToken': idToken}),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          await SecureStorageService.saveToken(data['token']);
        }
      }
      return account;
    } catch (error) {
      print('Error en Google Sign-In: $error');
      return null;
    }
  }

  // Logout
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await SecureStorageService.deleteToken();
  }
}
```

---

## 📱 Detección de Plataforma

### Configuración Automática por Plataforma

El `ApiConfig` detecta automáticamente la plataforma en desarrollo:

```dart
// En api_config.dart
static String get _developmentBaseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:5000';  // Emulador Android
  } else if (Platform.isIOS) {
    return 'http://localhost:5000';  // Simulador iOS
  } else {
    return 'http://localhost:5000';  // Web/Desktop
  }
}
```

### Para Dispositivo Físico Android/iOS

Si usas un dispositivo físico conectado por USB, debes:

1. **Encontrar la IP de tu PC:**

```bash
# Windows
ipconfig

# macOS/Linux
ifconfig
```

2. **Cambiar la URL en `api_config.dart`:**

```dart
static String get _developmentBaseUrl {
  if (Platform.isAndroid) {
    // Cambiar por la IP de tu PC
    return 'http://192.168.100.7:5000';
  }
  // ...
}
```

3. **Asegurar que el dispositivo y PC estén en la misma red WiFi**

---

## 💾 Almacenamiento en Caché (Recomendado)

### Estrategia de Caché para Contenido Cultural

```dart
// services/cache_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/api_config.dart';

class CacheService {
  // Guardar contenido en caché
  static Future<void> saveCachedContent(List<dynamic> content) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonContent = json.encode(content);
    await prefs.setString(ApiConfig.cachedContentKey, jsonContent);
    await prefs.setString(
      ApiConfig.lastSyncDateKey, 
      DateTime.now().toIso8601String(),
    );
  }

  // Obtener contenido en caché
  static Future<List<dynamic>?> getCachedContent() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonContent = prefs.getString(ApiConfig.cachedContentKey);
    
    if (jsonContent != null) {
      return json.decode(jsonContent) as List<dynamic>;
    }
    return null;
  }

  // Verificar si el caché está expirado
  static Future<bool> isCacheExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(ApiConfig.lastSyncDateKey);
    
    if (lastSyncStr == null) return true;
    
    final lastSync = DateTime.parse(lastSyncStr);
    final now = DateTime.now();
    final difference = now.difference(lastSync).inDays;
    
    return difference > ApiConfig.cacheExpirationDays;
  }

  // Limpiar caché
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.cachedContentKey);
    await prefs.remove(ApiConfig.lastSyncDateKey);
  }
}
```

### Uso en Pantallas

```dart
// screens/explore_screen.dart
import '../services/cache_service.dart';
import '../config/api_config.dart';

class ExploreScreen extends StatefulWidget {
  // ...
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _content = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);

    try {
      // 1. Verificar si hay caché válido
      final isCacheExpired = await CacheService.isCacheExpired();
      
      if (!isCacheExpired) {
        final cachedContent = await CacheService.getCachedContent();
        if (cachedContent != null) {
          setState(() {
            _content = cachedContent;
            _isLoading = false;
          });
          return; // Usar caché
        }
      }

      // 2. Si no hay caché o está expirado, obtener del servidor
      final response = await http.get(
        Uri.parse(ApiConfig.culturalContent),
        headers: ApiConfig.commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Guardar en caché
        await CacheService.saveCachedContent(data);
        
        setState(() {
          _content = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando contenido: $e');
      
      // 3. Si falla la red, intentar caché (aunque esté expirado)
      final cachedContent = await CacheService.getCachedContent();
      if (cachedContent != null) {
        setState(() {
          _content = cachedContent;
          _isLoading = false;
        });
      }
    }
  }
}
```

---

## ✅ Mejores Prácticas

### 1. Datos Sensibles vs No Sensibles

| Dato | Almacenamiento |
|------|----------------|
| **JWT Token** | ✅ `flutter_secure_storage` |
| **Password** | ✅ `flutter_secure_storage` |
| **Refresh Token** | ✅ `flutter_secure_storage` |
| **Email del usuario** | ⚠️ `SharedPreferences` (si no es sensible) |
| **Preferencia de idioma** | ⚠️ `SharedPreferences` |
| **Modo oscuro/claro** | ⚠️ `SharedPreferences` |
| **Contenido cultural** | ⚠️ `SharedPreferences` (caché) |

### 2. Validación de Seguridad

```dart
// Verificar que estamos usando HTTPS en producción
if (ApiConfig.isProduction && !ApiConfig.isSecureUrl(ApiConfig.baseUrl)) {
  print('⚠️ ADVERTENCIA: Usando HTTP en producción. Cambiar a HTTPS.');
}
```

### 3. Timeout Apropiado

```dart
// Para peticiones normales
final timeout = ApiConfig.requestTimeout; // 30s

// Para uploads de imágenes OCR
final uploadTimeout = ApiConfig.getTimeout(isUpload: true); // 60s
```

### 4. Debugging de Configuración

```dart
// En main.dart, solo en desarrollo
void main() {
  if (ApiConfig.isDevelopment) {
    ApiConfig.printConfig();
  }
  runApp(MyApp());
}

// Output:
// ====================================
// 🦙 ULenguage API Configuration
// ====================================
// Environment: Environment.development
// Platform: android
// Base URL: http://10.0.2.2:5000
// Timeout: 0:00:30.000000
// Google OAuth: 785759594484-ip3v1e...
// ====================================
```

### 5. Manejo de Errores de Red

```dart
Future<void> makeRequest() async {
  try {
    final response = await http.get(
      Uri.parse(ApiConfig.culturalContent),
      headers: ApiConfig.commonHeaders,
    ).timeout(ApiConfig.requestTimeout);

    if (response.statusCode == 200) {
      // Éxito
    } else if (response.statusCode == 401) {
      // Token expirado, renovar o logout
      final token = await SecureStorageService.getToken();
      if (ApiConfig.isTokenExpired(token)) {
        // Redirigir a login
      }
    }
  } on TimeoutException catch (_) {
    print('⏱️ Timeout: El servidor no respondió a tiempo');
  } on SocketException catch (_) {
    print('📡 Sin conexión a internet');
  } catch (e) {
    print('❌ Error inesperado: $e');
  }
}
```

---

## 🔄 Migración desde app_config.dart

Si tienes código usando el antiguo `app_config.dart`, migra así:

### Antes (app_config.dart):
```dart
import '../config/app_config.dart';

final url = '${AppConfig.baseUrl}/auth/login';
```

### Después (api_config.dart):
```dart
import '../config/api_config.dart';

final url = ApiConfig.authLogin;
```

---

## 📚 Recursos Adicionales

- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [HTTP Package](https://pub.dev/packages/http)

---

✅ **Checklist de Seguridad:**

- [ ] Usar `flutter_secure_storage` para tokens JWT
- [ ] Validar expiración de tokens con `ApiConfig.isTokenExpired()`
- [ ] Cambiar a HTTPS en producción
- [ ] Configurar Google OAuth Client ID correcto
- [ ] Implementar caché para contenido offline
- [ ] Manejar timeouts y errores de red apropiadamente
- [ ] Limpiar caché y tokens al hacer logout
- [ ] Verificar URLs según plataforma (emulador vs dispositivo)

---

🦙 **ULenguage - Tecsup 2025**
