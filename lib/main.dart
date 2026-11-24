import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portal_cliente/screens/splash_screen.dart';
import 'package:portal_cliente/styles/app_styles.dart';

void main() {
  if (kReleaseMode) {
    debugPrint = (message, {wrapWidth}) => {};
  } else {
    debugPrint = (message, {wrapWidth}) {
      final lines = '$message'.split('\n').map((line) => '[Receptari] $line');
      debugPrintThrottled(lines.join('\n'), wrapWidth: wrapWidth);
    };
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppStyles.appTheme, home: const SplashScreen());
  }
}
