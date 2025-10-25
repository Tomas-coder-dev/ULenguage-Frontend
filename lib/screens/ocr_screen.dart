import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Usa la import correcta para tu estructura (desde lib/screens hacia lib/l10n)
import '../../l10n/app_localizations.dart';

// Modelo de objeto detectado
class OcrObject {
  final String name;
  final String explanation;
  final String translation;
  OcrObject({
    required this.name,
    required this.explanation,
    required this.translation,
  });
}

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});
  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  bool scanning = false;
  bool scanned = false;
  String errorMsg = '';
  String scannedImagePath = '';
  OcrObject? selectedObject;
  List<OcrObject> detectedObjects = [];
  String detectedLang = '';

  final idiomas = [
    {'label': 'Español', 'code': 'es', 'icon': '🇪🇸'},
    {'label': 'Inglés', 'code': 'en', 'icon': '🇺🇸'},
    {'label': 'Quechua', 'code': 'qu', 'icon': '🦙'},
  ];
  String targetLangCode = 'es';

  Future<void> _pickAndScanImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      scanning = true;
      scanned = false;
      detectedObjects = [];
      selectedObject = null;
      errorMsg = '';
      scannedImagePath = pickedFile.path;
      detectedLang = '';
    });

    await _scanImageAndFetchObjects(pickedFile.path, targetLangCode);
  }

  Future<void> _scanImageAndFetchObjects(
    String imagePath,
    String langCode,
  ) async {
    try {
      final uri = Uri.parse('http://15.228.188.14:5000/api/ocr/analyze');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['targetLang'] = langCode;

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        detectedObjects = [];
        final objects = data['objects'] ?? [];
        final explanations = data['explanations'] ?? [];
        final translations = data['translations'] ?? [];
        detectedLang = data['detectedLang'] ?? '';
        for (int i = 0; i < objects.length; i++) {
          detectedObjects.add(
            OcrObject(
              name: objects[i]['name'] ?? '',
              explanation: explanations.length > i ? explanations[i] : '',
              translation: translations.length > i ? translations[i] : '',
            ),
          );
        }
        setState(() {
          scanning = false;
          scanned = true;
          selectedObject =
              detectedObjects.isNotEmpty ? detectedObjects[0] : null;
          errorMsg = detectedObjects.isEmpty ? 'No se detectaron objetos.' : '';
        });
      } else {
        setState(() {
          scanning = false;
          errorMsg = 'Error de escaneo OCR';
        });
      }
    } catch (e) {
      setState(() {
        scanning = false;
        errorMsg = 'Error de conexión';
      });
    }
  }

  void _resetScan() => setState(() {
        scanning = false;
        scanned = false;
        detectedObjects = [];
        selectedObject = null;
        errorMsg = '';
        scannedImagePath = '';
        detectedLang = '';
      });

  Future<void> _changeLangAndReload(String langCode) async {
    setState(() {
      scanning = true;
      errorMsg = '';
      targetLangCode = langCode;
    });
    await _scanImageAndFetchObjects(scannedImagePath, langCode);
    if (selectedObject != null && detectedObjects.isNotEmpty) {
      final idx = detectedObjects.indexWhere(
        (o) => o.name == selectedObject!.name,
      );
      setState(() => selectedObject = idx != -1 ? detectedObjects[idx] : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFDA2C38);
    final softRed = const Color(0xFFFCE7E9);
    final bgColor = const Color(0xFFF8F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 600
                  ? 520
                  : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: (!scanned)
                  ? _buildInitial(accent, softRed)
                  : selectedObject == null
                      ? _buildNoObjects(accent, softRed)
                      : _buildObjectDetail(
                          context,
                          selectedObject!,
                          accent,
                          softRed,
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitial(Color accent, Color softRed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.camera_viewfinder,
          size: 62,
          color: Color(0xFFDA2C38),
        ),
        if (scannedImagePath.isNotEmpty) ...[
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(scannedImagePath),
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        ],
        const SizedBox(height: 15),
        Text(
          scanning
              ? "Escaneando..."
              : "Escanea una imagen y selecciona el idioma de la información cultural.",
          style: TextStyle(
            fontSize: 17,
            color: accent,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _buildLangSelector(accent, softRed),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _scanButton(
              "Galería",
              CupertinoIcons.photo,
              accent,
              softRed,
              () => _pickAndScanImage(ImageSource.gallery),
            ),
            const SizedBox(width: 13),
            _scanButton(
              "Foto",
              CupertinoIcons.camera,
              accent,
              softRed,
              () => _pickAndScanImage(ImageSource.camera),
            ),
          ],
        ),
        if (scanning) ...[
          const SizedBox(height: 17),
          CupertinoActivityIndicator(radius: 15, color: Color(0xFFDA2C38)),
        ],
        if (errorMsg.isNotEmpty) ...[
          const SizedBox(height: 13),
          Text(
            errorMsg,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildNoObjects(Color accent, Color softRed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (scannedImagePath.isNotEmpty) ...[
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(scannedImagePath),
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        ],
        const SizedBox(height: 15),
        Text(
          "No se detectaron objetos.",
          style: TextStyle(
            fontSize: 17,
            color: accent,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _buildLangSelector(accent, softRed),
        const SizedBox(height: 15),
        CupertinoButton(
          borderRadius: BorderRadius.circular(16),
          color: accent,
          onPressed: _resetScan,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.camera, color: Colors.white, size: 18),
              SizedBox(width: 7),
              Text(
                "Nuevo Escaneo",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLangSelector(Color accent, Color softRed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...idiomas.map((lang) {
          final selected = targetLangCode == lang['code'];
          return GestureDetector(
            onTap: scanning ? null : () => _changeLangAndReload(lang['code']!),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? softRed : Colors.transparent,
                border: Border.all(color: accent, width: selected ? 2 : 1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang['icon']!, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 5),
                  Text(
                    lang['label']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accent,
                      fontSize: 16,
                      letterSpacing: 0.2,
                      decoration: selected
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: accent,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _scanButton(
    String label,
    IconData icon,
    Color accent,
    Color softRed,
    VoidCallback onPressed,
  ) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(14),
      color: accent,
      onPressed: scanning ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 19),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectDetail(
    BuildContext context,
    OcrObject obj,
    Color accent,
    Color softRed,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.left_chevron,
                  color: accent,
                  size: 27,
                ),
                onPressed: () => setState(() => selectedObject = null),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Escaneo Cultural",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accent,
                      fontSize: 20,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 38),
            ],
          ),
          if (scannedImagePath.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(scannedImagePath),
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 7),
          Text(
            obj.name,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: accent,
              letterSpacing: 0.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildLangSelector(accent, softRed),
          const SizedBox(height: 10),
          if (detectedLang.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.globe, color: accent, size: 20),
                const SizedBox(width: 4),
                Text(
                  "Idioma detectado: $detectedLang",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: accent,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 9),
          Center(
            child: Text(
              "Análisis Cultural",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: accent.withOpacity(0.65),
                letterSpacing: 0.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OcrResultSection(
                    icon: CupertinoIcons.textformat_alt,
                    title: "Identificación",
                    color: accent,
                    content: obj.name,
                  ),
                  const SizedBox(height: 12),
                  _OcrResultSection(
                    icon: CupertinoIcons.book,
                    title: "Explicación Cultural",
                    color: accent,
                    content: obj.explanation,
                  ),
                  const SizedBox(height: 12),
                  _OcrResultSection(
                    icon: CupertinoIcons.globe,
                    title: "Traducción",
                    color: accent,
                    content: obj.translation,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          CupertinoButton(
            borderRadius: BorderRadius.circular(16),
            color: accent,
            onPressed: _resetScan,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.camera, color: Colors.white, size: 18),
                SizedBox(width: 7),
                Text(
                  "Nuevo Escaneo",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OcrResultSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  const _OcrResultSection({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Color(0xFF353535),
                  height: 1.37,
                  letterSpacing: 0.01,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
