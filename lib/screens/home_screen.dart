import 'package:flutter/material.dart';
import '../widgets/navbar_temp.dart';
import 'translation_screen.dart';
import 'ocr_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String nombreUsuario = "Fabricio Aylas";
  int _currentIndex = 0;

  static const double progreso = 0.75;

  static const List<Map<String, dynamic>> paquetesLocales = [
    {
      "nombre": "Paquete de idioma Quechua",
      "tamano": "15 MB",
      "instalado": true,
    },
    {"nombre": "Guía de Cuzco", "tamano": "32 MB", "instalado": false},
  ];

  void _onNavBarTap(int i) {
    setState(() => _currentIndex = i);
    switch (i) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TranslationScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OcrScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExploreScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFDA2C38),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://res.cloudinary.com/dd5phul5v/image/upload/v1751846282/LOGOTIPO.2_ekafjt.png',
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "ULenguage",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: -0.5,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _HeaderChip(
                          icon: Icons.wifi,
                          label: "Conectado",
                          color: Color(0xFF69C779),
                        ),
                        SizedBox(width: 12),
                        _HeaderChip(
                          icon: Icons.inventory_2_rounded,
                          label: "3 paquetes",
                          color: Colors.white,
                          textColor: Color(0xFFDA2C38),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFFDA2C38),
                      size: 44,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "¡Bienvenido, $nombreUsuario!",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDA2C38),
                        fontSize: 22,
                        fontFamily: 'SFProDisplay',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tu aventura cultural continúa",
                      style: TextStyle(fontSize: 15, color: Color(0xFF656565)),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      elevation: 0,
                      color: const Color(0xFFFDF2F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events_outlined,
                                  color: Color(0xFFDA2C38),
                                ),
                                const SizedBox(width: 7),
                                const Text(
                                  "Progreso Cultural",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    fontFamily: 'SFProDisplay',
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${(progreso * 100).toInt()}%",
                                  style: const TextStyle(
                                    color: Color(0xFFDA2C38),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Explorando culturas andinas",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFFDA2C38),
                              ),
                            ),
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: const LinearProgressIndicator(
                                value: progreso,
                                minHeight: 11,
                                backgroundColor: Color(0xFFE1E2E1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFDA2C38),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Continúa explorando para desbloquear nuevos horizontes",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Inspiración / resumen cultural
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Card(
                  elevation: 0,
                  color: const Color(0xFFFDF2F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                    child: Column(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFFDA2C38),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '"Cada idioma es una ventana al alma de un pueblo"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFDA2C38),
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Disfruta aprendiendo y explorando nuevas culturas. Tu conexión con las culturas andinas crece cada día.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF444444),
                            fontSize: 13,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // PAQUETES DISPONIBLES (nuevo diseño)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Paquetes Disponibles:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          "Descarga contenido para usar la app sin conexión a internet.",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 14),
                        for (final paquete in paquetesLocales)
                          _PaqueteListTile(paquete: paquete),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? textColor;

  const _HeaderChip({
    required this.icon,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor ?? Colors.white, size: 18),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaqueteListTile extends StatelessWidget {
  final Map<String, dynamic> paquete;
  const _PaqueteListTile({required this.paquete});

  @override
  Widget build(BuildContext context) {
    final bool instalado = paquete['instalado'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        minLeadingWidth: 0,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        title: Text(
          paquete['nombre'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 15,
            fontFamily: 'SFProDisplay',
          ),
        ),
        subtitle: Text(
          paquete['tamano'] ?? '',
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        trailing: CircleAvatar(
          backgroundColor: instalado
              ? const Color(0xFFE5F7EC)
              : const Color(0xFFFFEBEE),
          radius: 17,
          child: Icon(
            instalado ? Icons.check_circle : Icons.download_rounded,
            color: instalado
                ? const Color(0xFF47B881)
                : const Color(0xFFDA2C38),
            size: 23,
          ),
        ),
      ),
    );
  }
}
