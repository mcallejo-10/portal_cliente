import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

/// Avatar circular del usuario: muestra la foto si existe y, si no, sus
/// iniciales sobre el color primario.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.name,
    this.email,
    this.photoUrl,
    this.size = AppStyles.avatarSize,
  });

  final String? name;
  final String? email;
  final String? photoUrl;
  final double size;

  /// Iniciales a partir del nombre ("Miranda Callejón" -> "MC") o, si no hay
  /// nombre, del correo ("ana.ruiz@x.com" -> "AR", "contacto@x.com" -> "CO").
  static String initialsFrom({String? name, String? email}) {
    final nombre = name?.trim() ?? '';
    final origen = nombre.isNotEmpty
        ? nombre
        : (email ?? '').split('@').first.trim();
    final partes = origen
        .split(RegExp(r'[\s._\-+]+'))
        .where((parte) => parte.isNotEmpty)
        .toList();
    if (partes.isEmpty) return '';
    if (partes.length == 1) {
      return partes.first.characters.take(2).toString().toUpperCase();
    }
    return (partes.first.characters.first + partes[1].characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final foto = photoUrl?.trim() ?? '';
    final iniciales = initialsFrom(name: name, email: email);

    final Widget placeholder = iniciales.isEmpty
        ? Icon(
            Icons.person_outline,
            size: size * 0.55,
            color: AppStyles.surfaceWhite,
          )
        : Text(
            iniciales,
            style: AppStyles.avatarInitialsStyle.copyWith(
              fontSize:
                  AppStyles.avatarInitialsStyle.fontSize! *
                  (size / AppStyles.avatarSize),
            ),
          );

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppStyles.avatarBackground,
        shape: BoxShape.circle,
      ),
      child: foto.isEmpty
          ? placeholder
          : Image.network(
              foto,
              height: size,
              width: size,
              fit: BoxFit.cover,
              // Si la foto falla al cargar, se muestran las iniciales.
              errorBuilder: (context, error, stackTrace) => placeholder,
            ),
    );
  }
}
