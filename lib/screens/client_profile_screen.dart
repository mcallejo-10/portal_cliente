import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portal_cliente/screens/login_screen.dart';
import 'package:portal_cliente/styles/app_styles.dart';
import 'package:portal_cliente/widgets/portal_app_bar.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  ClientProfileScreenState createState() => ClientProfileScreenState();
}

class ClientProfileScreenState extends State<ClientProfileScreen> {
  bool _signingOut = false;

  Future<void> logOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _signingOut = true);
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      // buidar per no poder tornan enrere
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException {
      if (!mounted) return;
      setState(() => _signingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se ha podido cerrar sesión. Inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: const PortalAppBar(title: 'Perfil'),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (user?.email != null)
              Text(
                user!.email!,
                style: AppStyles.bodyStyle,
                textAlign: TextAlign.center,
              ),
            const Spacer(),
            SizedBox(
              height: AppStyles.buttonHeight,
              child: FilledButton.icon(
                onPressed: _signingOut ? null : logOut,
                icon: _signingOut
                    ? const SizedBox(
                        width: AppStyles.buttonIconSize,
                        height: AppStyles.buttonIconSize,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout, size: AppStyles.buttonIconSize),
                label: const Text('Cerrar sesión'),
                style: AppStyles.logOutButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
