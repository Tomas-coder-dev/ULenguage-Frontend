import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/api_config.dart';

/// Servicio para gestión de caché de contenido cultural
/// Usa SharedPreferences para almacenar datos no sensibles
class CacheService {
  // ============================================
  // CONTENIDO CULTURAL
  // ============================================

  /// Guarda contenido cultural en caché
  static Future<void> saveCachedContent(List<dynamic> content) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonContent = json.encode(content);
    
    await prefs.setString(ApiConfig.cachedContentKey, jsonContent);
    await prefs.setString(
      ApiConfig.lastSyncDateKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Obtiene contenido cultural del caché
  static Future<List<dynamic>?> getCachedContent() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonContent = prefs.getString(ApiConfig.cachedContentKey);

    if (jsonContent != null) {
      try {
        return json.decode(jsonContent) as List<dynamic>;
      } catch (e) {
        print('Error decodificando caché: $e');
        return null;
      }
    }
    return null;
  }

  /// Verifica si el caché está expirado
  static Future<bool> isCacheExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(ApiConfig.lastSyncDateKey);

    if (lastSyncStr == null) return true;

    try {
      final lastSync = DateTime.parse(lastSyncStr);
      final now = DateTime.now();
      final difference = now.difference(lastSync).inDays;

      return difference > ApiConfig.cacheExpirationDays;
    } catch (e) {
      print('Error verificando expiración de caché: $e');
      return true;
    }
  }

  /// Obtiene la fecha de última sincronización
  static Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(ApiConfig.lastSyncDateKey);

    if (lastSyncStr != null) {
      try {
        return DateTime.parse(lastSyncStr);
      } catch (e) {
        print('Error parseando fecha de sincronización: $e');
        return null;
      }
    }
    return null;
  }

  /// Limpia el caché de contenido cultural
  static Future<void> clearContentCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.cachedContentKey);
    await prefs.remove(ApiConfig.lastSyncDateKey);
  }

  // ============================================
  // MODO OFFLINE
  // ============================================

  /// Establece el modo offline
  static Future<void> setOfflineMode(bool isOffline) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ApiConfig.offlineModeKey, isOffline);
  }

  /// Verifica si está en modo offline
  static Future<bool> isOfflineMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ApiConfig.offlineModeKey) ?? false;
  }

  // ============================================
  // PREFERENCIAS DE USUARIO
  // ============================================

  /// Guarda el idioma del usuario
  static Future<void> saveUserLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.userLocaleKey, locale);
  }

  /// Obtiene el idioma del usuario
  static Future<String?> getUserLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.userLocaleKey);
  }

  /// Guarda el modo de tema (claro/oscuro)
  static Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.themeModeKey, themeMode);
  }

  /// Obtiene el modo de tema
  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.themeModeKey);
  }

  /// Guarda si las notificaciones están habilitadas
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ApiConfig.notificationsEnabledKey, enabled);
  }

  /// Verifica si las notificaciones están habilitadas
  static Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ApiConfig.notificationsEnabledKey) ?? true;
  }

  // ============================================
  // ONBOARDING Y PRIMER USO
  // ============================================

  /// Marca el onboarding como completado
  static Future<void> setOnboardingSeen(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ApiConfig.hasSeenOnboardingKey, seen);
  }

  /// Verifica si el usuario ya vio el onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ApiConfig.hasSeenOnboardingKey) ?? false;
  }

  /// Marca como primer lanzamiento
  static Future<void> setFirstLaunch(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ApiConfig.firstLaunchKey, isFirst);
  }

  /// Verifica si es el primer lanzamiento
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ApiConfig.firstLaunchKey) ?? true;
  }

  // ============================================
  // UTILIDADES
  // ============================================

  /// Limpia todo el caché (excepto preferencias críticas)
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obtener preferencias importantes antes de limpiar
    final locale = await getUserLocale();
    final themeMode = await getThemeMode();
    final hasSeenOnboarding = await CacheService.hasSeenOnboarding();
    
    // Limpiar todo
    await prefs.clear();
    
    // Restaurar preferencias importantes
    if (locale != null) await saveUserLocale(locale);
    if (themeMode != null) await saveThemeMode(themeMode);
    if (hasSeenOnboarding) await setOnboardingSeen(true);
  }

  /// Obtiene el tamaño estimado del caché (en caracteres)
  static Future<int> getCacheSize() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(ApiConfig.cachedContentKey);
    return content?.length ?? 0;
  }

  /// Verifica si el caché excede el tamaño máximo
  static Future<bool> isCacheSizeExceeded() async {
    final size = await getCacheSize();
    // Convertir MB a caracteres aproximados (1 MB ≈ 1,000,000 caracteres)
    final maxSize = ApiConfig.maxCacheSizeMB * 1000000;
    return size > maxSize;
  }

  /// Imprime información de debug del caché
  static Future<void> printCacheInfo() async {
    if (ApiConfig.isDevelopment) {
      final hasContent = (await getCachedContent()) != null;
      final isExpired = await isCacheExpired();
      final lastSync = await getLastSyncDate();
      final size = await getCacheSize();
      final isOffline = await isOfflineMode();

      print('====================================');
      print('💾 Cache Info');
      print('====================================');
      print('Has Content: $hasContent');
      print('Is Expired: $isExpired');
      print('Last Sync: ${lastSync?.toString() ?? "Never"}');
      print('Size: ${(size / 1000).toStringAsFixed(2)} KB');
      print('Offline Mode: $isOffline');
      print('====================================');
    }
  }
}
