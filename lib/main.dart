import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  if (kReleaseMode) {
    debugPrint = (message, {wrapWidth}) => {};
  } else {
    debugPrint = (message, {wrapWidth}) {
      final lines = '$message'.split('\n').map((line) => '[Receptari] $line');
      debugPrintThrottled(lines.join('\n'), wrapWidth: wrapWidth);
    };
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
