import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import '../widgets/auth_layout.dart';
import 'activate_account_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  bool _loading = false;
  bool _ocultarPassword = true;
  bool _recordarDispositivo = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // La persistencia de sesión solo es configurable en web; en móvil
      // Firebase mantiene siempre la sesión en el dispositivo.
      if (kIsWeb) {
        await FirebaseAuth.instance.setPersistence(
          _recordarDispositivo ? Persistence.LOCAL : Persistence.SESSION,
        );
      }
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user;
      if (user == null || !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        _mostrarMensaje(
          'Debes verificar tu correo electrónico antes de entrar. Revisa tu bandeja de entrada.',
        );
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _mostrarMensaje(_mensajeError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mensajeError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta está desactivada. Contacta con nosotros.';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo de nuevo más tarde.';
      case 'network-request-failed':
        return 'Sin conexión. Revisa tu red e inténtalo de nuevo.';
      default:
        return 'No se ha podido iniciar sesión. Inténtalo de nuevo.';
    }
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  void _abrirActivarCuenta({bool recuperarPassword = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ActivateAccountScreen(recuperarPassword: recuperarPassword),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Acceso Clientes', style: AppStyles.subheadingStyle),
            AppStyles.tinySeparator,
            const Text(
              'Introduce tus credenciales para acceder a tu despacho virtual',
              style: AppStyles.bodySmall,
            ),
            AppStyles.mediumSeparator,
            AuthField(
              label: 'Correo electrónico',
              field: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
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
            AppStyles.mediumSeparator,
            AuthField(
              label: 'Contraseña',
              field: TextFormField(
                controller: _passwordController,
                obscureText: _ocultarPassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) {
                  if (!_loading) _onLogin();
                },
                style: AppStyles.inputTextStyle,
                decoration: AppStyles.inputDecoration(
                  hintText: 'Tu contraseña',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _ocultarPassword = !_ocultarPassword),
                    tooltip: _ocultarPassword
                        ? 'Mostrar contraseña'
                        : 'Ocultar contraseña',
                    iconSize: AppStyles.inputIconSize,
                    icon: Icon(
                      _ocultarPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce tu contraseña';
                  }
                  return null;
                },
              ),
            ),
            AppStyles.smallSeparator,
            InkWell(
              onTap: () =>
                  setState(() => _recordarDispositivo = !_recordarDispositivo),
              borderRadius: BorderRadius.circular(AppStyles.buttonBorderRadius),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppStyles.spacing4,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _recordarDispositivo,
                      onChanged: (value) =>
                          setState(() => _recordarDispositivo = value ?? false),
                    ),
                    const SizedBox(width: AppStyles.spacing4),
                    const Flexible(
                      child: Text(
                        'Recordar mi dispositivo',
                        style: AppStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppStyles.mediumSeparator,
            AuthSubmitButton(
              label: 'Iniciar Sesión',
              loading: _loading,
              onPressed: _onLogin,
            ),
            AppStyles.smallSeparator,
            Center(
              child: TextButton(
                onPressed: () => _abrirActivarCuenta(recuperarPassword: true),
                child: const Text('¿Has olvidado tu contraseña?'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _abrirActivarCuenta,
                child: const Text('¿Primera vez? Activa tu cuenta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
