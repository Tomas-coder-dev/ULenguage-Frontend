import 'dart:io';
import 'dart:convert';

/// Configuración centralizada de API y endpoints del backend
/// 
/// Este archivo centraliza todas las URLs y configuraciones relacionadas
/// con el backend para facilitar cambios entre entornos (desarrollo, producción).
/// Incluye detección de plataforma, autenticación OAuth y constantes de almacenamiento.
class ApiConfig {
  // ============================================
  // CONFIGURACIÓN DE ENTORNO
  // ============================================
  
  /// Entorno actual de la aplicación
  /// Cambiar entre: Environment.development, Environment.production
  static const Environment currentEnvironment = Environment.production;
  
  // ============================================
  // URLs BASE POR ENTORNO
  // ============================================
  
  /// URL del backend en desarrollo (local o IP local)
  /// Para Android emulator: usar 10.0.2.2 (IP especial que apunta a localhost del host)
  /// Para dispositivo físico Android/iOS: usar IP local de tu PC (ej: 192.168.100.7)
  /// Para iOS simulator: usar localhost
  static String get _developmentBaseUrl {
    if (Platform.isAndroid) {
      // Para emulador Android, usar IP especial que mapea a localhost del host
      // Si usas dispositivo físico, cambiar a la IP de tu PC (ej: 192.168.100.7)
      return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      // Para simulador iOS, localhost funciona directamente
      return 'http://localhost:5000';
    } else {
      // Fallback para otras plataformas (web, desktop)
      return 'http://localhost:5000';
    }
  }
  
  /// URL del backend en producción (AWS EC2)
  /// IMPORTANTE: En producción, usar HTTPS si tienes certificado SSL configurado
  static const String _productionBaseUrl = 'http://15.228.188.14:5000';
  
