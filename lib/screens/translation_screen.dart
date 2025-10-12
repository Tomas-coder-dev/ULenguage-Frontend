import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

// ---- MAIN SCREEN ----
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
  bool loading = false;

  final List<String> idiomas = ['Español', 'Inglés', 'Quechua'];
  final Map<String, String> flagEmoji = {
    'Español': '🇪🇸',
    'Inglés': '🇺🇸',
    'Quechua': '🦙',
  };

  final Map<int, bool> _expanded = {};

  // Frases útiles
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

  void _swapLanguages() {
    setState(() {
      final tmp = fromLang;
      fromLang = toLang;
      toLang = tmp;
      translatedText = '';
      _controller.clear();
    });
  }

  Future<void> _translate([String? text]) async {
    final input = (text ?? _controller.text).trim();
    setState(() {
      translatedText = '';
    });

    if (input.isEmpty) return;

    final langToCode = {'Español': 'es', 'Inglés': 'en', 'Quechua': 'qu'};
    final fromCode = langToCode[fromLang]!;
    final toCode = langToCode[toLang]!;

    setState(() => loading = true);
    try {
      final uri = Uri.parse('http://192.168.100.7:5000/api/translate');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': input,
          'source': fromCode, // <-- CAMBIO AQUÍ
          'target': toCode, // <-- CAMBIO AQUÍ
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          translatedText = data['translatedText'] ?? '';
        });
      } else {
        setState(() {
          translatedText = 'Error de traducción';
        });
      }
    } catch (e) {
      setState(() {
        translatedText = 'Error de conexión';
      });
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _pickImageAndTranslate() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => loading = true);

    try {
      final uri = Uri.parse('http://192.168.100.7:5000/api/ocr-translate');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', pickedFile.path),
      );
      request.fields['source'] = fromLang == 'Español'
          ? 'es'
          : fromLang == 'Inglés'
          ? 'en'
          : 'qu';
      request.fields['target'] = toLang == 'Español'
          ? 'es'
          : toLang == 'Inglés'
          ? 'en'
          : 'qu';

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        setState(() {
          _controller.text = data['extractedText'] ?? '';
          translatedText = data['translatedText'] ?? '';
        });
      } else {
        setState(() {
          translatedText = 'Error de traducción con imagen';
        });
      }
    } catch (e) {
      setState(() {
        translatedText = 'Error de conexión';
      });
    } finally {
      setState(() => loading = false);
    }
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
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: cardWidth),
          child: Material(
            color: Colors.transparent,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              children: [
                MainCard(
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
                  loading: loading,
                  onClear: () {
                    _controller.clear();
                    setState(() {
                      translatedText = '';
                    });
                  },
                  onChanged: (v) => setState(() {
                    translatedText = '';
                  }),
                  onTranslate: () async => await _translate(),
                  onPickImageAndTranslate: () async =>
                      await _pickImageAndTranslate(),
                ),
                const SizedBox(height: 26),
                FrasesUtilesCard(
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
    );
  }
}

// ---- MAIN CARD ----
class MainCard extends StatelessWidget {
  final String fromLang, toLang;
  final List<String> idiomas;
  final Map<String, String> flagEmoji;
  final void Function(String?) onFromChanged, onToChanged;
  final VoidCallback swap, onClear, onTranslate, onPickImageAndTranslate;
  final TextEditingController controller;
  final String translatedText;
  final void Function(String) onChanged;
  final bool loading;

  const MainCard({
    super.key,
    required this.fromLang,
    required this.toLang,
    required this.idiomas,
    required this.flagEmoji,
    required this.onFromChanged,
    required this.onToChanged,
    required this.swap,
    required this.controller,
    required this.translatedText,
    required this.loading,
    required this.onClear,
    required this.onChanged,
    required this.onTranslate,
    required this.onPickImageAndTranslate,
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
                child: CupertinoLangPicker(
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
                child: CupertinoLangPicker(
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
          child: loading
              ? const CupertinoActivityIndicator(radius: 15)
              : Text(
                  translatedText.isEmpty
                      ? "La traducción aparecerá aquí..."
                      : translatedText,
                  style: const TextStyle(fontSize: 17, color: Colors.black87),
                ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.symmetric(vertical: 18),
                onPressed: loading ? null : onTranslate,
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
              onPressed: loading ? null : onPickImageAndTranslate,
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

// ---- LANGUAGE PICKER ----
class CupertinoLangPicker extends StatelessWidget {
  final String value;
  final List<String> items;
  final Map<String, String> flagEmoji;
  final void Function(String?) onChanged;

  const CupertinoLangPicker({
    super.key,
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

// ---- FRASES ÚTILES CARD ----
class FrasesUtilesCard extends StatelessWidget {
  final List frasesUtiles;
  final Map<String, String> flagEmoji;
  final Map<int, bool> expanded;
  final void Function(int, bool) setExpanded;

  const FrasesUtilesCard({
    super.key,
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
                                    PhraseRow(flag: "🇪🇸", text: it['ES']),
                                    PhraseRow(flag: "🇺🇸", text: it['EN']),
                                    PhraseRow(flag: "🦙", text: it['QU']),
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

class PhraseRow extends StatelessWidget {
  final String flag;
  final String? text;
  const PhraseRow({super.key, required this.flag, required this.text});
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
