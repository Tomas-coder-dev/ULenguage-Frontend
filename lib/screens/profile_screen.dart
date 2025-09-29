import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFFDA2C38);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF9F6FC),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: primary,
        middle: const Text(
          "Perfil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          children: [
            // Avatar & User Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      size: 80,
                      color: Color(0xFFDA2C38),
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    "Fabricio Aylas",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    "Usuario cultural",
                    style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8A)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            // Achievements
            CupertinoListSection(
              backgroundColor: Colors.transparent,
              header: const Text(
                "Logros y Actividad",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              children: [
                _ProfileBadge(
                  icon: CupertinoIcons.star_fill,
                  title: "8 Logros culturales",
                  subtitle: "¡Sigue aprendiendo idiomas y explorando!",
                  color: primary,
                ),
                _ProfileBadge(
                  icon: CupertinoIcons.book_fill,
                  title: "248 Traducciones",
                  subtitle: "+12 traducciones hoy",
                  color: primary,
                ),
                _ProfileBadge(
                  icon: CupertinoIcons.globe,
                  title: "4 Lugares explorados",
                  subtitle: "3 rutas culturales",
                  color: primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Notifications & Account
            CupertinoListSection(
              backgroundColor: Colors.transparent,
              header: const Text(
                "Cuenta y Preferencias",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              children: [
                CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.bell_fill,
                    color: Color(0xFFDA2C38),
                  ),
                  title: const Text("Notificaciones"),
                  trailing: CupertinoSwitch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: primary,
                  ),
                  onTap: () {},
                ),
                CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.settings,
                    color: Color(0xFFDA2C38),
                  ),
                  title: const Text("Configuración de la cuenta"),
                  trailing: const Icon(
                    CupertinoIcons.right_chevron,
                    color: Color(0xFFB0B0B0),
                  ),
                  onTap: () {
                    // Navegar a configuración
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.lock,
                    color: Color(0xFFDA2C38),
                  ),
                  title: const Text("Cambiar contraseña"),
                  trailing: const Icon(
                    CupertinoIcons.right_chevron,
                    color: Color(0xFFB0B0B0),
                  ),
                  onTap: () {},
                ),
                CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.question_circle,
                    color: Color(0xFFDA2C38),
                  ),
                  title: const Text("Ayuda y soporte"),
                  trailing: const Icon(
                    CupertinoIcons.right_chevron,
                    color: Color(0xFFB0B0B0),
                  ),
                  onTap: () {},
                ),
                CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.arrow_right_square,
                    color: Color(0xFFDA2C38),
                  ),
                  title: const Text("Cerrar sesión"),
                  trailing: const Icon(
                    CupertinoIcons.right_chevron,
                    color: Color(0xFFB0B0B0),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "v1.0.0 • ULenguage",
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _ProfileBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: color, size: 23),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
      ),
      trailing: const Icon(
        CupertinoIcons.right_chevron,
        color: Color(0xFFB0B0B0),
      ),
      onTap: () {},
    );
  }
}

// CupertinoListTile is available in flutter 3.10+
// If you use an older Flutter version, replace with ListTile or build your own cupertino-like tile.
