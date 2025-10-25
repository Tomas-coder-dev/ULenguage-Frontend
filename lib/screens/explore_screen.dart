import 'package:flutter/material.dart';
// Usa la import que corresponde a tu configuración.
// Si tus archivos generados están en lib/l10n/:
import '../../l10n/app_localizations.dart';
// Si usas la configuración estándar de Flutter gen-l10n, sería:
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Helper para mostrar categoría en formato ordenado
String prettyCategory(String? category) {
  if (category == null) return "Lugar turístico";
  return category.replaceAll("_", " ").replaceFirstMapped(
        RegExp(r'^[a-z]'),
        (m) => m[0]!.toUpperCase(),
      );
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> sites = [];
  List<dynamic> filteredSites = [];
  int? selectedSite;
  String selectedLang = 'es';
  bool loading = true;
  String errorMsg = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSites();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchSites({String? query}) async {
    setState(() {
      loading = true;
      errorMsg = '';
    });
    try {
      final uri = Uri.parse(
        query == null || query.isEmpty
            ? 'http://15.228.188.14:5000/api/explorer'
            : 'http://15.228.188.14:5000/api/explorer?query=${Uri.encodeComponent(query)}',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          sites = data['places'] ?? [];
          filteredSites = sites;
          loading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Error al cargar lugares (${res.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'No se pudo conectar al servidor';
        loading = false;
      });
    }
  }

  void _onSearchChanged() {
    final text = _searchController.text.trim();
    if (text.isEmpty) {
      setState(() => filteredSites = sites);
      return;
    }
    fetchSites(query: text);
  }

  // Abre el link de Google Maps directo, mostrando mensaje si falla
  Future<void> openMapsUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo abrir Google Maps ni el navegador."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F7FA);
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          l10n.explore,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFDA2C38),
        border: null,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: loading
                ? const Center(child: CupertinoActivityIndicator())
                : errorMsg.isNotEmpty
                    ? Center(
                        child: Text(errorMsg,
                            style: const TextStyle(color: Colors.red)))
                    : selectedSite == null
                        ? Column(
                            children: [
                              _SearchBar(controller: _searchController),
                              const SizedBox(height: 12),
                              Expanded(
                                child: _OverviewSection(
                                  sites: filteredSites,
                                  onTap: (idx) => setState(() {
                                    selectedSite = idx;
                                    selectedLang = 'es';
                                  }),
                                  onMapsTap: (url) => openMapsUrl(context, url),
                                ),
                              ),
                            ],
                          )
                        : _SiteDetailSection(
                            site: filteredSites[selectedSite!],
                            selectedLang: selectedLang,
                            onLangTap: (lang) =>
                                setState(() => selectedLang = lang),
                            onBack: () => setState(() => selectedSite = null),
                            onMapsTap: (url) => openMapsUrl(context, url),
                          ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});
  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: "Buscar sitios o rutas...",
      prefix: const Padding(
        padding: EdgeInsets.only(left: 8, right: 7),
        child: Icon(CupertinoIcons.search, color: Color(0xFFDA2C38)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5FA),
        borderRadius: BorderRadius.circular(13),
      ),
      style: const TextStyle(fontSize: 16),
      clearButtonMode: OverlayVisibilityMode.editing,
    );
  }
}

