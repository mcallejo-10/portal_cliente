T enumFromApi<T extends Enum>(List<T> values, Object? raw, T fallback) {
  if (raw is! String) return fallback;
  final target = raw.toLowerCase().replaceAll('_', '');
  for (final value in values) {
    if (value.name.toLowerCase() == target) return value;
  }
  return fallback;
}

enum ApiErrorCode {
  authRequired,
  authInvalid,
  authExpired,
  accountPending,
  accountDisabled,
  forbidden,
  notFound,
  validationError,
  rateLimited,
  duplicate,
  fileTooLarge,
  unsupportedMediaType,
  clientFolderNotReady,
  internalError,
  unknown,
}

class ApiError {
  const ApiError({required this.code, required this.message});

  final ApiErrorCode code;
  final String message;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: enumFromApi(ApiErrorCode.values, json['code'], ApiErrorCode.unknown),
      message: json['message'] as String? ?? '',
    );
  }
}

class ApiResponse<T> {
  const ApiResponse({
    required this.ok,
    required this.apiVersion,
    required this.requestId,
    required this.data,
    required this.error,
    required this.serverTime,
  });

  final bool ok;
  final String apiVersion;
  final String requestId;
  final T? data;
  final ApiError? error;
  final String serverTime;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? data) fromData,
  ) {
    final rawError = json['error'];
    return ApiResponse<T>(
      ok: json['ok'] as bool? ?? false,
      apiVersion: json['apiVersion'] as String? ?? '1',
      requestId: json['requestId'] as String? ?? '',
      data: json['data'] == null ? null : fromData(json['data']),
      error: rawError is Map<String, dynamic> ? ApiError.fromJson(rawError) : null,
      serverTime: json['serverTime'] as String? ?? '',
    );
  }
}

class PingResult {
  const PingResult({required this.pong, required this.version, required this.serverTime});

  final bool pong;
  final String version;
  final String serverTime;

  factory PingResult.fromJson(Map<String, dynamic> json) {
    return PingResult(
      pong: json['pong'] as bool? ?? false,
      version: json['version'] as String? ?? '',
      serverTime: json['serverTime'] as String? ?? '',
    );
  }
}
