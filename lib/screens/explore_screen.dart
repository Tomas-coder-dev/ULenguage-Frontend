import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar_temp.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<Map<String, dynamic>> sites = [
    {
      'id': 0,
      'name': 'Machu Picchu',
      'img': 'assets/Machu_Picchu.jpg',
      'type': 'Montaña',
      'difficulty': 'Media',
      'rating': 4.9,
      'descriptions': {
        'Español':
            'Machu Picchu es una ciudadela inca en lo alto de las montañas de los Andes, famosa por su sofisticada arquitectura de piedra y vistas panorámicas.',
        'Inglés':
            'Machu Picchu is an Inca citadel set high in the Andes Mountains in Peru, renowned for its sophisticated dry-stone walls and panoramic views.',
        'Quechua':
            'Machu Picchu runaq, Alturapi Urqukunapi, inka llaqtam kachkan, qillqaq saywasninawan, panoraqmanta rikchayninwan.',
      },
    },
    {
      'id': 1,
      'name': 'Centro Histórico de Cusco',
      'img': 'assets/centro_historico.jpg',
      'type': 'Ciudad',
      'difficulty': 'Fácil',
      'rating': 4.8,
      'descriptions': {
        'Español':
            'La antigua capital del imperio inca, llena de historia, arquitectura colonial y vida local vibrante.',
        'Inglés':
            'The ancient capital of the Inca Empire, full of history, colonial architecture, and vibrant local life.',
        'Quechua':
            'Inka Qhapaq Llaqta, ñawpaq watakunapi hatun llaqtam, sumaq wasi, kawsayta.',
      },
    },
    {
      'id': 2,
      'name': 'Ollantaytambo',
      'img': 'assets/Ollantaytambo.jpg',
      'type': 'Ruta Cultural',
      'difficulty': 'Difícil',
      'rating': 4.7,
      'descriptions': {
        'Español':
            'Hogar de antiguos templos y terrazas incas; punto de partida para explorar el Valle Sagrado.',
        'Inglés':
            'Home to ancient Inca temples and terraces; a starting point for exploring the Sacred Valley.',
        'Quechua':
            'Antiguo wasikunata, inka taraykuna; qhapaq ñanpa qallarinqa.',
      },
    },
  ];

  int? selectedSite;
  String selectedLang = 'Español';

  final List<Map<String, dynamic>> mapSites = [
    {'name': 'Sacsayhuamán', 'dx': 0.18, 'dy': 0.18},
    {'name': 'Plaza de Armas', 'dx': 0.53, 'dy': 0.41},
    {'name': 'Museo Inka', 'dx': 0.54, 'dy': 0.36},
    {'name': 'Barro de San Blas', 'dx': 0.75, 'dy': 0.26},
    {'name': 'Mercado de San Pedro', 'dx': 0.36, 'dy': 0.61},
    {'name': 'Iglesia de la Compañía', 'dx': 0.56, 'dy': 0.43},
    {'name': 'Qoricancha', 'dx': 0.83, 'dy': 0.65},
    {'name': 'Templo de San Cristóbal', 'dx': 0.23, 'dy': 0.07},
  ];

  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F7FA);
    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Explorar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFDA2C38),
        border: null,
      ),
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: selectedSite == null
                    ? _OverviewSection(
                        sites: sites,
                        onTap: (idx) => setState(() {
                          selectedSite = idx;
                          selectedLang = 'Español';
                        }),
                      )
                    : _SiteDetailSection(
                        site: sites[selectedSite!],
                        selectedLang: selectedLang,
                        onLangTap: (l) => setState(() => selectedLang = l),
                        onComoLlegar: () => showCupertinoModalPopup(
                          context: context,
                          builder: (_) =>
                              _ComoLlegarMapCupertino(mapSites: mapSites),
                        ),
                        onBack: () => setState(() => selectedSite = null),
                      ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Navbar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> sites;
  final void Function(int) onTap;
  const _OverviewSection({required this.sites, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Explorar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Descubre las maravillas de la cultura andina.",
              style: TextStyle(color: Color(0xFF787878), fontSize: 15.5),
            ),
            const SizedBox(height: 18),
            CupertinoTextField(
              placeholder: "Buscar sitios o rutas...",
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8, right: 7),
                child: Icon(CupertinoIcons.search, color: Color(0xFFDA2C38)),
              ),
              readOnly: true,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F5FA),
                borderRadius: BorderRadius.circular(13),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),
            const Text(
              "Sitios Populares",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17.5,
                color: Color(0xFFDA2C38),
              ),
            ),
            const SizedBox(height: 11),
            ...sites.asMap().entries.map((entry) {
              final idx = entry.key;
              final site = entry.value;
              return CupertinoButton(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(18),
                onPressed: () => onTap(idx),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7FA),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE2D6DB),
                      width: 1.1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                        child: Image.asset(
                          site['img'],
                          width: 92,
                          height: 74,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 11, 12, 11),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                site['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.5,
                                  color: Color(0xFF222222),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                site['type'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.4,
                                  color: Color(0xFFDA2C38),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _Badge(
                                    text: site['difficulty'],
                                    color: site['difficulty'] == 'Fácil'
                                        ? const Color(0xFF47B881)
                                        : site['difficulty'] == 'Media'
                                        ? const Color(0xFF8E5DD1)
                                        : const Color(0xFFD34D4D),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    CupertinoIcons.star_fill,
                                    color: Color(0xFFFDC300),
                                    size: 17,
                                  ),
                                  Text(
                                    site['rating'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SiteDetailSection extends StatelessWidget {
  final Map<String, dynamic> site;
  final String selectedLang;
  final void Function(String) onLangTap;
  final VoidCallback onComoLlegar;
  final VoidCallback onBack;
  const _SiteDetailSection({
    required this.site,
    required this.selectedLang,
    required this.onLangTap,
    required this.onComoLlegar,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 22, 26, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                site['img'],
                height: 185,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              site['name'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
                letterSpacing: 0.02,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SiteDetailIconText(
                  icon: CupertinoIcons.location_solid,
                  label: site['type'],
                  color: const Color(0xFFDA2C38),
                ),
                const SizedBox(width: 16),
                _SiteDetailIconText(
                  icon: CupertinoIcons.chart_bar_alt_fill,
                  label: site['difficulty'],
                  color: site['difficulty'] == 'Fácil'
                      ? const Color(0xFF47B881)
                      : site['difficulty'] == 'Media'
                      ? const Color(0xFF8E5DD1)
                      : const Color(0xFFD34D4D),
                ),
                const SizedBox(width: 16),
                _SiteDetailIconText(
                  icon: CupertinoIcons.star_fill,
                  label: site['rating'].toString(),
                  color: const Color(0xFFFDC300),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.book_solid,
                      color: Color(0xFFDA2C38),
                      size: 21,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Descripción Cultural",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[900],
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _LangSelector(
              selected: selectedLang,
              langs: const ['Español', 'Inglés', 'Quechua'],
              onTap: onLangTap,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F5FA),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                site['descriptions'][selectedLang] ?? '',
                style: const TextStyle(
                  fontSize: 16.2,
                  color: Color(0xFF222222),
                  height: 1.38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 29),
            SizedBox(
              width: 190,
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.symmetric(vertical: 13),
                onPressed: onComoLlegar,
                child: const Text(
                  "Como llegar",
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.09,
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

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.2,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SiteDetailIconText extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SiteDetailIconText({
    required this.icon,
    required this.label,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LangSelector extends StatelessWidget {
  final String selected;
  final List<String> langs;
  final void Function(String) onTap;
  const _LangSelector({
    required this.selected,
    required this.langs,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final Map<String, String> flagEmoji = {
      'Español': '🇪🇸',
      'Inglés': '🇺🇸',
      'Quechua': '🦙',
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: langs.map((l) {
        final isSelected = l == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 7),
          child: GestureDetector(
            onTap: () => onTap(l),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFDA2C38)
                    : const Color(0xFFF8F7FA),
                borderRadius: BorderRadius.circular(10),
                border: isSelected
                    ? Border.all(color: const Color(0xFFDA2C38), width: 1.4)
                    : null,
              ),
              child: Row(
                children: [
                  Text(flagEmoji[l]!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    l,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFFDA2C38),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ComoLlegarMapCupertino extends StatelessWidget {
  final List<Map<String, dynamic>> mapSites;
  const _ComoLlegarMapCupertino({required this.mapSites});
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text("Como llegar"),
      message: SizedBox(
        height: 310,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset("assets/map_cusco.png", fit: BoxFit.cover),
              ),
            ),
            ...mapSites.map(
              (s) => Positioned(
                left:
                    (s['dx'] as double) *
                    (MediaQuery.of(context).size.width - 100),
                top: (s['dy'] as double) * 250,
                child: Column(
                  children: [
                    const Icon(
                      CupertinoIcons.location_solid,
                      color: Color(0xFFDA2C38),
                      size: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(240),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      child: Text(
                        s['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cerrar"),
      ),
    );
  }
}
