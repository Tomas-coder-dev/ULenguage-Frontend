import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

/// Servicio para almacenamiento seguro de datos sensibles
/// Usa flutter_secure_storage para encriptar tokens y datos del usuario
class SecureStorageService {
  // Instancia única del servicio de almacenamiento seguro
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // ============================================
  // AUTENTICACIÓN
  // ============================================

  /// Guarda el token JWT del usuario
  static Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConfig.userTokenKey, value: token);
  }

  /// Obtiene el token JWT del usuario
  static Future<String?> getToken() async {
    return await _storage.read(key: ApiConfig.userTokenKey);
  }

  /// Guarda el refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: ApiConfig.refreshTokenKey, value: token);
  }

  /// Obtiene el refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: ApiConfig.refreshTokenKey);
  }

  /// Elimina todos los tokens (logout)
  static Future<void> deleteTokens() async {
    await _storage.delete(key: ApiConfig.userTokenKey);
    await _storage.delete(key: ApiConfig.refreshTokenKey);
  }

  /// Verifica si el usuario tiene un token válido
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;
    return !ApiConfig.isTokenExpired(token);
  }

  // ============================================
  // DATOS DE USUARIO
  // ============================================

  /// Guarda el email del usuario
  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: ApiConfig.userEmailKey, value: email);
  }

  /// Obtiene el email del usuario
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: ApiConfig.userEmailKey);
  }

  /// Guarda datos completos del usuario (JSON)
  static Future<void> saveUserData(String userData) async {
    await _storage.write(key: ApiConfig.userDataKey, value: userData);
  }

  /// Obtiene datos completos del usuario (JSON)
  static Future<String?> getUserData() async {
    return await _storage.read(key: ApiConfig.userDataKey);
  }

  // ============================================
  // UTILIDADES
  // ============================================

  /// Limpia todos los datos del almacenamiento seguro
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verifica si existe una clave específica
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Lee todas las claves almacenadas (útil para debugging)
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  /// Imprime información de debug (solo en desarrollo)
  static Future<void> printStorageInfo() async {
    if (ApiConfig.isDevelopment) {
      final hasToken = await containsKey(ApiConfig.userTokenKey);
      final hasRefreshToken = await containsKey(ApiConfig.refreshTokenKey);
      final hasUserData = await containsKey(ApiConfig.userDataKey);

      print('====================================');
      print('🔒 Secure Storage Info');
      print('====================================');
      print('Has Token: $hasToken');
      print('Has Refresh Token: $hasRefreshToken');
      print('Has User Data: $hasUserData');
      print('Is Authenticated: ${await isAuthenticated()}');
      print('====================================');
    }
  }
}
