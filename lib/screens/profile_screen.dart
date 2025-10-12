import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFFDA2C38);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF9F6FC),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: primary,
        middle: Text(
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.045),
                          blurRadius: 13,
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      size: 80,
                      color: Color(0xFFDA2C38),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Fabricio Aylas",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xFFDA2C38),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5FA),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      "Usuario cultural",
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF767676),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Logros y Actividad",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.grey[800],
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 7),
            const Material(
              // FIX: Wrap Material for ListTile children
              color: Colors.transparent,
              child: _ProfileCard(
                children: [
                  _ProfileBadge(
                    icon: CupertinoIcons.star_fill,
                    title: "8 Logros culturales",
                    subtitle: "¡Sigue aprendiendo idiomas y explorando!",
                    color: Color(0xFFDA2C38),
                  ),
                  _ProfileBadge(
                    icon: CupertinoIcons.book_fill,
                    title: "248 Traducciones",
                    subtitle: "+12 traducciones hoy",
                    color: Color(0xFFDA2C38),
                  ),
                  _ProfileBadge(
                    icon: CupertinoIcons.globe,
                    title: "4 Lugares explorados",
                    subtitle: "3 rutas culturales",
                    color: Color(0xFFDA2C38),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Cuenta y Preferencias",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.grey[800],
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 7),
            Material(
              // FIX: Wrap Material for ListTile children
              color: Colors.transparent,
              child: _ProfileCard(
                children: [
                  _ProfileOptionTile(
                    icon: CupertinoIcons.bell_fill,
                    color: primary,
                    text: "Notificaciones",
                    trailing: CupertinoSwitch(
                      value: true,
                      onChanged: (_) {},
                      activeTrackColor: primary,
                    ),
                    onTap: () {},
                  ),
                  _ProfileOptionTile(
                    icon: CupertinoIcons.settings,
                    color: primary,
                    text: "Configuración de la cuenta",
                    trailing: const Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xFFB0B0B0),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  _ProfileOptionTile(
                    icon: CupertinoIcons.lock,
                    color: primary,
                    text: "Cambiar contraseña",
                    trailing: const Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xFFB0B0B0),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  _ProfileOptionTile(
                    icon: CupertinoIcons.question_circle,
                    color: primary,
                    text: "Ayuda y soporte",
                    trailing: const Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xFFB0B0B0),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  _ProfileOptionTile(
                    icon: CupertinoIcons.arrow_right_square,
                    color: primary,
                    text: "Cerrar sesión",
                    trailing: const Icon(
                      CupertinoIcons.right_chevron,
                      color: Color(0xFFB0B0B0),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "v1.0.0 • ULenguage",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFB4B4B4),
                  letterSpacing: 0.09,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 11,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map(
              (e) => Column(
                children: [
                  e.value,
                  if (e.key != children.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF3F0F0),
                      indent: 19,
                      endIndent: 19,
                    ),
                ],
              ),
            )
            .toList(),
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
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.11),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: color, size: 23),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
          fontSize: 16.5,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF888888)),
      ),
      trailing: const Icon(
        CupertinoIcons.right_chevron,
        color: Color(0xFFB0B0B0),
      ),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      minLeadingWidth: 0,
      dense: true,
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _ProfileOptionTile({
    required this.icon,
    required this.color,
    required this.text,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 23),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      minLeadingWidth: 0,
      dense: true,
    );
  }
}
