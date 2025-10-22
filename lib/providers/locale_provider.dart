import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Inglés por defecto

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  // Cargar el idioma guardado
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'es';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Cambiar idioma y guardar preferencia
  Future<void> setLocale(Locale locale) async {
    if (!['es', 'en', 'qu'].contains(locale.languageCode)) return;
    
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  // Limpiar preferencia de idioma
  Future<void> clearLocale() async {
    _locale = const Locale('es');
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('language_code');
  }
}
