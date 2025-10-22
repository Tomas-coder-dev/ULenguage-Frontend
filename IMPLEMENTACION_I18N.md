# 🌍 Implementación de Internacionalización (i18n) - ULenguage

## ✅ Cambios Realizados

### 1. Dependencias Agregadas
- `flutter_localizations` (SDK de Flutter)
- `intl: ^0.19.0`
- `shared_preferences: ^2.2.2`

### 2. Archivos de Configuración
- **l10n.yaml**: Configuración de localización
- **pubspec.yaml**: Agregado `generate: true` en la sección flutter

### 3. Archivos de Traducción Creados
- `lib/l10n/app_es.arb` (Español - idioma base)
- `lib/l10n/app_en.arb` (Inglés)
- `lib/l10n/app_qu.arb` (Quechua Cusqueño)

### 4. Provider de Idioma
- `lib/providers/locale_provider.dart`: Maneja el cambio de idioma y persistencia

### 5. Widget de Selección de Idioma
- `lib/widgets/language_selector.dart`: Widget reutilizable para cambiar idioma

### 6. Actualización de main.dart
- Agregado LocaleProvider
- Configurado supportedLocales
- Configurado localizationsDelegates

### 7. Pantallas Actualizadas
- ✅ welcome_screen.dart (completada)
- ⏳ login_screen.dart (pendiente)
- ⏳ home_screen.dart (pendiente)
- ⏳ profile_screen.dart (pendiente)
- ⏳ explore_screen.dart (pendiente)
- ⏳ translation_screen.dart (pendiente)
- ⏳ ocr_screen.dart (pendiente)

## 📝 Pasos Siguientes (Para Completar)

### 1. Generar archivos de localización
Ejecuta en terminal:
\`\`\`bash
flutter pub get
flutter gen-l10n
\`\`\`

### 2. Actualizar las pantallas restantes

Para cada pantalla, sigue este patrón:

#### a. Agregar imports:
\`\`\`dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
\`\`\`

#### b. Obtener instancia de localización:
\`\`\`dart
final l10n = AppLocalizations.of(context)!;
\`\`\`

#### c. Reemplazar textos hardcodeados:
\`\`\`dart
// Antes:
Text("Bienvenido")

// Después:
Text(l10n.welcome)
\`\`\`

### 3. Agregar nuevas traducciones

Si necesitas agregar más textos, edita los 3 archivos .arb:

**app_es.arb:**
\`\`\`json
{
  "miNuevoTexto": "Mi nuevo texto en español",
  "@miNuevoTexto": {
    "description": "Descripción del texto"
  }
}
\`\`\`

**app_en.arb:**
\`\`\`json
{
  "miNuevoTexto": "My new text in English"
}
\`\`\`

**app_qu.arb:**
\`\`\`json
{
  "miNuevoTexto": "Nuqa musuq qillqa quechuapi"
}
\`\`\`

Luego ejecuta:
\`\`\`bash
flutter gen-l10n
\`\`\`

### 4. Agregar selector de idioma en ProfileScreen

En `profile_screen.dart`, importa y usa el widget:

\`\`\`dart
import '../widgets/language_selector.dart';

// Dentro del build:
const LanguageSelector(),
\`\`\`

## 🎯 Cómo Usar las Traducciones

### En cualquier Widget:
\`\`\`dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.welcome); // Usa las traducciones
  }
}
\`\`\`

### Cambiar idioma programáticamente:
\`\`\`dart
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

// Español
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('es'));

// Inglés
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('en'));

// Quechua
Provider.of<LocaleProvider>(context, listen: false)
  .setLocale(const Locale('qu'));
\`\`\`

## 🔤 Traducciones Disponibles

| Clave | Español | English | Quechua |
|-------|---------|---------|---------|
| appName | ULenguage | ULenguage | ULenguage |
| welcome | Bienvenido | Welcome | Allin hamusqayki |
| welcomeSubtitle | Aprende, traduce y conecta... | Learn, translate and connect... | Yachay, t'ikray hinaspa tinkuy... |
| startAdventure | ¡Inicia tu aventura! | Start your adventure! | ¡Qallariy puriynikiyta! |
| login | Iniciar sesión | Log in | Yaykuy |
| email | Correo electrónico | Email | Correo electrónico |
| password | Contraseña | Password | Yaykuna rima |
| continueWithGoogle | Continuar con Google | Continue with Google | Qatipay Google nisqawan |
| language | Idioma | Language | Rimay |
| spanish | Español | Spanish | Kastilla simi |
| english | Inglés | English | Inglis simi |
| quechua | Quechua Cusqueño | Cusco Quechua | Qusqu Runasimi |

Ver archivos completos en `lib/l10n/app_*.arb`

## 🚀 Testing

1. Ejecuta la app
2. Ve a Perfil
3. Selecciona "Idioma"
4. Elige un idioma diferente
5. Toda la app debe cambiar al nuevo idioma
6. Cierra y vuelve a abrir la app (debe mantener el idioma seleccionado)

## ⚠️ Notas Importantes

- Los archivos generados están en `.dart_tool/flutter_gen/`
- **NO edites** los archivos generados manualmente
- Siempre edita los archivos `.arb` y regenera con `flutter gen-l10n`
- El idioma por defecto es español (`es`)
- El idioma se guarda automáticamente con SharedPreferences

## 📚 Recursos

- [Flutter Internationalization](https://docs.flutter.dev/accessibility-and-localization/internationalization)
- [ARB Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Intl Package](https://pub.dev/packages/intl)
