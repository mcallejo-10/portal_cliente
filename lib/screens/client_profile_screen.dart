import 'package:flutter/material.dart';
import 'package:portal_cliente/widgets/portal_app_bar.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  ClientProfileScreenState createState() => ClientProfileScreenState();
}

class ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PortalAppBar(title: 'Perfil'),
      body: Center(child: Text('Client Profile')),
    );
  }
}
