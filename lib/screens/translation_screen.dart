import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  // Frases de consejos y ejemplos (esto se mantiene igual)
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

  // Traductor REAL usando tu backend
  Future<void> _translate([String? text]) async {
    final input = (text ?? _controller.text).trim();
    setState(() {
      ocrResultVisible = false;
      ocrExtracted = null;
      ocrTranslations = null;
      translatedText = '';
    });

    if (input.isEmpty) return;

    final langToCode = {'Español': 'es', 'Inglés': 'en', 'Quechua': 'qu'};
    final fromCode = langToCode[fromLang]!;
    final toCode = langToCode[toLang]!;

    try {
      final uri = Uri.parse('http://localhost:5000/api/translate');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': input, 'from': fromCode, 'to': toCode}),
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
    }
  }

  // OCR: Simula selección de imagen, extrae texto y traduce con backend
  Future<void> _simulateOCR(Map<String, dynamic> imgData) async {
    final text = (imgData['ocrText'] ?? '').toString();
    _controller.text = text;

    // Traduce a todos los idiomas con backend
    final langToCode = {'Español': 'es', 'Inglés': 'en', 'Quechua': 'qu'};

    Map<String, String> traducciones = {};
    for (final lang in idiomas) {
      final fromCode = langToCode[lang]!;
      try {
        final uri = Uri.parse('http://localhost:5000/api/translate');
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'text': text,
            'from': fromCode, // Intentamos detectar en cada idioma
            'to': langToCode[lang],
          }),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          traducciones[lang] = data['translatedText'] ?? '';
        } else {
          traducciones[lang] = '';
        }
      } catch (_) {
        traducciones[lang] = '';
      }
    }

    setState(() {
      ocrResultVisible = true;
      ocrExtracted = text;
      ocrTranslations = traducciones;
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
                      onTranslate: () async => await _translate(),
                      onOcr: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (_) => _OcrGalleryCupertino(
                            images: ocrImages,
                            onSelect: (img) async {
                              Navigator.pop(context);
                              await _simulateOCR(img);
                            },
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

// ...rest of your widget classes (_MainCard, _CupertinoLangPicker, _FrasesUtilesCard, _PhraseRow, _OcrGalleryCupertino) remain unchanged...
