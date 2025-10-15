import 'dart:io';

class AppConfig {
  // Backend URL - Cambiar según el entorno
  // Para emulador Android: 10.0.2.2
  // Para dispositivo físico: IP de tu PC (ej: 192.168.1.X)
  // Para iOS simulator: localhost
  static String get baseUrl {
    if (Platform.isAndroid) {
      // 10.0.2.2 es la IP especial del emulador Android para acceder a localhost del host
      return 'http://10.0.2.2:5000/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }
  
  // URLs específicas
  static String get authUrl => '$baseUrl/auth';
  static String get ocrUrl => '$baseUrl/ocr';
  static String get translateUrl => '$baseUrl/translate';
  static String get achievementsUrl => '$baseUrl/achievements';
  
  // Google OAuth
  static const String googleClientId = 
      '785759594484-ip3v1edfo185b6idd3cgb0vs721nei5a.apps.googleusercontent.com';
  
  // Configuración de timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Keys de almacenamiento local
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
}
