import 'package:flutter/material.dart';

import 'client_profile_screen.dart';
import 'documents_list_screen.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      const MainScreen(),
      const DocumentsListScreen(),
      const ClientProfileScreen(),
    ];

    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          selectedIndex = 0;
          setState(() {});
        }
      },
      child: Scaffold(
        body: IndexedStack(index: selectedIndex, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            selectedIndex = value;
            setState(() {});
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.description_outlined),
              label: "Documentos",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: "Perfil",
            ),
          ],
        ),
      ),
    );
  }
}
