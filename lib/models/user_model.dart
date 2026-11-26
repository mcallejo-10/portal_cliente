import 'api_response.dart';

enum UserRole { cliente, gestor, unknown }

enum ClientStatus { activo, semiactivo, inactivo, unknown }

enum AeatStatus { conectado, noConectado, pendiente, unknown }

class PortalClient {
  const PortalClient({
    required this.nif,
    required this.name,
    required this.status,
    required this.address,
  });

  final String nif;
  final String name;
  final ClientStatus status;
  final String address;

  factory PortalClient.fromJson(Map<String, dynamic> json) {
    return PortalClient(
      nif: json['nif'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: enumFromApi(ClientStatus.values, json['status'], ClientStatus.unknown),
      address: json['address'] as String? ?? '',
    );
  }
}

class PortalProfile {
  const PortalProfile({
    required this.email,
    required this.role,
    required this.client,
    required this.managerEmail,
    required this.memberSince,
    required this.lastLoginAt,
  });

  final String email;
  final UserRole role;
  final PortalClient client;
  final String managerEmail;
  final String memberSince;
  final String lastLoginAt;

  factory PortalProfile.fromJson(Map<String, dynamic> json) {
    return PortalProfile(
      email: json['email'] as String? ?? '',
      role: enumFromApi(UserRole.values, json['role'], UserRole.unknown),
      client: PortalClient.fromJson(
        json['client'] as Map<String, dynamic>? ?? const {},
      ),
      managerEmail: json['managerEmail'] as String? ?? '',
      memberSince: json['memberSince'] as String? ?? '',
      lastLoginAt: json['lastLoginAt'] as String? ?? '',
    );
  }
}

class RegisterClientResult {
  const RegisterClientResult({required this.registered, required this.profile});

  final bool registered;
  final PortalProfile profile;

  factory RegisterClientResult.fromJson(Map<String, dynamic> json) {
    return RegisterClientResult(
      registered: json['registered'] as bool? ?? false,
      profile: PortalProfile.fromJson(
        json['profile'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
