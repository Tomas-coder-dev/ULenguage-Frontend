import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class AuthService {
  // Configura Google Sign-In para Android y Web
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  /// Inicia sesión con Google y envía el token al backend
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // 1. Inicia sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Login cancelado por el usuario');
      }

      // 2. Obtiene la autenticación de Google
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // 3. Obtiene el idToken (JWT de Google)
      final String? idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw Exception('No se pudo obtener el token de Google');
      }

      debugPrint('✅ Google Sign-In exitoso');
      debugPrint('Email: ${googleUser.email}');
      debugPrint('Name: ${googleUser.displayName}');

      // 4. Envía el idToken al backend para autenticación
      final response = await http.post(
        Uri.parse('${AppConfig.authUrl}/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Backend autenticado correctamente');
        debugPrint('Token JWT: ${data['token']}');
        
        return {
          'success': true,
          'user': data,
          'token': data['token'],
        };
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Error en el servidor');
      }
    } catch (e) {
      debugPrint('❌ Error en Google Sign-In: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Cierra sesión de Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      debugPrint('✅ Sesión de Google cerrada');
    } catch (e) {
      debugPrint('❌ Error al cerrar sesión: $e');
    }
  }

  /// Verifica si hay una sesión activa de Google
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  /// Obtiene el usuario actual de Google
  GoogleSignInAccount? getCurrentUser() {
    return _googleSignIn.currentUser;
  }
}

