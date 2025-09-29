import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar_temp.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});
  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  bool scanning = false;
  bool scanned = false;
  int _currentIndex = 2;

  void _simulateScan() async {
    setState(() {
      scanning = true;
      scanned = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      scanning = false;
      scanned = true;
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
                child: !scanned
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
                                : "Apunta la cámara a un objeto cultural para escanearlo.",
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
                            onPressed: scanning ? null : _simulateScan,
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
                                  scanning ? "Escaneando..." : "Escanear",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (scanning) ...[
                            const SizedBox(height: 25),
                            const CupertinoActivityIndicator(
                              radius: 17,
                              color: Color(0xFFDA2C38),
                            ),
                          ],
                        ],
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 18),
                          const Center(
                            child: Text(
                              "Resultado de Escaneo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Color(0xFF222222),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              "Análisis Cultural",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Color(0xFF888888),
                                letterSpacing: 0.01,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _CupertinoCard(
                            padding: EdgeInsets.symmetric(
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
                                  content:
                                      "Runa Inka - Escultura ceremonial andina",
                                ),
                                SizedBox(height: 18),
                                _OcrResultSection(
                                  icon: CupertinoIcons.book,
                                  title: "Contexto Cultural",
                                  color: Color(0xFFDA2C38),
                                  content:
                                      "Esta escultura representa a un líder Inka, figura central en la cosmovisión andina. Elementos como el kero (vaso ceremonial) y el bastón simbolizan poder, sabiduría y conexión con los dioses.",
                                ),
                                SizedBox(height: 18),
                                _OcrResultSection(
                                  icon: CupertinoIcons.globe,
                                  title: "Traducciones",
                                  color: Color(0xFFDA2C38),
                                  content:
                                      "Cultural object identified: Inka Ruler Statue",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Imagen resultado: sin fondo amarillo, full width, proporción 5:3
                          Center(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(22),
                              ),
                              child: AspectRatio(
                                aspectRatio: 5 / 3,
                                child: Image.asset(
                                  "assets/inka.png",
                                  fit: BoxFit.cover,
                                ),
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
                                scanned = false;
                                scanning = false;
                              }),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 38,
                              ),
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
