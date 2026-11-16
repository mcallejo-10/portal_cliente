import 'package:flutter/material.dart';
import 'package:portal_cliente/styles/app_styles.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.icon,
    required this.selected,
    required this.label,
  });

  final IconData icon;
  final bool selected;
  final String label;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  NavigationDestination build(BuildContext context) {
    final label = widget.label;
    final selected = widget.selected;

    return NavigationDestination(
      icon: Icon(
        widget.icon,
        size: AppStyles.iconSize,
        color: AppStyles.iconSecondary,
      ),
      selectedIcon: Icon(
        widget.icon,
        size: AppStyles.iconSize,
        color: AppStyles.iconActive,
      ),
      label: label,
    );
  }
}
