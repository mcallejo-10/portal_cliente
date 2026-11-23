import 'package:flutter/material.dart';
import 'package:portal_cliente/styles/app_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

final bool imageProfile = false;

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/logo_Daniel.png'),
              width: 50,
              height: 50,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PORTAL CLIENTE', style: AppStyles.subheadingSmall),
                Text('Inicio', style: AppStyles.headingMedium),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),

          Container(
            decoration: BoxDecoration(color: AppStyles.primaryColor),
            child: imageProfile
                ? Image(image: AssetImage('assets/profile_icon.png'))
                : Text('MC', style: AppStyles.headingMedium),
          ),
        ],

        toolbarHeight: 100.0,
      ),

      body: Center(
        child: Column(children: [Text('Welcome to the Main Screen')]),
      ),
    );
  }
}
