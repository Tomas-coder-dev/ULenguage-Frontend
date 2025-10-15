class AppConfig {
  // Backend URL - Cambiar según el entorno
  static const String baseUrl = 'http://localhost:5000/api';
  
  // URLs específicas
  static const String authUrl = '$baseUrl/auth';
  static const String ocrUrl = '$baseUrl/ocr';
  static const String translateUrl = '$baseUrl/translate';
  static const String achievementsUrl = '$baseUrl/achievements';
  
  // Google OAuth
  static const String googleClientId = 
      '785759594484-ip3v1edfo185b6idd3cgb0vs721nei5a.apps.googleusercontent.com';
  
  // Configuración de timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Keys de almacenamiento local
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
}
