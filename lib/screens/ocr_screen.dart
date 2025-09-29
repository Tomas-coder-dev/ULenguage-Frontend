import 'package:flutter/material.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});
  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  bool scanning = false;
  bool scanned = false;

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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Escaneo (OCR)"),
        backgroundColor: const Color(0xFFDA2C38),
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: !scanned
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 62,
                          color: Color(0xFFDA2C38),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          scanning
                              ? "Escaneando..."
                              : "Apunta la cámara a un objeto cultural para escanearlo.",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Color(0xFF363636),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: scanning ? null : _simulateScan,
                          icon: const Icon(
                            Icons.document_scanner,
                            color: Colors.white,
                          ),
                          label: Text(
                            scanning ? "Escaneando..." : "Escanear",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDA2C38),
                            minimumSize: const Size(180, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        if (scanning) ...[
                          const SizedBox(height: 26),
                          const CircularProgressIndicator(
                            color: Color(0xFFDA2C38),
                          ),
                        ],
                      ],
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Resultado de Escaneo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                              color: Color(0xFF222222),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Center(
                          child: Text(
                            "Análisis Cultural",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Result Card
                        Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 22,
                            ),
                            child: Column(
                              children: [
                                _OcrResultSection(
                                  icon: Icons.language_rounded,
                                  title: "Identificación",
                                  color: Color(0xFFDA2C38),
                                  content:
                                      "Runa Inka - Escultura ceremonial andina",
                                ),
                                SizedBox(height: 18),
                                _OcrResultSection(
                                  icon: Icons.menu_book_rounded,
                                  title: "Contexto Cultural",
                                  color: Color(0xFFDA2C38),
                                  content:
                                      "Esta escultura representa a un líder Inka, figura central en la cosmovisión andina. Elementos como el kero (vaso ceremonial) y el bastón simbolizan poder, sabiduría y conexión con los dioses.",
                                ),
                                SizedBox(height: 18),
                                _OcrResultSection(
                                  icon: Icons.g_translate_rounded,
                                  title: "Traducciones",
                                  color: Color(0xFFDA2C38),
                                  content:
                                      "Cultural object identified: Inka Ruler Statue",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Imagen resultado
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: const Color(0xFF222222),
                            child: Image.network(
                              "https://i.ibb.co/rv8yZgZ/inka-ocr-demo.png",
                              fit: BoxFit.cover,
                              height: 280,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        ElevatedButton.icon(
                          onPressed: () => setState(() {
                            scanned = false;
                            scanning = false;
                          }),
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Nuevo Escaneo",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDA2C38),
                            minimumSize: const Size(160, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
            ),
          ),
        ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FA),
        borderRadius: BorderRadius.circular(15),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.14), width: 1.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF353535),
                    height: 1.35,
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
