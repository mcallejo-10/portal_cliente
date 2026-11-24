import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class ActivateAccountScreen extends StatefulWidget {
  const ActivateAccountScreen({super.key});

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarEnlace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'invalid-email') {
        _mostrarMensaje('El correo electrónico no es válido.');
        return;
      }
      if (e.code == 'too-many-requests') {
        _mostrarMensaje('Demasiados intentos. Inténtalo de nuevo más tarde.');
        return;
      }
      if (e.code == 'network-request-failed') {
        _mostrarMensaje('Sin conexión. Revisa tu red e inténtalo de nuevo.');
        return;
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }

    if (!mounted) return;
    _mostrarMensaje(
      'Si el correo pertenece a una cuenta invitada, recibirás un enlace para crear tu contraseña.',
    );
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundDefault,
      appBar: AppBar(title: const Text('Activar cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.spacing12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Primera vez', style: AppStyles.headingMedium),
              AppStyles.smallSeparator,
              Text(
                'Introduce el correo con el que te hemos invitado y te enviaremos un enlace para crear tu contraseña.',
                style: AppStyles.bodySmall,
              ),
              AppStyles.mediumSeparator,
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: AppStyles.inputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'contacto@email.com',
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return 'Introduce tu correo electrónico';
                  }
                  if (!_emailRegex.hasMatch(email)) {
                    return 'El correo no tiene un formato válido';
                  }
                  return null;
                },
              ),
              AppStyles.mediumSeparator,
              ElevatedButton(
                onPressed: _loading ? null : _enviarEnlace,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enviar enlace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
