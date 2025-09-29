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
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FC),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 54),
            // Título ULenguage
            Row(
              children: [
                const SizedBox(width: 28),
                Text(
                  "ULenguage",
                  style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    letterSpacing: -1.2,
                    fontFamily: 'SFProDisplay',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            // Card Login
            Expanded(
              child: Center(
                child: Container(
                  width: mq.size.width < 400 ? mq.size.width * 0.93 : 355,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(
                          23,
                          0,
                          0,
                          0,
                        ), // ~0.09 opacity black
                        blurRadius: 22,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo centrado
                      Image.network(
                        'https://res.cloudinary.com/dd5phul5v/image/upload/v1751846282/LOGOTIPO.2_ekafjt.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 18),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bienvenido de nuevo",
                          style: TextStyle(
                            fontSize: 15,
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
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (loading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CircularProgressIndicator(),
                        ),
                      // Botón Google
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/google_icon.png',
                            height: 22,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              'Continuar con Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SFProDisplay',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onPressed: loading ? null : _fakeLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black26,
                              width: 1.2,
                            ),
                            minimumSize: const Size.fromHeight(46),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Botón Facebook
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/facebook_icon.png',
                            height: 22,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              'Continuar con Facebook',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'SFProDisplay',
                              ),
                            ),
                          ),
                          onPressed: loading ? null : _fakeLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F3),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(46),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
