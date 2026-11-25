import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

/// Layout compartido por las pantallas de acceso (login y activar cuenta):
/// logo, título, subtítulo, tarjeta blanca con el contenido y pie de seguridad.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.child});

  /// Contenido de la tarjeta (formulario).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundLight,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: AppStyles.authScreenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppStyles.authContentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _AuthHeader(),
                  const SizedBox(height: AppStyles.spacing24),
                  Card(
                    color: AppStyles.surfaceWhite,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: AppStyles.cardShadowColor,
                    elevation: AppStyles.cardElevation,
                    shape: AppStyles.cardShape,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: AppStyles.cardContentPadding,
                      child: child,
                    ),
                  ),
                  const SizedBox(height: AppStyles.spacing24),
                  const _AuthFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Etiqueta + campo de formulario, con la etiqueta encima como en el diseño.
class AuthField extends StatelessWidget {
  const AuthField({super.key, required this.label, required this.field});

  final String label;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.fieldLabelStyle),
        const SizedBox(height: AppStyles.spacing8),
        field,
      ],
    );
  }
}

/// Botón principal a todo el ancho, con flecha y estado de carga.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppStyles.buttonHeight,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: AppStyles.buttonIconSize,
                width: AppStyles.buttonIconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppStyles.surfaceWhite,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  const SizedBox(width: AppStyles.spacing8),
                  const Icon(
                    Icons.arrow_forward,
                    size: AppStyles.buttonIconSize,
                  ),
                ],
              ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppStyles.loginScreenLogoShape,
          width: AppStyles.loginScreenLogoShape,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppStyles.surfaceBlue,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/logo_Daniel.png',
            height: AppStyles.loginScreenLogoHeight,
            width: AppStyles.loginScreenLogoWidth,
          ),
        ),
        const SizedBox(height: AppStyles.spacing12),
        const Text.rich(
          TextSpan(
            text: 'Portal ',
            style: AppStyles.titleStyle,
            children: [
              TextSpan(text: 'Cliente', style: AppStyles.blueTitleStyle),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppStyles.spacing4),
        const Text(
          'Portal Inteligente de Gestión Contable y Fiscal',
          style: AppStyles.subtitleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AuthFooter extends StatelessWidget {
  const _AuthFooter();

  @override
  Widget build(BuildContext context) {
    final style = AppStyles.bodySmall.copyWith(color: AppStyles.textSecondary);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: AppStyles.authFooterIconSize,
              color: AppStyles.successColor,
            ),
            const SizedBox(width: AppStyles.spacing4),
            Flexible(child: Text('Conexión cifrada SSL 256-bit', style: style)),
          ],
        ),
        Text(
          'Cumplimiento RGPD & Veri*factu',
          style: style,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
