import 'package:flutter/material.dart';
import 'package:portal_cliente/widgets/portal_app_bar.dart';

class DocumentsListScreen extends StatefulWidget {
  const DocumentsListScreen({super.key});

  @override
  DocumentsListScreenState createState() => DocumentsListScreenState();
}

class DocumentsListScreenState extends State<DocumentsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PortalAppBar(title: 'Documentos'),
      body: Center(child: Text('Documents List')),
    );
  }
}
