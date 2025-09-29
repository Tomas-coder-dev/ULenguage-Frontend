import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo principal
                Image.network(
                  'https://res.cloudinary.com/dd5phul5v/image/upload/v1751846282/LOGOTIPO.2_ekafjt.png',
                  height: 180,
                ),
                const SizedBox(height: 28),
                // Título
                Text(
                  'Bienvenido a',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                  ),
                ),
                // Marca ULenguage
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "U",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Lenguage",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.red[800],
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Subtítulo inspirador
                Text(
                  "Aprende, traduce y conecta\ncon el mundo andino.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 52),
                // Botón principal mejorado
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 6,
                      ),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      shadowColor: Colors.red[200],
                      textStyle: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: const Text(
                      '¡Comienza tu viaje andino!',
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
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
