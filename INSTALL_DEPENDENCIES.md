# 📦 Instalación de Dependencias de Seguridad

## 🎯 Objetivo
Instalar `flutter_secure_storage` para almacenamiento encriptado de tokens JWT y datos sensibles.

---

## ⚡ Instalación Rápida

### Opción 1: Comando directo
```bash
cd ULenguage-Frontend
flutter pub add flutter_secure_storage
```

### Opción 2: Manual en pubspec.yaml
Agregar en la sección `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Almacenamiento seguro para tokens y datos sensibles
  flutter_secure_storage: ^9.0.0
  
  # Dependencias ya existentes
  shared_preferences: ^2.2.2
  http: ^1.1.0
  google_sign_in: ^6.1.5
  # ... resto de dependencias
```

Luego ejecutar:
```bash
flutter pub get
```

---

## 🔧 Configuración por Plataforma

### Android

**1. Verificar minSdkVersion**

Editar `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        // flutter_secure_storage requiere minSdkVersion >= 18
        minSdkVersion 18  // Cambiar si es menor
        targetSdkVersion 33
    }
}
```

**2. Habilitar encriptación (opcional pero recomendado)**

En `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <application
        android:allowBackup="false"
        ...>
    </application>
</manifest>
```

### iOS

**1. Verificar versión mínima**

Editar `ios/Podfile`:

```ruby
platform :ios, '12.0'  # flutter_secure_storage requiere >= 9.0
```

**2. Actualizar pods**

```bash
cd ios
pod install
cd ..
```

### Web

Para web, `flutter_secure_storage` usa `localStorage` (no encriptado). 
Para producción en web, considerar usar alternativas como:
- Cookies HttpOnly (requiere backend)
- Web Crypto API

---

## ✅ Verificación de Instalación

### 1. Verificar pubspec.yaml

```bash
flutter pub get
```

Debe mostrar:
```
Running "flutter pub get" in ULenguage-Frontend...
✓ flutter_secure_storage 9.0.0
```

### 2. Test rápido

Crear archivo temporal `test_secure_storage.dart`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  final storage = FlutterSecureStorage();
  
  // Escribir
  await storage.write(key: 'test_key', value: 'test_value');
  
  // Leer
  final value = await storage.read(key: 'test_key');
  print('Valor leído: $value'); // Debe mostrar: test_value
  
  // Eliminar
  await storage.delete(key: 'test_key');
  
  print('✅ flutter_secure_storage instalado correctamente');
}
```

### 3. Ejecutar en emulador/dispositivo

```bash
flutter run
```

Si no hay errores de compilación relacionados con `flutter_secure_storage`, ¡está listo!

---

## 🚨 Problemas Comunes

### Error: "minSdkVersion is less than 18"

**Solución:**
Editar `android/app/build.gradle` y cambiar:
```gradle
minSdkVersion 18
```

### Error: "CocoaPods not installed" (iOS)

**Solución:**
```bash
sudo gem install cocoapods
cd ios
pod install
```

### Error: "MissingPluginException" en runtime

**Solución:**
```bash
flutter clean
flutter pub get
flutter run
```

### Error en Web: "Unsupported operation"

`flutter_secure_storage` en web usa `localStorage` sin encriptación.
Para producción web, implementar solución backend (cookies HttpOnly).

---

## 🔄 Migración desde SharedPreferences

Si ya tienes tokens guardados en `SharedPreferences`, migrarlos:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../services/secure_storage_service.dart';

Future<void> migrateTokens() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Obtener token antiguo
  final oldToken = prefs.getString('user_token');
  
  if (oldToken != null) {
    // Guardar en almacenamiento seguro
    await SecureStorageService.saveToken(oldToken);
    
    // Eliminar de SharedPreferences
    await prefs.remove('user_token');
    
    print('✅ Token migrado a almacenamiento seguro');
  }
}
```

---

## 📱 Testing en Dispositivos

### Android Emulator
```bash
flutter run -d emulator
```

### Android Físico
```bash
flutter run -d android
```

### iOS Simulator
```bash
flutter run -d simulator
```

### Todos los dispositivos
```bash
flutter devices  # Ver dispositivos disponibles
flutter run      # Elegir dispositivo
```

---

## 🎯 Uso Después de Instalación

Una vez instalado, ya puedes usar `SecureStorageService`:

```dart
import '../services/secure_storage_service.dart';

// Guardar token
await SecureStorageService.saveToken('jwt_token_here');

// Leer token
final token = await SecureStorageService.getToken();

// Verificar autenticación
final isAuth = await SecureStorageService.isAuthenticated();

// Logout
await SecureStorageService.deleteTokens();
```

---

## 📚 Referencias

- [flutter_secure_storage en pub.dev](https://pub.dev/packages/flutter_secure_storage)
- [Documentación oficial](https://pub.dev/documentation/flutter_secure_storage/latest/)
- [GitHub del paquete](https://github.com/mogol/flutter_secure_storage)

---

## ✅ Checklist Final

- [ ] Ejecutar `flutter pub add flutter_secure_storage`
- [ ] Verificar `minSdkVersion >= 18` en Android
- [ ] Verificar iOS platform >= 9.0 en Podfile
- [ ] Ejecutar `flutter pub get`
- [ ] Ejecutar `flutter clean` (opcional)
- [ ] Probar en emulador/dispositivo
- [ ] Migrar tokens existentes (si aplica)
- [ ] Actualizar screens para usar `SecureStorageService`

---

🦙 **ULenguage - Tecsup 2025**  
✅ **Listo para implementar almacenamiento seguro**
