import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portal_cliente/firebase_options.dart';
import 'package:portal_cliente/screens/home_screen.dart';
import 'package:portal_cliente/screens/login_screen.dart';
import 'package:portal_cliente/styles/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String status = "Cargando...";

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_Daniel.png',
              height: AppStyles.splashScreenLogoHeight,
              width: AppStyles.splashScreenLogoWidth,
            ),
            Text('PORTAL CLIENTE', style: AppStyles.bodySmall),
            AppStyles.mediumSeparator,
            Text(status, style: AppStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 4));
    status = "Cargando base de datos...";
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    final Widget destino = (user != null && user.emailVerified)
        ? const HomeScreen()
        : const LoginScreen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destino),
    );
    setState(() {});
  }
}
