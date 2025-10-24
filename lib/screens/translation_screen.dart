import 'dart:io';
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
  String toLang = 'Inglés'; // Por defecto
  String detectedLang = '';
  String translatedText = '';
  bool loading = false;
  List<String> ocrTranslations = [];
  String ocrImagePath = '';

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
    if (input.isEmpty) return;
    setState(() {
      loading = true;
      translatedText = '';
    });

    final langToCode = {'Español': 'es', 'Inglés': 'en', 'Quechua': 'qu'};
    final fromCode = langToCode[fromLang]!;
    final toCode = langToCode[toLang]!;

    try {
      final uri = Uri.parse('http://192.168.100.7:5000/api/translate');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': input, 'source': fromCode, 'target': toCode}),
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

    setState(() {
      loading = true;
      ocrTranslations = [];
      detectedLang = '';
      ocrImagePath = pickedFile.path;
    });

    final langToCode = {'Español': 'es', 'Inglés': 'en', 'Quechua': 'qu'};
    final toCode = langToCode[toLang]!;

    try {
      final uri = Uri.parse('http://192.168.100.7:5000/api/ocr/analyze');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', pickedFile.path),
      );
      request.fields['targetLang'] = toCode;

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        setState(() {
          ocrTranslations = (data['translations'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          detectedLang = data['detectedLang'] ?? '';
        });
      } else {
        setState(() {
          ocrTranslations = [];
          detectedLang = '';
        });
      }
    } catch (e) {
      setState(() {
        ocrTranslations = [];
        detectedLang = '';
      });
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildLangSwapRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _LangDropdown(
              value: fromLang,
              items: idiomas,
              flagEmoji: flagEmoji,
              onChanged: (v) {
                if (v == null || v == toLang) return;
                setState(() => fromLang = v);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7E9),
              borderRadius: BorderRadius.circular(13),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.all(3),
              onPressed: _swapLanguages,
              child: const Icon(
                CupertinoIcons.arrow_right_arrow_left,
                color: Color(0xFFDA2C38),
                size: 27,
              ),
            ),
          ),
          Expanded(
            child: _LangDropdown(
              value: toLang,
              items: idiomas,
              flagEmoji: flagEmoji,
              onChanged: (v) {
                if (v == null || v == fromLang) return;
                setState(() => toLang = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOcrResults() {
    if (ocrTranslations.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ocrImagePath.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(ocrImagePath),
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (detectedLang.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.globe,
                      color: Color(0xFFDA2C38),
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Detectado: $detectedLang",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFFDA2C38),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      CupertinoIcons.arrow_right,
                      color: Color(0xFFDA2C38),
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Traducción: $toLang",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFFDA2C38),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              ...ocrTranslations.map(
                (tr) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 11,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFDA2C38),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth =
        MediaQuery.of(context).size.width > 600 ? 520 : double.infinity;
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
                _buildLangSwapRow(), // swap row
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CupertinoTextField(
                          controller: _controller,
                          minLines: 2,
                          maxLines: 4,
                          placeholder: "Escribe o pega texto aquí...",
                          style: const TextStyle(fontSize: 18),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F5FA),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffix: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _controller.clear();
                              setState(() => translatedText = '');
                            },
                            child: const Icon(
                              CupertinoIcons.clear_thick,
                              color: Color(0xFFDA2C38),
                            ),
                          ),
                          onChanged: (_) => setState(() => translatedText = ''),
                        ),
                        const SizedBox(height: 13),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 15,
                          ),
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
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton.filled(
                                borderRadius: BorderRadius.circular(16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                onPressed: loading ? null : () => _translate(),
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
                              onPressed:
                                  loading ? null : _pickImageAndTranslate,
                              child: const Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Color(0xFFDA2C38),
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _buildOcrResults(),
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

// ---- CUSTOM LANGUAGE DROPDOWN FOR SWAP DESIGN ----
class _LangDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Map<String, String> flagEmoji;
  final void Function(String?) onChanged;

  const _LangDropdown({
    required this.value,
    required this.items,
    required this.flagEmoji,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFFCE7E9), width: 1.7),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          borderRadius: BorderRadius.circular(13),
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
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lang,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
