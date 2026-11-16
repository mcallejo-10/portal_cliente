import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:portal_cliente/widgets/navigation_destination.dart';

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
            Navigation(
              icon: Symbols.home,
              selected: selectedIndex == 0,
              label: "Home",
            ),
            Navigation(
              icon: Symbols.description,
              selected: selectedIndex == 1,
              label: "Documentos",
            ),
            Navigation(
              icon: Symbols.person,
              selected: selectedIndex == 2,
              label: "Perfil",
            ),
          ],
        ),
      ),
    );
  }
}
