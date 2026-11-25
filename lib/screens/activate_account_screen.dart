import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import '../widgets/auth_layout.dart';

class ActivateAccountScreen extends StatefulWidget {
  const ActivateAccountScreen({super.key, this.recuperarPassword = false});

  /// `true` cuando se llega desde "¿Has olvidado tu contraseña?". El flujo es
  /// el mismo (enlace por correo para crear la contraseña); solo cambian los
  /// textos.
  final bool recuperarPassword;

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
      widget.recuperarPassword
          ? 'Si el correo pertenece a una cuenta, recibirás un enlace para restablecer tu contraseña.'
          : 'Si el correo pertenece a una cuenta invitada, recibirás un enlace para crear tu contraseña.',
    );
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    final recuperar = widget.recuperarPassword;
    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              recuperar ? 'Recuperar contraseña' : 'Activar cuenta',
              style: AppStyles.subheadingStyle,
            ),
            AppStyles.tinySeparator,
            Text(
              recuperar
                  ? 'Introduce el correo de tu cuenta y te enviaremos un enlace para restablecer tu contraseña.'
                  : 'Introduce el correo con el que te hemos invitado y te enviaremos un enlace para crear tu contraseña.',
              style: AppStyles.bodySmall,
            ),
            AppStyles.mediumSeparator,
            AuthField(
              label: 'Correo electrónico',
              field: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                onFieldSubmitted: (_) {
                  if (!_loading) _enviarEnlace();
                },
                style: AppStyles.inputTextStyle,
                decoration: AppStyles.inputDecoration(
                  hintText: 'contacto@email.com',
                  prefixIcon: Icons.mail_outline,
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
            ),
            const SizedBox(height: AppStyles.spacing24),
            AuthSubmitButton(
              label: 'Enviar enlace',
              loading: _loading,
              onPressed: _enviarEnlace,
            ),
            AppStyles.smallSeparator,
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  size: AppStyles.inputIconSize,
                ),
                label: const Text('Volver a iniciar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
