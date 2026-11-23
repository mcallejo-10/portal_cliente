import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              spacing: 16.0,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Usuario'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                ElevatedButton(onPressed: () {}, child: Text('Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