  /// URL base actual según el entorno configurado
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return _developmentBaseUrl;
      case Environment.production:
        return _productionBaseUrl;
    }
  }
  
  // ============================================
  // ENDPOINTS DE LA API
  // ============================================
  
  /// Endpoints de autenticación
  static String get authLogin => '$baseUrl/api/auth/login';
  static String get authRegister => '$baseUrl/api/auth/register';
  static String get authProfile => '$baseUrl/api/auth/profile';
  
  /// Endpoints de traducción
  static String get translate => '$baseUrl/api/translate';
  
  /// Endpoints de OCR
  static String get ocrAnalyze => '$baseUrl/api/ocr/analyze';
  
  /// Endpoints de exploración
  static String get explorer => '$baseUrl/api/explorer';
  static String explorerSearch(String query) => 
      '$baseUrl/api/explorer?query=${Uri.encodeComponent(query)}';
  
  /// Endpoints de contenido cultural
  static String get culturalContent => '$baseUrl/api/content';
  static String culturalContentById(String id) => '$baseUrl/api/content/$id';
  
  /// Endpoints de logros (achievements)
  static String get achievements => '$baseUrl/api/achievements';
  
  // ============================================
  // AUTENTICACIÓN Y OAUTH
  // ============================================
  
  /// Google OAuth Client ID
  /// IMPORTANTE: Este ID debe coincidir con el configurado en Google Cloud Console
  /// Para producción, asegúrate de usar el Client ID correcto según la plataforma
  static const String googleClientId = 
      '785759594484-ip3v1edfo185b6idd3cgb0vs721nei5a.apps.googleusercontent.com';
  
  /// Redirect URI para OAuth (ajustar según plataforma)
  static String get oauthRedirectUri {
    if (Platform.isAndroid) {
      return 'com.tecsup.ulenguage:/oauth2redirect';
    } else if (Platform.isIOS) {
      return 'com.tecsup.ulenguage:/oauth2redirect';
    } else {
      return 'http://localhost:3000/oauth2redirect';
    }
  }
  
  // ============================================
  // ALMACENAMIENTO LOCAL (CACHE Y SEGURIDAD)
  // ============================================
  
  /// Keys para almacenamiento en SharedPreferences
  /// IMPORTANTE: Para datos sensibles (tokens, passwords), usar flutter_secure_storage
  
  // Autenticación
  static const String userTokenKey = 'user_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userEmailKey = 'user_email';
  static const String isLoggedInKey = 'is_logged_in';
  
  // Preferencias de usuario
  static const String userLocaleKey = 'user_locale';
  static const String themeModeKey = 'theme_mode';
  static const String notificationsEnabledKey = 'notifications_enabled';
  
  // Cache de contenido
  static const String cachedContentKey = 'cached_content';
  static const String lastSyncDateKey = 'last_sync_date';
  static const String offlineModeKey = 'offline_mode';
  
  // Onboarding y primer uso
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String firstLaunchKey = 'first_launch';
  
  /// Tiempo de expiración de caché (en días)
  static const int cacheExpirationDays = 7;
  
  /// Tamaño máximo de caché (en MB)
  static const int maxCacheSizeMB = 50;
  
  // ============================================
  // CONFIGURACIONES ADICIONALES
  // ============================================
  
  /// Timeout para peticiones HTTP
  static const Duration requestTimeout = Duration(seconds: 30);
  
  /// Timeout para peticiones de upload (imágenes OCR)
  static const Duration uploadTimeout = Duration(seconds: 60);
  
  /// Headers comunes para todas las peticiones
  static Map<String, String> get commonHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  /// Headers para peticiones con autenticación
  static Map<String, String> authHeaders(String token) => {
    ...commonHeaders,
    'Authorization': 'Bearer $token',
  };
  
  /// Headers para peticiones multipart (upload de imágenes)
  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
  };
  
  // ============================================
  // MÉTODOS DE UTILIDAD
  // ============================================
  
  /// Verifica si estamos en modo desarrollo
  static bool get isDevelopment => currentEnvironment == Environment.development;
  
  /// Verifica si estamos en modo producción
  static bool get isProduction => currentEnvironment == Environment.production;
  
  /// Obtiene la URL completa para un path relativo
  static String getFullUrl(String path) {
    // Si el path ya incluye http/https, devolverlo tal cual
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    // Si el path empieza con /, eliminar la duplicación
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$baseUrl/$cleanPath';
  }
  
  /// Imprime información de configuración actual (útil para debugging)
  static void printConfig() {
    print('====================================');
    print('🦙 ULenguage API Configuration');
    print('====================================');
    print('Environment: $currentEnvironment');
    print('Platform: ${Platform.operatingSystem}');
    print('Base URL: $baseUrl');
    print('Timeout: $requestTimeout');
    print('Google OAuth: ${googleClientId.substring(0, 20)}...');
    print('====================================');
  }
  
  // ============================================
  // VALIDACIONES Y SEGURIDAD
  // ============================================
  
  /// Verifica si una URL es segura (HTTPS en producción)
  static bool isSecureUrl(String url) {
    if (isProduction) {
      return url.startsWith('https://');
    }
    // En desarrollo, permitir HTTP
    return true;
  }
  
  /// Obtiene el timeout adecuado según el tipo de operación
  static Duration getTimeout({bool isUpload = false}) {
    return isUpload ? uploadTimeout : requestTimeout;
  }
  
  /// Valida si el token JWT está expirado (básico)
  static bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    
    try {
      // Decodificar payload del JWT (formato: header.payload.signature)
      final parts = token.split('.');
      if (parts.length != 3) return true;
      
      // Decodificar base64 del payload
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> data = json.decode(decoded);
      
      // Verificar expiración (exp en segundos desde epoch)
      if (data.containsKey('exp')) {
        final exp = data['exp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        return now > exp;
      }
      
      return false;
    } catch (e) {
      print('Error validando token: $e');
      return true;
    }
  }
}

/// Enumeración de entornos disponibles
enum Environment {
  development,
  production,
}
