import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ULenguage + Título
                Column(
                  children: [
                    Image.network(
                      'https://res.cloudinary.com/dd5phul5v/image/upload/v1751846282/LOGOTIPO.2_ekafjt.png',
                      height: 110,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.appName,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                // Card central con sombra y esquinas redondeadas
                Card(
                  elevation: 7,
                  color: Colors.white,
                  shadowColor: Colors.red[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 38,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.welcome,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.welcomeSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Único botón motivador
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.travel_explore, size: 24),
                            label: Text(
                              l10n.startAdventure,
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadowColor: Colors.red[200],
                              textStyle: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                letterSpacing: 1.2,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
