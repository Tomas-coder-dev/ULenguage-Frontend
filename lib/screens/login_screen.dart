import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Ajusta la ruta si es necesario

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  Future<void> _fakeLogin() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ULenguage centrado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ULenguage",
                      style: TextStyle(
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: -1.2,
                        fontFamily: 'SFProDisplay',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 38),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(20, 0, 0, 0),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo centrado
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://res.cloudinary.com/dd5phul5v/image/upload/v1751846282/LOGOTIPO.2_ekafjt.png',
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bienvenido de nuevo",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Iniciar sesión",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (loading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CupertinoActivityIndicator(radius: 16),
                        ),
                      // Google Button
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          onPressed: loading ? null : _fakeLogin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/google_icon.png', height: 22),
                              const SizedBox(width: 10),
                              const Text(
                                'Continuar con Google',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Facebook Button
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: const Color(0xFF1877F3),
                          borderRadius: BorderRadius.circular(18),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          onPressed: loading ? null : _fakeLogin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/facebook_icon.png',
                                height: 22,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Continuar con Facebook',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Opcional: espacio extra para móviles altos
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
