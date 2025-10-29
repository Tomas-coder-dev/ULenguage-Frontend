import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../config/api_config.dart';

/// Pantalla OCR con presentación mejorada:
/// - Tarjetas modernas para cada item (objeto/texto) en la lista horizontal.
/// - Avatar con tipo (OBJ/TXT), score visual, preview de la explicación.
/// - Card de detalle con miniatura de la imagen y explicación con scroll + botón "Ver completo".
/// - Modal full screen más estilizado para leer/copiar texto completo.
/// - Safe setState, manejo de timeouts y parsing robusto.

class DetectedItem {
  final String id;
  final String type; // 'object' | 'text'
  final String label;
  final Map<String, String> explanations;
  final double score;
  final dynamic boundingBox;

  DetectedItem({
    required this.id,
    required this.type,
    required this.label,
    required this.explanations,
    required this.score,
    this.boundingBox,
  });

  String explanationFor(String lang) {
    final code = lang.toLowerCase().split(RegExp(r'[-_]'))[0];
    if (explanations.containsKey(code) &&
        explanations[code]!.trim().isNotEmpty) {
      return explanations[code]!;
    }
    for (final v in explanations.values) {
      if (v.trim().isNotEmpty) return v;
    }
    return '';
  }

  String labelFor(String lang) {
    final code = lang.toLowerCase().split(RegExp(r'[-_]'))[0];
    final expl = explanationFor(code);
    if (label.trim().isEmpty && expl.isNotEmpty) {
      return expl.length > 40 ? '${expl.substring(0, 40)}...' : expl;
    }
    return label;
  }
}

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});
  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen>
    with SingleTickerProviderStateMixin {
  bool scanning = false;
  bool scanned = false;
  String errorMsg = '';
  String scannedImagePath = '';
  int selectedIndex = -1;
  List<DetectedItem> detectedItems = [];
  String detectedLang = '';

  final idiomas = [
    {'label': 'Español', 'code': 'es', 'icon': '🇪🇸'},
    {'label': 'Inglés', 'code': 'en', 'icon': '🇺🇸'},
    {'label': 'Quechua', 'code': 'qu', 'icon': '🦙'},
  ];
  String targetLangCode = 'es';

  final ScrollController _explanationScrollController = ScrollController();

  static const Color _accent = Color(0xFFDA2C38);
  static const Color _softRed = Color(0xFFFCE7E9);
  static const Color _muted = Color(0xFF6B6B6B);
  static const double _explanationMaxHeight = 360.0;

  // animation
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _explanationScrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  Future<void> _pickAndScanImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    _safeSetState(() {
      scanning = true;
      scanned = false;
      detectedItems = [];
      selectedIndex = -1;
      errorMsg = '';
      scannedImagePath = pickedFile.path;
      detectedLang = '';
    });
    await _scanImageAndFetchObjects(pickedFile.path, targetLangCode);
  }

  List _ensureList(dynamic maybeListOrMap) {
    if (maybeListOrMap == null) return [];
    if (maybeListOrMap is List) return maybeListOrMap;
    if (maybeListOrMap is Map) return maybeListOrMap.values.toList();
    return [];
  }

  Future<void> _scanImageAndFetchObjects(
      String imagePath, String langCode) async {
    if (imagePath.isEmpty) {
      _safeSetState(() {
        scanning = false;
        errorMsg = 'No hay imagen para escanear.';
      });
      return;
    }

    try {
      final uri = Uri.parse(ApiConfig.ocrAnalyze);
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['targetLang'] = langCode;

      debugPrint('[OCR] POST $uri targetLang=$langCode');

      final streamedResponse =
          await request.send().timeout(ApiConfig.getTimeout(isUpload: true));
      final respStr = await streamedResponse.stream.bytesToString();
      debugPrint('-- OCR RESP STR START --');
      debugPrint(respStr);
      debugPrint('-- OCR RESP STR END --');

      final status = streamedResponse.statusCode;
      if (status != 200) {
        _safeSetState(() {
          scanning = false;
          scanned = false;
          errorMsg = 'Error del servidor ($status).';
        });
        return;
      }

      dynamic data;
      try {
        data = json.decode(respStr);
      } catch (e) {
        _safeSetState(() {
          scanning = false;
          scanned = false;
          errorMsg = 'Respuesta inválida del servidor.';
        });
        return;
      }

      final List<DetectedItem> items = [];

      // Parse objects
      final rawObjects =
          _ensureList(data['objects'] ?? data['detectedObjects'] ?? []);
      for (var i = 0; i < rawObjects.length; i++) {
        final objDyn = rawObjects[i] ?? {};
        final Map obj =
            (objDyn is Map) ? Map.from(objDyn) : {'name': objDyn.toString()};
        final Map<String, String> explanationsMap = {};
        final explRaw = obj['explanations'] ?? obj['explanation'];
        if (explRaw is Map) {
          explRaw.forEach((k, v) {
            if (v != null) explanationsMap[k.toString()] = v.toString();
          });
        } else if (explRaw is String) {
          explanationsMap[langCode] = explRaw;
        }
        final name =
            (obj['name'] ?? obj['label'] ?? obj['translatedNames']?['es'] ?? '')
                .toString();
        final score =
            (obj['score'] is num) ? (obj['score'] as num).toDouble() : 0.0;
        final boundingBox = obj['boundingBox'] ?? obj['boundingPoly'];
        items.add(DetectedItem(
            id: 'obj_$i',
            type: 'object',
            label: name,
            explanations: explanationsMap,
            score: score,
            boundingBox: boundingBox));
      }

      // Parse texts
      final rawTexts = _ensureList(data['texts'] ?? []);
      for (var i = 0; i < rawTexts.length; i++) {
        final t = rawTexts[i];
        String text = '';
        final Map<String, String> explanationsMap = {};
        if (t is Map) {
          text = (t['text'] ?? t['value'] ?? '').toString();
          final explRaw = t['explanations'] ?? t['explanation'];
          if (explRaw is Map) {
            explRaw.forEach((k, v) {
              if (v != null) explanationsMap[k.toString()] = v.toString();
            });
          } else if (explRaw is String) {
            explanationsMap[langCode] = explRaw;
          }
        } else {
          text = t?.toString() ?? '';
          explanationsMap[langCode] = text;
        }
        items.add(DetectedItem(
            id: 'txt_$i',
            type: 'text',
            label: text,
            explanations: explanationsMap,
            score: 0.0));
      }

      final detectedLangFromServer = (data['detectedLang'] is String)
          ? data['detectedLang'] as String
          : '';

      _safeSetState(() {
        scanning = false;
        scanned = true;
        detectedItems = items;
        detectedLang = detectedLangFromServer;
        selectedIndex = detectedItems.isNotEmpty ? 0 : -1;
        errorMsg = detectedItems.isEmpty
            ? AppLocalizations.of(context)!.noObjectsDetected
            : '';
      });

      // animate selection
      _animController.forward(from: 0.0);
    } on SocketException {
      _safeSetState(() {
        scanning = false;
        errorMsg = 'Error de red. Revisa la conexión con el backend.';
      });
    } on TimeoutException {
      _safeSetState(() {
        scanning = false;
        errorMsg = 'Tiempo de espera agotado.';
      });
    } catch (e) {
      _safeSetState(() {
        scanning = false;
        errorMsg = 'Error inesperado: ${e.toString()}';
      });
    }
  }

  void _resetScan() {
    _safeSetState(() {
      scanning = false;
      scanned = false;
      detectedItems = [];
      selectedIndex = -1;
      errorMsg = '';
      scannedImagePath = '';
      detectedLang = '';
    });
  }

  Future<void> _changeLangAndReload(String langCode) async {
    if (scannedImagePath.isEmpty) {
      _safeSetState(() => targetLangCode = langCode);
      return;
    }
    final prevId = (selectedIndex >= 0 && selectedIndex < detectedItems.length)
        ? detectedItems[selectedIndex].id
        : null;
    _safeSetState(() {
      scanning = true;
      errorMsg = '';
      targetLangCode = langCode;
    });
    await _scanImageAndFetchObjects(scannedImagePath, langCode);
    if (prevId != null) {
      final idx = detectedItems.indexWhere((it) => it.id == prevId);
      _safeSetState(() {
        selectedIndex = idx != -1 ? idx : (detectedItems.isNotEmpty ? 0 : -1);
      });
    }
  }

  String _currentExplanation() {
    if (selectedIndex < 0 || selectedIndex >= detectedItems.length) return '';
    return detectedItems[selectedIndex].explanationFor(targetLangCode);
  }

  String _currentLabel() {
    if (selectedIndex < 0 || selectedIndex >= detectedItems.length) return '';
    final it = detectedItems[selectedIndex];
    final label = it.labelFor(targetLangCode);
    return label.isNotEmpty
        ? label
        : (it.type == 'object' ? 'Objeto' : 'Texto detectado');
  }

  void _openFullScreenExplanation(String title, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: _accent),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.white),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Texto copiado')));
                      },
                    ),
                    IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          // share: simple fallback -> copy to clipboard
                          Clipboard.setData(ClipboardData(text: text));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Contenido copiado para compartir')));
                        }),
                    IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: SelectableText(text,
                          style: const TextStyle(fontSize: 16, height: 1.5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemCard(DetectedItem it, bool isSelected) {
    final preview = it.explanationFor(targetLangCode);
    final displayLabel = it.labelFor(targetLangCode);
    final score = (it.score.clamp(0.0, 1.0));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? _softRed : Colors.white,
        border: Border.all(
            color: isSelected ? _accent : const Color(0xFFE6E6E6),
            width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(14),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ]
            : [],
      ),
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: it.type == 'object' ? _accent : Colors.blueGrey,
              child: Text(it.type == 'object' ? 'OBJ' : 'TXT',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: isSelected ? _accent : _muted,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                      const SizedBox(width: 4),
                      Text('${(score * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF7A7A7A))),
                    ])
                  ]),
            ),
          ]),
          const SizedBox(height: 8),
          // preview text
          SizedBox(
            height: 38,
            child: Text(preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF3A3A3A))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width > 920
                    ? 920
                    : double.infinity),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: (!scanned) ? _buildInitial() : _buildResults(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitial() {
    final l10n = AppLocalizations.of(context)!;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(CupertinoIcons.camera_viewfinder, size: 74, color: _accent),
      const SizedBox(height: 18),
      Text(scanning ? l10n.scanning : l10n.scanAndSelectLang,
          style: const TextStyle(
              fontSize: 18, color: _accent, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center),
      const SizedBox(height: 18),
      if (scannedImagePath.isNotEmpty)
        ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(scannedImagePath),
                height: 160, fit: BoxFit.cover)),
      const SizedBox(height: 16),
      _buildLangSelector(),
      const SizedBox(height: 18),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _scanButton(l10n.gallery, CupertinoIcons.photo,
            () => _pickAndScanImage(ImageSource.gallery)),
        const SizedBox(width: 12),
        _scanButton(l10n.photo, CupertinoIcons.camera,
            () => _pickAndScanImage(ImageSource.camera)),
      ]),
      const SizedBox(height: 20),
      if (errorMsg.isNotEmpty)
        Text(errorMsg,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildResults() {
    final l10n = AppLocalizations.of(context)!;
    final hasItems = detectedItems.isNotEmpty;
    final selectedLabel = _currentLabel();
    final explanationText = _currentExplanation();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(children: [
          IconButton(
              icon: const Icon(CupertinoIcons.left_chevron, size: 28),
              color: _accent,
              onPressed: () => _safeSetState(() => scanned = false)),
          Expanded(
              child: Center(
                  child: Text(l10n.culturalScan,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: _accent)))),
          Container(width: 38), // spacer
        ]),
        const SizedBox(height: 12),
        if (scannedImagePath.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(scannedImagePath),
                    height: 160, fit: BoxFit.cover)),
          ),
        const SizedBox(height: 10),
        if (detectedLang.isNotEmpty)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(CupertinoIcons.globe, color: _accent, size: 18),
            const SizedBox(width: 6),
            Text('Detected: $detectedLang',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: _accent))
          ]),
        const SizedBox(height: 12),
        // horizontal list of improved cards
        if (hasItems)
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: detectedItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final it = detectedItems[idx];
                final isSelected = idx == selectedIndex;
                return InkWell(
                    onTap: () => _safeSetState(() => selectedIndex = idx),
                    child: _buildItemCard(it, isSelected));
              },
            ),
          )
        else
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l10n.noObjectsDetected,
                  style: const TextStyle(color: _accent))),
        const SizedBox(height: 12),
        _buildLangSelector(),
        const SizedBox(height: 16),
        // Detail card
        Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // thumbnail
              if (scannedImagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(scannedImagePath),
                      width: 120, height: 120, fit: BoxFit.cover),
                )
              else
                Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 12),
              // details
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(selectedLabel,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222)))),
                        IconButton(
                            icon:
                                const Icon(Icons.open_in_full, color: _accent),
                            onPressed: () {
                              final full = explanationText.isNotEmpty
                                  ? explanationText
                                  : AppLocalizations.of(context)!
                                      .noObjectsDetected;
                              _openFullScreenExplanation(
                                  selectedLabel.isNotEmpty
                                      ? selectedLabel
                                      : 'Explicación',
                                  full);
                            })
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(CupertinoIcons.book,
                            color: _accent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(l10n.culturalExplanation,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _accent))),
                      ]),
                      const SizedBox(height: 10),
                      // explanation preview area with scroll
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: _explanationMaxHeight),
                        child: Container(
                          padding: const EdgeInsets.only(right: 6),
                          child: Scrollbar(
                            controller: _explanationScrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _explanationScrollController,
                              physics: const BouncingScrollPhysics(),
                              child: SelectableText(
                                explanationText.isNotEmpty
                                    ? explanationText
                                    : AppLocalizations.of(context)!
                                        .noObjectsDetected,
                                style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: Color(0xFF333333)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // score bar + type badge
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Icon(Icons.info_outline, size: 16, color: _muted),
                            const SizedBox(width: 8),
                            Text(
                                detectedItems.isNotEmpty
                                    ? (detectedItems[selectedIndex]
                                        .type
                                        .toUpperCase())
                                    : '-',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w700)),
                          ]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Confianza',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF7A7A7A))),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: (detectedItems.isNotEmpty
                                      ? detectedItems[selectedIndex]
                                          .score
                                          .clamp(0.0, 1.0)
                                      : 0.0),
                                  color: _accent,
                                  backgroundColor: Colors.grey.shade300,
                                  minHeight: 8,
                                ),
                              ]),
                        )
                      ])
                    ]),
              )
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CupertinoButton(
              borderRadius: BorderRadius.circular(14),
              color: _accent,
              onPressed: _resetScan,
              child: Row(children: [
                const Icon(CupertinoIcons.camera, color: Colors.white),
                const SizedBox(width: 8),
                Text(l10n.newScan, style: const TextStyle(color: Colors.white))
              ])),
        ]),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _buildLangSelector() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: idiomas.map((lang) {
          final selected = targetLangCode == lang['code'];
          return GestureDetector(
            onTap: scanning ? null : () => _changeLangAndReload(lang['code']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: selected ? _softRed : Colors.transparent,
                  border: Border.all(color: _accent, width: selected ? 2 : 1),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(lang['icon']!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(lang['label']!,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: _accent))
              ]),
            ),
          );
        }).toList());
  }

  Widget _scanButton(String label, IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      borderRadius: BorderRadius.circular(14),
      color: _accent,
      onPressed: scanning ? null : onPressed,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ignore: unused_element
// ignore: unused_element
class _OcrResultSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _OcrResultSection(
      {required this.icon,
      required this.title,
      required this.content,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: 11),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.1)),
        const SizedBox(height: 6),
        Text(content,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color(0xFF353535),
                height: 1.5))
      ])),
    ]);
  }
}
