import 'package:flutter/material.dart';
import 'package:portal_cliente/widgets/portal_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PortalAppBar(title: 'Inicio'),
      body: Center(
        child: Column(children: [Text('Welcome to the Main Screen')]),
      ),
    );
  }
}
