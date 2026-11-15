import 'package:flutter/material.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key});

  @override
  InvoiceDetailScreenState createState() => InvoiceDetailScreenState();
}

class InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Invoice Detail')));
  }
}
