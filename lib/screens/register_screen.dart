import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool loading = false;
  String? errorMsg;

  // Ejemplo: lógica HTTP (simulada)
  Future<void> register() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => loading = false);

    // Corregido: chequea si está montado
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('¡Registro exitoso (demo)!')));
    // Aquí deberías navegar al login o home si el registro es exitoso
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "ULenguage",
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.red[800],
                        letterSpacing: -1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Image.network(
                  'https://res.cloudinary.com/dd5phul5v/image/upload/v1751846282/LOGOTIPO.2_ekafjt.png',
                  height: 150,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registrarte",
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                  ),
                  validator: (value) => value != null && value.length >= 2
                      ? null
                      : 'Nombre muy corto',
                  onChanged: (val) => name = val,
                  style: const TextStyle(fontFamily: 'SFProDisplay'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu correo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                  ),
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Correo inválido',
                  onChanged: (val) => email = val,
                  style: const TextStyle(fontFamily: 'SFProDisplay'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Crea tu contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Mínimo 6 caracteres',
                  onChanged: (val) => password = val,
                  style: const TextStyle(fontFamily: 'SFProDisplay'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Confirma tu contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[700]!),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value == password ? null : 'Las contraseñas no coinciden',
                  onChanged: (val) => confirmPassword = val,
                  style: const TextStyle(fontFamily: 'SFProDisplay'),
                ),
                const SizedBox(height: 16),
                if (errorMsg != null)
                  Text(
                    errorMsg!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              register();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
