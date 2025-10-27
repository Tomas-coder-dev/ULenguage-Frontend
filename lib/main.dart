import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/user_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const ULenguageApp(),
    ),
  );
}

class ULenguageApp extends StatelessWidget {
  const ULenguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'ULenguage',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'SFProDisplay',
            primarySwatch: Colors.red,
            useMaterial3: true,
          ),
          // Configuración de i18n
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('es'), // Español
            Locale('en'), // Inglés
            Locale('qu'), // Quechua
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
