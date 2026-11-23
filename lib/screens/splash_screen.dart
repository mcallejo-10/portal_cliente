import 'package:flutter/material.dart';
import 'package:portal_cliente/screens/home_screen.dart';
import 'package:portal_cliente/styles/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
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
    await Future.delayed(Duration(seconds: 2));
    status = "Cargando base de datos...";
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );

    setState(() {});
  }
}
