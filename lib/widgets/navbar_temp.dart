import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Navbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(31, 0, 0, 0), // ≈ 0.12 opacity black
            blurRadius: 7,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarIcon(
            icon: Icons.home_outlined,
            label: l10n.navbarHome,
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarIcon(
            icon: Icons.translate_rounded,
            label: l10n.navbarTranslate,
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _CameraNavBarIcon(selected: currentIndex == 2, onTap: () => onTap(2)),
          _NavBarIcon(
            icon: Icons.explore_outlined,
            label: l10n.navbarExplore,
            selected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavBarIcon(
            icon: Icons.person_outline,
            label: l10n.navbarProfile,
            selected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: selected ? const EdgeInsets.all(4) : EdgeInsets.zero,
                decoration: selected
                    ? const BoxDecoration(
                        color: Color.fromARGB(
                          31,
                          244,
                          67,
                          54,
                        ), // red with opacity
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(
                              51,
                              244,
                              67,
                              54,
                            ), // red with more opacity
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      )
                    : null,
                child: Icon(
                  icon,
                  size: selected ? 31 : 27,
                  color: selected ? Colors.red : Colors.black87,
                  shadows: selected
                      ? [const Shadow(color: Color(0xFFFFCDD2), blurRadius: 8)]
                      : [],
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? Colors.red : Colors.black54,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: -0.2,
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.fade),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraNavBarIcon extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _CameraNavBarIcon({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.elasticOut,
          width: selected ? 68 : 56,
          height: selected ? 68 : 56,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
            border: Border.all(
              color: selected ? Colors.red.shade900 : Colors.red.shade100,
              width: selected ? 4 : 2,
            ),
            boxShadow: [
              if (selected)
                const BoxShadow(
                  color: Color.fromARGB(89, 244, 67, 54), // red with opacity
                  blurRadius: 18,
                  spreadRadius: 4,
                  offset: Offset(0, 3),
                ),
              const BoxShadow(
                color: Color.fromARGB(31, 0, 0, 0), // black with opacity
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.center_focus_strong_rounded,
            color: Colors.white,
            size: 38,
            shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
          ),
        ),
      ),
    );
  }
}
