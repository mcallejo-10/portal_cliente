import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundDefault,
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.spacing12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppStyles.bigSeparator,
            Padding(
              padding: const EdgeInsets.all(AppStyles.spacing8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppStyles.surfaceBlue,
                      shape: BoxShape.circle,
                    ),
                    height: AppStyles.loginScreenLogoShape,
                    width: AppStyles.loginScreenLogoShape,
                  ),
                  Image.asset(
                    'assets/logo_Daniel.png',
                    height: AppStyles.loginScreenLogoHeight,
                    width: AppStyles.loginScreenLogoWidth,
                  ),
                ],
              ),
            ),
            AppStyles.mediumSeparator,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Portal', style: AppStyles.titleStyle),
                AppStyles.smallSeparator,
                Text('Cliente', style: AppStyles.blueTitleStyle),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.spacing12,
              ),
              child: Text(
                'Portal Inteligente de Gestión Contable y Fiscal',
                style: AppStyles.bodyLarge,
              ),
            ),
            AppStyles.mediumSeparator,
            Card(
              elevation: AppStyles.cardElevation,
              shape: AppStyles.cardShape,
              margin: EdgeInsets.all(AppStyles.spacing12),
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppStyles.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Acceso clientes',
                            style: AppStyles.headingMedium,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'Introduce tus credenciales para acceder al portal.',
                            style: AppStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: AppStyles.spacing16),
                          Text('Correo electrónico'),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: AppStyles.inputDecoration(
                              labelText: 'contacto@email.com',
                              hintText: 'Correo electrónico',
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
                          AppStyles.smallSeparator,
                          Text('Contraseña'),
                          TextFormField(
                            controller: _passwordController,
                            decoration: AppStyles.inputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Introduce tu contraseña',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Introduce tu contraseña';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: _loading ? null : _onLogin,
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('Login'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ActivateAccountScreen(),
                              ),
                            ),
                            child: const Text('¿Primera vez? Activa tu cuenta'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