class _OverviewSection extends StatelessWidget {
  final List<dynamic> sites;
  final void Function(int) onTap;
  final void Function(String url) onMapsTap;
  const _OverviewSection({
    required this.sites,
    required this.onTap,
    required this.onMapsTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sites.isEmpty) {
      return const Center(child: Text('No hay sitios turísticos disponibles'));
    }
    return ListView.builder(
      itemCount: sites.length,
      itemBuilder: (context, idx) {
        final site = sites[idx];
        return CupertinoButton(
          onPressed: () => onTap(idx),
          padding: EdgeInsets.zero,
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (site['image'] != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: Image.network(
                      site['image'],
                      width: double.infinity,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 13, 18, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Color(0xFF222222),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Icon(Icons.place, color: Colors.red[300], size: 18),
                          const SizedBox(width: 5),
                          Text(
                            prettyCategory(site['category']),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.5,
                              color: Color(0xFFDA2C38),
                            ),
                          ),
                          const SizedBox(width: 17),
                          const Icon(
                            CupertinoIcons.star_fill,
                            color: Color(0xFFFDC300),
                            size: 18,
                          ),
                          Text(
                            site['rating']?.toString() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.2,
                            ),
                          ),
                          if (site['reviewsCount'] != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              "(${site['reviewsCount']})",
                              style: const TextStyle(
                                color: Color(0xFF969696),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 11),
                      if (site['location']?['googleMapsUrl'] != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: CupertinoButton(
                            onPressed: () =>
                                onMapsTap(site['location']['googleMapsUrl']),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 7),
                            color: const Color(0xFF8559DA),
                            borderRadius: BorderRadius.circular(15),
                            minimumSize: const Size(36, 36),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.map,
                                    size: 18, color: Colors.white),
                                SizedBox(width: 7),
                                Text(
                                  "Cómo llegar",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SiteDetailSection extends StatelessWidget {
  final dynamic site;
  final String selectedLang;
  final void Function(String) onLangTap;
  final VoidCallback onBack;
  final void Function(String url) onMapsTap;
  const _SiteDetailSection({
    required this.site,
    required this.selectedLang,
    required this.onLangTap,
    required this.onBack,
    required this.onMapsTap,
  });

  @override
  Widget build(BuildContext context) {
    final descMap = site['description'] ?? {};
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              onPressed: onBack,
              child: const Row(
                children: [
                  Icon(CupertinoIcons.back, color: Color(0xFFDA2C38)),
                  SizedBox(width: 7),
                  Text("Volver", style: TextStyle(color: Color(0xFFDA2C38))),
                ],
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              color: const Color(0xFFF8F7FA),
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (site['image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.network(
                          site['image'],
                          height: 185,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 22),
                    Text(
                      site['name'] ?? '',
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
                        Icon(Icons.place, color: Colors.red[300], size: 19),
                        const SizedBox(width: 6),
                        Text(
                          prettyCategory(site['category']),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                            color: Color(0xFFDA2C38),
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Icon(
                          CupertinoIcons.star_fill,
                          color: Color(0xFFFDC300),
                          size: 19,
                        ),
                        Text(
                          site['rating']?.toString() ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.3,
                          ),
                        ),
                        if (site['reviewsCount'] != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            "(${site['reviewsCount']})",
                            style: const TextStyle(
                              color: Color(0xFF969696),
                              fontWeight: FontWeight.w500,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    _LangSelector(
                      selected: selectedLang,
                      langs: const ['es', 'en', 'qu'],
                      onTap: onLangTap,
                    ),
                    const SizedBox(height: 9),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        descMap[selectedLang] ?? 'Descripción no disponible',
                        style: const TextStyle(
                          fontSize: 16.5,
                          color: Color(0xFF222222),
                          height: 1.38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (site['location']?['googleMapsUrl'] != null)
                      SizedBox(
                        width: 200,
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF8559DA),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          onPressed: () =>
                              onMapsTap(site['location']['googleMapsUrl']),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.map,
                                  size: 20, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Cómo llegar",
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.09,
                                  color: Colors.white,
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
            const SizedBox(height: 16),
          ],
        ),
      ),
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
      'es': '🇪🇸',
      'en': '🇺🇸',
      'qu': '🦙',
    };
    final Map<String, String> langName = {
      'es': 'Español',
      'en': 'Inglés',
      'qu': 'Quechua',
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: langs.map((l) {
        final isSelected = l == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => onTap(l),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFDA2C38)
                    : const Color(0xFFF8F7FA),
                borderRadius: BorderRadius.circular(11),
                border: isSelected
                    ? Border.all(color: const Color(0xFFDA2C38), width: 1.3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFDA2C38).withOpacity(0.12),
                          blurRadius: 10,
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Text(flagEmoji[l]!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 7),
                  Text(
                    langName[l]!,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFFDA2C38),
                      fontWeight: FontWeight.w700,
                      fontSize: 15.2,
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
