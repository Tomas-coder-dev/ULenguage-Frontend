import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar_temp.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});
  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final _controller = TextEditingController();
  String fromLang = 'Español';
  String toLang = 'Inglés';
  String translatedText = '';
  bool ocrResultVisible = false;
  String? ocrExtracted;
  Map<String, String>? ocrTranslations;
  int _currentIndex = 1;

  final List<String> idiomas = ['Español', 'Inglés', 'Quechua'];
  final Map<String, String> flagEmoji = {
    'Español': '🇪🇸',
    'Inglés': '🇺🇸',
    'Quechua': '🦙',
  };

  final Map<int, bool> _expanded = {};

  final List<Map<String, String>> fraseDB = [
    {'ES': 'Hola', 'EN': 'Hello', 'QU': 'Napaykuy'},
    {'ES': '¿Cómo estás?', 'EN': 'How are you?', 'QU': 'Imaynallam'},
    {
      'ES': '¿Dónde está el baño?',
      'EN': 'Where is the bathroom?',
      'QU': 'Maypin baño kachkan?',
    },
    {'ES': 'Buenos días', 'EN': 'Good morning', 'QU': 'Allin punchaw'},
    {
      'ES': '¿Cuánto cuesta esto?',
      'EN': 'How much is this?',
      'QU': 'Hayk\'am kanki kay?',
    },
    {
      'ES': 'Quisiera comprar...',
      'EN': 'I would like to buy...',
      'QU': 'Munayman tantiyta...',
    },
    {
      'EN':
          'In my five years as a sales manager, I have given regular presentations, developed successful sales strategies, and written numerous sales scripts for my employees.',
      'ES':
          'En mis cinco años como gerente de ventas, he dado presentaciones regulares, desarrollado estrategias exitosas de ventas y escrito numerosos guiones de ventas para mis empleados.',
      'QU':
          'Ñawpaq cinco wataykuna gerente kaspa, rikhuykuykuna ruwani, rimaykuna, yachachiykuna qillqani.',
    },
    {'QU': 'Imaynallam', 'ES': '¿Cómo estás?', 'EN': 'How are you?'},
  ];

  final frasesUtiles = [
    {
      'title': 'Saludos Comunes',
      'icon': CupertinoIcons.person_2_fill,
      'color': const Color(0xFFDA2C38),
      'items': [
        {'ES': 'Hola', 'EN': 'Hello', 'QU': 'Napaykuy'},
        {'ES': 'Buenos días', 'EN': 'Good morning', 'QU': 'Allin punchaw'},
        {'ES': '¿Cómo estás?', 'EN': 'How are you?', 'QU': 'Imaynallam'},
      ],
    },
    {
      'title': 'Navegación y Direcciones',
      'icon': CupertinoIcons.location_solid,
      'color': const Color(0xFFDA2C38),
      'items': [
        {
          'ES': '¿Dónde está el baño?',
          'EN': 'Where is the bathroom?',
          'QU': 'Maypin baño kachkan?',
        },
        {
          'ES': '¿Cómo llego a...?',
          'EN': 'How do I get to...?',
          'QU': 'Imayllam chayasqay...?',
        },
      ],
    },
    {
      'title': 'Compras y Restaurantes',
      'icon': CupertinoIcons.cart_fill,
      'color': const Color(0xFFDA2C38),
      'items': [
        {
          'ES': '¿Cuánto cuesta esto?',
          'EN': 'How much is this?',
          'QU': 'Hayk\'am kanki kay?',
        },
        {
          'ES': 'Quisiera comprar...',
          'EN': 'I would like to buy...',
          'QU': 'Munayman tantiyta...',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> ocrImages = [
    {'img': 'image2', 'label': 'Imaynallam', 'ocrText': 'Imaynallam'},
    {
      'img': 'image3',
      'label': 'Sales Manager (EN)',
      'ocrText':
          'In my five years as a sales manager, I have given regular presentations, developed successful sales strategies, and written numerous sales scripts for my employees.',
    },
  ];

  void _swapLanguages() {
    setState(() {
      final tmp = fromLang;
      fromLang = toLang;
      toLang = tmp;
      translatedText = '';
      _controller.clear();
      ocrResultVisible = false;
    });
  }

  void _translate([String? text]) {
    final input = (text ?? _controller.text).trim();
    setState(() {
      ocrResultVisible = false;
      ocrExtracted = null;
      ocrTranslations = null;
      if (input.isEmpty) {
        translatedText = '';
        return;
      }
      String? res;
      for (final frase in fraseDB) {
        final srcCode = _code(fromLang);
        final tgtCode = _code(toLang);
        if ((frase[srcCode]?.toLowerCase() == input.toLowerCase()) ||
            (frase[srcCode]?.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '') ==
                input.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), ''))) {
          res = frase[tgtCode];
          break;
        }
      }
      translatedText = res ?? "";
    });
  }

  String _code(String lang) => lang == 'Español'
      ? 'ES'
      : lang == 'Inglés'
      ? 'EN'
      : 'QU';

  void _simulateOCR(Map<String, dynamic> imgData) {
    final text = (imgData['ocrText'] ?? '').toString();
    _controller.text = text;
    Map<String, String>? traducciones;
    for (final frase in fraseDB) {
      if (frase.values.any((v) => v.toLowerCase() == text.toLowerCase())) {
        traducciones = {
          'Español': frase['ES'] ?? '',
          'Inglés': frase['EN'] ?? '',
          'Quechua': frase['QU'] ?? '',
        };
        break;
      }
    }
    setState(() {
      ocrResultVisible = true;
      ocrExtracted = text;
      ocrTranslations =
          traducciones ?? {'Español': '', 'Inglés': '', 'Quechua': ''};
      translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width > 600
        ? 520
        : double.infinity;
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Traductor",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFDA2C38),
        border: null,
      ),
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardWidth),
              child: Material(
                color: Colors.transparent,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 18,
                  ),
                  children: [
                    _MainCard(
                      fromLang: fromLang,
                      toLang: toLang,
                      idiomas: idiomas,
                      flagEmoji: flagEmoji,
                      onFromChanged: (v) {
                        if (v == null || v == toLang) return;
                        setState(() => fromLang = v);
                      },
                      onToChanged: (v) {
                        if (v == null || v == fromLang) return;
                        setState(() => toLang = v);
                      },
                      swap: _swapLanguages,
                      controller: _controller,
                      translatedText: translatedText,
                      onClear: () {
                        _controller.clear();
                        setState(() {
                          translatedText = '';
                          ocrResultVisible = false;
                        });
                      },
                      onChanged: (v) => setState(() {
                        translatedText = '';
                        ocrResultVisible = false;
                      }),
                      onTranslate: () => _translate(),
                      onOcr: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (_) => _OcrGalleryCupertino(
                            images: ocrImages,
                            onSelect: _simulateOCR,
                          ),
                        );
                      },
                      ocrResultVisible: ocrResultVisible,
                      ocrExtracted: ocrExtracted,
                      ocrTranslations: ocrTranslations,
                    ),
                    const SizedBox(height: 26),
                    _FrasesUtilesCard(
                      frasesUtiles: frasesUtiles,
                      flagEmoji: flagEmoji,
                      expanded: _expanded,
                      setExpanded: (idx, expanded) {
                        setState(() {
                          _expanded[idx] = expanded;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
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

class _MainCard extends StatelessWidget {
  final String fromLang, toLang;
  final List<String> idiomas;
  final Map<String, String> flagEmoji;
  final void Function(String?) onFromChanged, onToChanged;
  final VoidCallback swap, onClear, onTranslate, onOcr;
  final TextEditingController controller;
  final String translatedText;
  final void Function(String) onChanged;
  final bool ocrResultVisible;
  final String? ocrExtracted;
  final Map<String, String>? ocrTranslations;

  const _MainCard({
    required this.fromLang,
    required this.toLang,
    required this.idiomas,
    required this.flagEmoji,
    required this.onFromChanged,
    required this.onToChanged,
    required this.swap,
    required this.controller,
    required this.translatedText,
    required this.onClear,
    required this.onChanged,
    required this.onTranslate,
    required this.onOcr,
    required this.ocrResultVisible,
    required this.ocrExtracted,
    required this.ocrTranslations,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: _CupertinoLangPicker(
                  value: fromLang,
                  items: idiomas,
                  flagEmoji: flagEmoji,
                  onChanged: onFromChanged,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7E9),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: swap,
                  child: const Icon(
                    CupertinoIcons.arrow_right_arrow_left,
                    color: Color(0xFFDA2C38),
                    size: 27,
                  ),
                ),
              ),
              Expanded(
                child: _CupertinoLangPicker(
                  value: toLang,
                  items: idiomas,
                  flagEmoji: flagEmoji,
                  onChanged: onToChanged,
                ),
              ),
            ],
          ),
        ),
        CupertinoTextField(
          controller: controller,
          minLines: 2,
          maxLines: 4,
          placeholder: "Escribe aquí...",
          style: const TextStyle(fontSize: 18),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F5FA),
            borderRadius: BorderRadius.circular(15),
          ),
          suffix: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onClear,
            child: const Icon(
              CupertinoIcons.clear_thick,
              color: Color(0xFFDA2C38),
            ),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 13),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F5FA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            translatedText.isEmpty
                ? "La traducción aparecerá aquí..."
                : translatedText,
            style: const TextStyle(fontSize: 17, color: Colors.black87),
          ),
        ),
        if (ocrResultVisible && ocrExtracted != null) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFBE5E7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF6C8D0), width: 1.5),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      CupertinoIcons.photo,
                      color: Color(0xFFDA2C38),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Resultado OCR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDA2C38),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Text(
                    ocrExtracted ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Color(0xFF444444),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                if (ocrTranslations != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Traducciones:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFFDA2C38),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...ocrTranslations!.entries
                          .where((e) => (e.value).isNotEmpty)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF222222),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${flagEmoji[e.key] ?? ''} ',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: '${e.key}: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDA2C38),
                                      ),
                                    ),
                                    TextSpan(
                                      text: e.value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.symmetric(vertical: 18),
                onPressed: onTranslate,
                child: const Text(
                  'Traducir',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFFCE7E9),
              onPressed: onOcr,
              child: const Icon(
                CupertinoIcons.photo_on_rectangle,
                color: Color(0xFFDA2C38),
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CupertinoLangPicker extends StatelessWidget {
  final String value;
  final List<String> items;
  final Map<String, String> flagEmoji;
  final void Function(String?) onChanged;

  const _CupertinoLangPicker({
    required this.value,
    required this.items,
    required this.flagEmoji,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5FA),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFF6C8D0), width: 1.2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            borderRadius: BorderRadius.circular(15),
            isExpanded: true,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF222222),
              fontWeight: FontWeight.w600,
            ),
            icon: const Icon(
              CupertinoIcons.chevron_down,
              color: Color(0xFFDA2C38),
            ),
            onChanged: onChanged,
            dropdownColor: Colors.white,
            items: items.map((lang) {
              return DropdownMenuItem<String>(
                value: lang,
                child: Row(
                  children: [
                    Text(
                      flagEmoji[lang] ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      lang,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _FrasesUtilesCard extends StatelessWidget {
  final List frasesUtiles;
  final Map<String, String> flagEmoji;
  final Map<int, bool> expanded;
  final void Function(int, bool) setExpanded;

  const _FrasesUtilesCard({
    required this.frasesUtiles,
    required this.flagEmoji,
    required this.expanded,
    required this.setExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(22),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frases Útiles",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFDA2C38),
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 10),
            ...frasesUtiles.asMap().entries.map((entry) {
              int idx = entry.key;
              var frase = entry.value;
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      colorScheme: Theme.of(
                        context,
                      ).colorScheme.copyWith(secondary: Colors.transparent),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(
                        bottom: 13,
                        left: 1,
                        right: 1,
                      ),
                      title: Row(
                        children: [
                          Icon(
                            frase['icon'] as IconData?,
                            color: frase['color'] as Color?,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            frase['title']?.toString() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFDA2C38),
                            ),
                          ),
                        ],
                      ),
                      initiallyExpanded: expanded[idx] ?? false,
                      onExpansionChanged: (val) => setExpanded(idx, val),
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 1,
                          childAspectRatio: 2.7,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 14,
                          children: [
                            ...(frase['items'] as List).map((item) {
                              final it = item as Map<String, String>;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCE7E9),
                                  boxShadow: [
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _PhraseRow(flag: "🇪🇸", text: it['ES']),
                                    _PhraseRow(flag: "🇺🇸", text: it['EN']),
                                    _PhraseRow(flag: "🦙", text: it['QU']),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (idx != frasesUtiles.length - 1)
                    const Divider(
                      height: 26,
                      thickness: 1,
                      color: Color(0xFFF7E7E9),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PhraseRow extends StatelessWidget {
  final String flag;
  final String? text;
  const _PhraseRow({required this.flag, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(flag, style: const TextStyle(fontSize: 19)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFDA2C38),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OcrGalleryCupertino extends StatelessWidget {
  final List<Map<String, dynamic>> images;
  final void Function(Map<String, dynamic>) onSelect;
  const _OcrGalleryCupertino({required this.images, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text("Seleccionar de la galería (OCR)"),
      actions: images
          .map(
            (img) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                onSelect(img);
              },
              child: Row(
                children: [
                  const Icon(CupertinoIcons.photo, color: Color(0xFFDA2C38)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      img['label']?.toString() ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        isDestructiveAction: true,
        child: const Text("Cancelar"),
      ),
    );
  }
}
