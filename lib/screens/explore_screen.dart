import 'package:flutter/material.dart';

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
      'img':
          'https://upload.wikimedia.org/wikipedia/commons/e/eb/Machu_Picchu%2C_Peru.jpg',
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
      'img':
          'https://upload.wikimedia.org/wikipedia/commons/1/13/Cusco_Plaza_de_Armas.jpg',
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
      'img':
          'https://upload.wikimedia.org/wikipedia/commons/3/31/Ollantaytambo-Panorama.jpg',
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

  int? selectedSite; // null = overview, else index
  String selectedLang = 'Español';

  // Sitios del mapa de Cusco para "Como llegar"
  final List<Map<String, String>> mapSites = [
    {'name': 'Sacsayhuamán', 'lat': '-13.5086', 'lng': '-71.9817'},
    {'name': 'Plaza de Armas', 'lat': '-13.5150', 'lng': '-71.9780'},
    {'name': 'Museo Inka', 'lat': '-13.5142', 'lng': '-71.9760'},
    {'name': 'Barro de San Blas', 'lat': '-13.5148', 'lng': '-71.9728'},
    {'name': 'Mercado de San Pedro', 'lat': '-13.5180', 'lng': '-71.9798'},
    {'name': 'Iglesia de la Compañía', 'lat': '-13.5153', 'lng': '-71.9776'},
    {'name': 'Qoricancha', 'lat': '-13.5192', 'lng': '-71.9770'},
    {'name': 'Templo de San Cristóbal', 'lat': '-13.5108', 'lng': '-71.9772'},
  ];

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F7FA);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Explorar"),
        backgroundColor: const Color(0xFFDA2C38),
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: selectedSite != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => setState(() => selectedSite = null),
              )
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 470),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                      onComoLlegar: () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (_) => _ComoLlegarMap(mapSites: mapSites),
                      ),
                      onBack: () => setState(() => selectedSite = null),
                    ),
            ),
          ),
        ),
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
    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Explorar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Descubre las maravillas de la cultura andina.",
              style: TextStyle(color: Color(0xFF888888), fontSize: 15),
            ),
            const SizedBox(height: 18),
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar sitios o rutas...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFFDA2C38)),
                filled: true,
                fillColor: const Color(0xFFF6F5FA),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
              ),
              readOnly: true,
              onTap: () {}, // futuro: filtrar
            ),
            const SizedBox(height: 16),
            const Text(
              "Sitios Populares",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            const SizedBox(height: 10),
            ...sites.asMap().entries.map((entry) {
              final idx = entry.key;
              final site = entry.value;
              return GestureDetector(
                onTap: () => onTap(idx),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2D6DB),
                      width: 1.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          site['img'],
                          width: 84,
                          height: 74,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                site['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                site['type'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xFFDA2C38),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _Badge(
                                    text: site['difficulty'],
                                    color: site['difficulty'] == 'Fácil'
                                        ? const Color(0xFF47B881)
                                        : site['difficulty'] == 'Media'
                                        ? const Color(0xFFFFA726)
                                        : const Color(0xFFDA2C38),
                                  ),
                                  const SizedBox(width: 7),
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFDC300),
                                    size: 17,
                                  ),
                                  Text(
                                    site['rating'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
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
    return Material(
      color: Colors.white,
      elevation: 7,
      borderRadius: BorderRadius.circular(25),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                site['img'],
                height: 175,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              site['name'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SiteDetailIconText(
                  icon: Icons.place_rounded,
                  label: site['type'],
                ),
                _SiteDetailIconText(
                  icon: Icons.bar_chart_rounded,
                  label: site['difficulty'],
                ),
                _SiteDetailIconText(
                  icon: Icons.star_rounded,
                  label: site['rating'].toString(),
                ),
              ],
            ),
            const SizedBox(height: 13),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 2, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFFDA2C38),
                      size: 21,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Descripción Cultural",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFDA2C38),
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
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F5FA),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                site['descriptions'][selectedLang] ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF222222),
                  height: 1.38,
                ),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: onComoLlegar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDA2C38),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Como llegar",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.8,
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
  const _SiteDetailIconText({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFDA2C38), size: 19),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => onTap(l),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFDA2C38)
                    : const Color(0xFFF8F7FA),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                "${flagEmoji[l]} $l",
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFDA2C38),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ComoLlegarMap extends StatelessWidget {
  final List<Map<String, String>> mapSites;
  const _ComoLlegarMap({required this.mapSites});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Como llegar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 2),
          const Text(
            "Descubre las maravillas de la cultura andina.",
            style: TextStyle(color: Color(0xFF888888), fontSize: 14),
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "https://i.ibb.co/bbn3P1s/cusco-mapa-demo.png",
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 9,
            children: mapSites
                .map(
                  (s) => Chip(
                    avatar: const Icon(
                      Icons.place_rounded,
                      size: 17,
                      color: Color(0xFFDA2C38),
                    ),
                    label: Text(s['name'] ?? ''),
                    backgroundColor: const Color(0xFFFCE7E9),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
