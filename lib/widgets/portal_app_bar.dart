import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import 'user_avatar.dart';

/// Barra superior común de las pantallas principales: logo, "PORTAL CLIENTE",
/// título de la pantalla, notificaciones y avatar del usuario.
class PortalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PortalAppBar({
    super.key,
    required this.title,
    this.onNotificationsPressed,
    this.onAvatarPressed,
  });

  /// Título de la pantalla actual ("Inicio", "Documentos"...).
  final String title;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onAvatarPressed;

  @override
  Size get preferredSize => const Size.fromHeight(AppStyles.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: AppStyles.appBarHeight,
      backgroundColor: AppStyles.surfaceWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: AppStyles.spacing16,
      shape: const Border(bottom: BorderSide(color: AppStyles.dividerColor)),
      title: Row(
        children: [
          Image.asset(
            'assets/logo_Daniel.png',
            height: AppStyles.appBarLogoHeight,
            width: AppStyles.appBarLogoWidth,
          ),
          const SizedBox(width: AppStyles.spacing8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PORTAL CLIENTE',
                  style: AppStyles.appBarOverlineStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: AppStyles.appBarTitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onNotificationsPressed ?? () {},
          tooltip: 'Notificaciones',
          color: AppStyles.iconPrimary,
          icon: const Icon(Icons.notifications_outlined),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppStyles.spacing4,
            right: AppStyles.spacing16,
          ),
          child: InkWell(
            onTap: onAvatarPressed,
            customBorder: const CircleBorder(),
            child: UserAvatar(
              name: user?.displayName,
              email: user?.email,
              photoUrl: user?.photoURL,
            ),
          ),
        ),
      ],
    );
  }
}
