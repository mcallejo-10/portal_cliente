import 'package:flutter/material.dart';

class DocumentsListScreen extends StatefulWidget {
  const DocumentsListScreen({super.key});

  @override
  DocumentsListScreenState createState() => DocumentsListScreenState();
}

class DocumentsListScreenState extends State<DocumentsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Documents List')));
  }
}
