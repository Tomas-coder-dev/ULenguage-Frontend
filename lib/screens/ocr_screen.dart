import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/navbar_temp.dart';

class OcrObject {
  final String name;
  final double score;
  final List boundingBox;
  final String explanation;
  final String translation;
  OcrObject({
    required this.name,
    required this.score,
    required this.boundingBox,
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
  int _currentIndex = 2;

  List<OcrObject> detectedObjects = [];
  OcrObject? selectedObject;
  String errorMsg = '';

  Future<void> _pickAndScanImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      scanning = true;
      scanned = false;
      detectedObjects = [];
      selectedObject = null;
      errorMsg = '';
    });

    try {
      final uri = Uri.parse(
        'http://192.168.100.7:5000/api/analyze-and-explain',
      ); // Cambia si tu endpoint es diferente
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', pickedFile.path),
      );
      // Si tu backend espera targetLang, envíalo
      request.fields['targetLang'] = 'es';

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);

        // Arma la lista de objetos a mostrar (uno por objeto detectado)
        detectedObjects = [];
        final objects = data['objects'] ?? [];
        final explanations = data['explanations'] ?? [];
        final translations = data['translations'] ?? [];

        for (int i = 0; i < objects.length; i++) {
          detectedObjects.add(
            OcrObject(
              name: objects[i]['name'] ?? '',
              score: objects[i]['score']?.toDouble() ?? 0.0,
              boundingBox: objects[i]['boundingBox'] ?? [],
              explanation: explanations.length > i ? explanations[i] : '',
              translation: translations.length > i ? translations[i] : '',
            ),
          );
        }
        setState(() {
          scanning = false;
          scanned = true;
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

  void _selectObject(OcrObject obj) {
    setState(() {
      selectedObject = obj;
    });
  }

  void _resetScan() {
    setState(() {
      scanning = false;
      scanned = false;
      detectedObjects = [];
      selectedObject = null;
      errorMsg = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F7FA);

    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Escaneo (OCR)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFDA2C38),
        border: null,
      ),
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: (!scanned)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.camera_viewfinder,
                            size: 64,
                            color: Color(0xFFDA2C38),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            scanning
                                ? "Escaneando..."
                                : "Selecciona una imagen para analizar y detectar objetos culturales.",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF363636),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 38),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 38,
                              vertical: 15,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            onPressed: scanning ? null : _pickAndScanImage,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  scanning
                                      ? CupertinoIcons.time
                                      : CupertinoIcons.doc_text_viewfinder,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  scanning
                                      ? "Escaneando..."
                                      : "Escanear Imagen",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (scanning) const SizedBox(height: 25),
                          if (scanning)
                            const CupertinoActivityIndicator(
                              radius: 17,
                              color: Color(0xFFDA2C38),
                            ),
                          if (errorMsg.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Text(
                              errorMsg,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      )
                    : selectedObject == null
                    ? Column(
                        children: [
                          const SizedBox(height: 18),
                          const Center(
                            child: Text(
                              "Objetos Detectados",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xFF222222),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (errorMsg.isNotEmpty)
                            Text(
                              errorMsg,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ...detectedObjects.map(
                            (obj) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(18),
                                color: const Color(0xFFFCE7E9),
                                onPressed: () => _selectObject(obj),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.doc_text,
                                      color: Color(0xFFDA2C38),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        obj.name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFDA2C38),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      CupertinoIcons.right_chevron,
                                      color: Color(0xFFDA2C38),
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          CupertinoButton(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0xFFDA2C38),
                            onPressed: _resetScan,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 9),
                                Text(
                                  "Nuevo Escaneo",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 18),
                          Center(
                            child: Text(
                              selectedObject!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Color(0xFF222222),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              "Análisis Cultural",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Color(0xFF888888),
                                letterSpacing: 0.01,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _CupertinoCard(
                            padding: const EdgeInsets.symmetric(
                              vertical: 19,
                              horizontal: 19,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _OcrResultSection(
                                  icon: CupertinoIcons.textformat_alt,
                                  title: "Identificación",
                                  color: Color(0xFFDA2C38),
                                  content: selectedObject!.name,
                                ),
                                const SizedBox(height: 18),
                                _OcrResultSection(
                                  icon: CupertinoIcons.book,
                                  title: "Explicación Cultural",
                                  color: Color(0xFFDA2C38),
                                  content: selectedObject!.explanation,
                                ),
                                const SizedBox(height: 18),
                                _OcrResultSection(
                                  icon: CupertinoIcons.globe,
                                  title: "Traducción",
                                  color: Color(0xFFDA2C38),
                                  content: selectedObject!.translation,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          if (selectedObject!.boundingBox.isNotEmpty)
                            Center(
                              child: Text(
                                "Bounding Box: ${selectedObject!.boundingBox.map((v) => '(${v['x']}, ${v['y']})').join(', ')}",
                                style: const TextStyle(
                                  color: Color(0xFFDA2C38),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 28),
                          Center(
                            child: CupertinoButton.filled(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              onPressed: () => setState(() {
                                selectedObject = null;
                              }),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 38,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.chevron_left,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 9),
                                  Text(
                                    "Volver",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
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
        Icon(icon, color: color, size: 25),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5,
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

class _CupertinoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _CupertinoCard({required this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
