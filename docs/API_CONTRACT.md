# Contrato de la API — Portal Cliente

**Estado:** Fases 0, 1, 2, 3 y 4 implementadas; la Fase 4 es aproximada y
pendiente de validación fiscal (`ping`, `registerClient`, `getProfile`,
`getInvoices`, `getInvoice`, `getInvoiceFile`, `uploadInvoice`,
`getUploadStatus`, `getDashboard`). Los endpoints marcados como **(borrador)**
todavía no están implementados y sus campos pueden cambiar al llegar su fase.

**Versión de API:** `1`

Este documento es el contrato que consume la app Flutter. La fuente de verdad del
alcance sigue siendo `docs/PLAN_PORTAL_CLIENTE_API.md`.

---

## 1. Transporte

- Todas las acciones son `POST` con `Content-Type: application/json`.
- El ID token de Firebase viaja en el **cuerpo JSON** (`idToken`), nunca en una
  cabecera: Apps Script no expone cabeceras HTTP de forma fiable.
- Apps Script responde con un `302` hacia `googleusercontent.com`. El cliente HTTP
  debe seguir la redirección (`followRedirects` en `http`/`dio`) y evaluar siempre
  el campo `ok` del JSON, no el código HTTP.
- El MVP es móvil; CORS no aplica. Flutter Web necesitará un proxy u otra solución.

### Petición

```json
{
  "action": "getProfile",
  "apiVersion": "1",
  "idToken": "eyJhbGciOi...",
  "data": {}
}
```

`apiVersion` es opcional, pero si se envía debe ser `"1"`.

### Respuesta correcta

```json
{
  "ok": true,
  "apiVersion": "1",
  "requestId": "uuid",
  "data": {},
  "error": null,
  "serverTime": "2026-11-15T10:00:00+01:00"
}
```

### Respuesta de error

```json
{
  "ok": false,
  "apiVersion": "1",
  "requestId": "uuid",
  "data": null,
  "error": {
    "code": "AUTH_INVALID",
    "message": "Token caducado o inválido"
  },
  "serverTime": "2026-11-15T10:00:00+01:00"
}
```

`requestId` sirve para soporte y trazabilidad. No contiene datos personales.

---

## 2. Códigos de error

| Código                    | Significado para la app                                                       |
| ------------------------- | ----------------------------------------------------------------------------- |
| `AUTH_REQUIRED`           | Falta el `idToken`.                                                           |
| `AUTH_INVALID`            | Token inválido o no reconocido por Firebase.                                  |
| `AUTH_EXPIRED`            | Token caducado. Renovar con `getIdToken(true)`.                               |
| `ACCOUNT_PENDING`         | El usuario existe pero no está activo o no ha reclamado la invitación.        |
| `ACCOUNT_DISABLED`        | El usuario está bloqueado.                                                    |
| `FORBIDDEN`               | Sin permiso (email no verificado, cliente inactivo, invitación no válida).    |
| `NOT_FOUND`               | Recurso inexistente o ajeno. No revela existencia de datos de otros clientes. |
| `VALIDATION_ERROR`        | Petición mal formada o campos obligatorios ausentes.                          |
| `RATE_LIMITED`            | Demasiados intentos o solicitud en curso. Reintentar más tarde.               |
| `DUPLICATE`               | Documento ya subido (Fase 3).                                                 |
| `FILE_TOO_LARGE`          | Archivo por encima del límite (Fase 3).                                       |
| `UNSUPPORTED_MEDIA_TYPE`  | MIME no permitido (Fase 3).                                                   |
| `CLIENT_FOLDER_NOT_READY` | El cliente no tiene INBOX disponible (Fase 3).                                |
| `INTERNAL_ERROR`          | Error del servidor. Mostrar mensaje genérico y usar `requestId`.              |

Límite de peticiones: 120 por minuto y usuario (UID), contando todas las
acciones autenticadas y `registerClient`. Al superarlo se responde `RATE_LIMITED`
hasta el minuto siguiente.

Ante `AUTH_INVALID`/`AUTH_EXPIRED`: renovar el token una vez y reintentar. Ante
`ACCOUNT_PENDING`: mostrar pantalla de cuenta pendiente, sin datos de cliente.

---

## 3. Flujo de autenticación

1. Flutter autentica con Firebase (`firebase_auth`, Email/Password).
2. Antes de cada llamada obtiene un token con `getIdToken(true)`.
3. Envía `action`, `apiVersion` e `idToken` en el cuerpo.
4. El backend verifica el token en servidor (`accounts:lookup`) y deriva el UID.
5. La primera vez, `registerClient` consume una invitación y activa la cuenta.
6. A partir de ahí, `getProfile` y el resto de endpoints exigen
   `PORTAL_USERS.ESTADO=ACTIVO`.

**Registro por invitación (implementado):**

- La gestoría crea una fila en `PORTAL_USERS` con `EMAIL`, `NIF_CLIENTE`,
  `ESTADO=PENDIENTE`, `INVITE_HASH` y `INVITE_EXPIRES_AT`.
- El cliente recibe el código por un canal externo y llama a `registerClient`.
- Se exige `emailVerified=true` en Firebase.
- La invitación es de un solo uso, caduca y tiene límite de intentos.

No existe registro abierto en esta versión. Un usuario sin invitación no obtiene
datos de cliente.

---

## 4. Endpoints implementados

### 4.1 `ping`

Comprueba conectividad y versión. No requiere token.

**Petición**

```json
{ "action": "ping", "apiVersion": "1", "data": {} }
```

**Respuesta `data`**

```json
{
  "pong": true,
  "version": "1",
  "serverTime": "2026-11-15T10:00:00+01:00"
}
```

### 4.2 `registerClient`

Activa la cuenta consumiendo una invitación. Requiere token con email verificado.

**Petición**

```json
{
  "action": "registerClient",
  "apiVersion": "1",
  "idToken": "eyJhbGciOi...",
  "data": {
    "inviteCode": "codigo-recibido-de-la-gestoria"
  }
}
```

`inviteCode` es obligatorio. No se acepta `uid`, `nif` ni `email` como identidad.

**Respuesta `data`**

```json
{
  "registered": true,
  "profile": {
    "email": "cliente@example.com",
    "role": "CLIENTE",
    "client": {
      "nif": "B12345678",
      "name": "Cliente SL",
      "status": "ACTIVO",
      "address": "Calle Ejemplo 1"
    },
    "managerEmail": "gestor@example.com",
    "memberSince": "",
    "lastLoginAt": "2026-11-15T10:00:00+01:00"
  }
}
```

Errores habituales: `FORBIDDEN` (email no verificado, invitación inválida,
caducada o ya usada, cliente inactivo), `VALIDATION_ERROR` (falta `inviteCode`),
`RATE_LIMITED` (exceso de intentos).

### 4.3 `getProfile`

Devuelve el perfil del cliente autenticado. Requiere token y cuenta activa.

**Petición**

```json
{
  "action": "getProfile",
  "apiVersion": "1",
  "idToken": "eyJhbGciOi...",
  "data": {}
}
```

**Respuesta `data`**

```json
{
  "email": "cliente@example.com",
  "role": "CLIENTE",
  "client": {
    "nif": "B12345678",
    "name": "Cliente SL",
    "status": "ACTIVO",
    "address": "Calle Ejemplo 1"
  },
  "managerEmail": "gestor@example.com",
  "memberSince": "2026-01-01T09:00:00+01:00",
  "lastLoginAt": "2026-11-10T09:00:00+01:00"
}
```

`client.status` es el estado del cliente en la gestoría, leído de
`CLIENTS_REGISTRY.STATUS`: `ACTIVO`, `SEMIACTIVO` o `INACTIVO`. La API solo deja
entrar a clientes `ACTIVO` o `SEMIACTIVO`. No hay estado AEAT: los clientes no
tienen alta directa en AEAT.

Errores habituales: `AUTH_REQUIRED`, `AUTH_INVALID`, `AUTH_EXPIRED`,
`ACCOUNT_PENDING`, `ACCOUNT_DISABLED`, `FORBIDDEN`.

---

## 5. Consulta de facturas y endpoints previstos

`getInvoices`, `getInvoice` y `getInvoiceFile` están implementados (Fase 2),
así como `uploadInvoice` y `getUploadStatus` (Fase 3). `getDashboard` (Fase 4)
está implementado de forma aproximada. Los endpoints de Fase 5 siguen marcados
como **(borrador)**.

### 5.1 `getInvoices` (Fase 2 — implementado)

**Petición `data`**

```json
{
  "tipo": "RECIBIDAS",
  "status": "REVISADO",
  "search": "proveedor",
  "dateFrom": "2026-01-01",
  "dateTo": "2026-03-31",
  "page": 1,
  "pageSize": 20,
  "includeArchived": false
}
```

- `tipo`: `TODAS` | `EMITIDAS` | `RECIBIDAS` | `TICKETS`.
- `page` empieza en 1. `pageSize` máximo 50.
- Fechas en formato ISO `YYYY-MM-DD`.
- `search`: nombre, NIF o número de factura, sin distinguir mayúsculas.

**Respuesta `data`**

```json
{
  "items": [
    {
      "id": "1AbC...",
      "type": "RECIBIDA",
      "issueDate": "2026-01-15",
      "number": "F-2026-001",
      "counterparty": { "name": "Proveedor SL", "nif": "B12345678" },
      "base": 100.0,
      "vat": 21.0,
      "irpf": 0.0,
      "total": 121.0,
      "currency": "EUR",
      "status": "REVISADO",
      "hasPdf": true
    }
  ],
  "page": 1,
  "pageSize": 20,
  "total": 18
}
```

### 5.2 `getInvoice` (Fase 2 — implementado)

**Petición `data`:** `{ "invoiceId": "1AbC..." }`

**Respuesta `data`:** misma forma que un item de `getInvoices`, más campos de
detalle y revisión:

```json
{
  "id": "1AbC...",
  "type": "RECIBIDA",
  "issueDate": "2026-01-15",
  "number": "F-2026-001",
  "counterparty": { "name": "Proveedor SL", "nif": "B12345678" },
  "base": 100.0,
  "vat": 21.0,
  "irpf": 0.0,
  "total": 121.0,
  "currency": "EUR",
  "status": "REVISADO",
  "hasPdf": true,
  "reviewedBy": "gestor@example.com",
  "reviewedAt": "2026-01-20T12:00:00+01:00"
}
```

Facturas de otro cliente responden `NOT_FOUND`, no `FORBIDDEN`.

### 5.3 `getInvoiceFile` (Fase 2 — implementado)

**Petición `data`:** `{ "invoiceId": "1AbC..." }`

**Respuesta `data`:** `{ "fileId": "...", "fileName": "...", "mimeType": "application/pdf", "contentBase64": "..." }`

Nota: Base64 aumenta el tamaño ~33 %. La app debe comprimir imágenes y mostrar
estados de carga.

### 5.4 `uploadInvoice` (Fase 3 — implementado)

**Petición `data`:**

```json
{
  "fileName": "factura.pdf",
  "mimeType": "application/pdf",
  "contentBase64": "JVBERi0x..."
}
```

Límite de configuración: `PORTAL_MAX_UPLOAD_MB` (10 MB, ~13 MB en Base64). El
servidor valida que el MIME esté permitido, que la cabecera real del archivo
coincida (PDF, JPEG o PNG) y que la extensión sea coherente. El nombre se sanea
y el archivo se guarda como `PORTAL_<YYYYMMDD_HHmmss>_<nombre>.<ext>`. Los
duplicados se detectan por MD5 contra `PORTAL_UPLOADS` y `LOG_PROCESO` (el
pipeline de FacturIA usa MD5). Un archivo que el pipeline cerró en `ERROR` no
cuenta como duplicado: el cliente puede volver a subirlo.

**Respuesta `data`:** `{ "uploadId": "uuid", "fileId": "1AbC..." }`

Errores: `VALIDATION_ERROR`, `UNSUPPORTED_MEDIA_TYPE`, `FILE_TOO_LARGE`,
`DUPLICATE`, `CLIENT_FOLDER_NOT_READY`, `RATE_LIMITED`. Ante `DUPLICATE` se
registra una fila en `PORTAL_UPLOADS` con `ESTADO=DUPLICADO`.

### 5.5 `getUploadStatus` (Fase 3 — implementado)

**Petición `data`:** `{ "uploadId": "uuid" }`

**Respuesta `data`:**

```json
{
  "uploadId": "uuid",
  "fileId": "1AbC...",
  "status": "PROCESANDO",
  "notes": "",
  "updatedAt": "2026-11-15T10:05:00+01:00"
}
```

Estados: `EN_COLA`, `PROCESANDO`, `REVISION`, `PROCESADO`, `ERROR`, `DUPLICADO`.
El estado se deriva en el servidor; la app puede hacer polling cada 3 segundos.
Las subidas de otro cliente responden `NOT_FOUND`.

### 5.6 `getDashboard` (Fase 4 — implementado, aproximado)

**Petición `data`:** `{}`

**Respuesta `data`:**

```json
{
  "period": {
    "quarterLabel": "T4 2026",
    "dateFrom": "2026-10-01",
    "dateTo": "2026-12-31",
    "daysToClose": 45,
    "filingDeadline": "2027-01-30",
    "daysToDeadline": 75
  },
  "confirmed": {
    "invoiceCount": 12,
    "nonEurCount": 0,
    "income": 3000.0,
    "expenses": 1200.0,
    "outputVat": 630.0,
    "deductibleVat": 252.0,
    "vatBalance": 378.0,
    "withheldIrpf": 450.0,
    "supplierIrpf": 0.0
  },
  "provisional": {
    "invoiceCount": 3,
    "nonEurCount": 0,
    "income": 0.0,
    "expenses": 300.0,
    "outputVat": 0.0,
    "deductibleVat": 63.0,
    "vatBalance": -63.0,
    "withheldIrpf": 0.0,
    "supplierIrpf": 0.0
  }
}
```

| Campo                               | Significado                                                                                                                                    |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `daysToClose`                       | Días hasta el último día del trimestre.                                                                                                        |
| `filingDeadline` / `daysToDeadline` | Plazo orientativo de presentación: día 20 del mes siguiente al trimestre, o 30 de enero para el cuarto. No ajusta festivos ni fines de semana. |
| `invoiceCount`                      | Facturas del bloque. Las pendientes de revisión son `provisional.invoiceCount`.                                                                |
| `nonEurCount`                       | Facturas del bloque en otra divisa. Se cuentan, pero no se suman a los importes.                                                               |
| `income` / `expenses`               | Suma de bases imponibles (sin IVA) de `EMITIDA` y de `RECIBIDA`/`TICKET`.                                                                      |
| `outputVat` / `deductibleVat`       | IVA repercutido (`EMITIDA`) y soportado (`RECIBIDA`/`TICKET`).                                                                                 |
| `vatBalance`                        | `outputVat − deductibleVat`. Positivo: IVA a ingresar; negativo: a compensar.                                                                  |
| `withheldIrpf`                      | IRPF que los clientes han retenido en las facturas emitidas.                                                                                   |
| `supplierIrpf`                      | IRPF retenido a proveedores en las facturas recibidas.                                                                                         |

`confirmed` solo incluye `REVISADO` (comparable con el libro registro);
`provisional` es el resto, excluido `NO_FACTURA`. La definición fiscal definitiva
está pendiente de validación.

Cálculo aproximado aplicado hasta que Daniel lo confirme: se filtran las facturas
autorizadas del trimestre actual, se excluye `NO_FACTURA`, y se separan en
`confirmed` (`REVISADO`) y `provisional` (resto). Los importes salen de
`BASE_IMPONIBLE`, `CUOTA_IVA` e `IMPORTE_RETENCION_IRPF`; si una factura no trae
base (habitual en tickets) se calcula como total − IVA + IRPF. Todo el IVA
soportado se trata como deducible: no se aplican prorrata, gastos no deducibles
ni regímenes especiales. No se devuelve una “deducción estimada” única: usa
`deductibleVat` o `vatBalance` hasta cerrar la fórmula.

---

## 6. Modelos Dart (Fase 1 — estables)

Copia estos modelos en el proyecto Flutter. Los importes del plan usan `double`;
las fechas se transportan como `String` ISO 8601 y se convierten con
`DateTime.parse` si la UI lo necesita.

```dart
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

enum UserRole { cliente, gestor, unknown }

enum ClientStatus { activo, semiactivo, inactivo, unknown }

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
```

---

## 7. Modelos Dart de facturas (Fase 2) y previstos (Fases 3–4)

Los modelos de consulta y de subida de facturas son estables. La forma del
dashboard (Fase 4) ya está implementada en la API (§5.6), pero sus modelos en
Flutter siguen pendientes de la Fase 6.

```dart
enum InvoiceType { emitida, recibida, ticket, unknown }

enum InvoiceStatus { revisado, revisionNeeded, noFactura, ok, unknown }

class Counterparty {
  const Counterparty({required this.name, required this.nif});

  final String name;
  final String nif;

  factory Counterparty.fromJson(Map<String, dynamic> json) {
    return Counterparty(
      name: json['name'] as String? ?? '',
      nif: json['nif'] as String? ?? '',
    );
  }
}

class InvoiceSummary {
  const InvoiceSummary({
    required this.id,
    required this.type,
    required this.issueDate,
    required this.number,
    required this.counterparty,
    required this.base,
    required this.vat,
    required this.irpf,
    required this.total,
    required this.currency,
    required this.status,
    required this.hasPdf,
  });

  final String id;
  final InvoiceType type;
  final String issueDate;
  final String number;
  final Counterparty counterparty;
  final double base;
  final double vat;
  final double irpf;
  final double total;
  final String currency;
  final InvoiceStatus status;
  final bool hasPdf;

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      id: json['id'] as String? ?? '',
      type: enumFromApi(InvoiceType.values, json['type'], InvoiceType.unknown),
      issueDate: json['issueDate'] as String? ?? '',
      number: json['number'] as String? ?? '',
      counterparty: Counterparty.fromJson(
        json['counterparty'] as Map<String, dynamic>? ?? const {},
      ),
      base: (json['base'] as num?)?.toDouble() ?? 0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0,
      irpf: (json['irpf'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EUR',
      status: enumFromApi(InvoiceStatus.values, json['status'], InvoiceStatus.unknown),
      hasPdf: json['hasPdf'] as bool? ?? false,
    );
  }
}

class InvoicePage {
  const InvoicePage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  final List<InvoiceSummary> items;
  final int page;
  final int pageSize;
  final int total;

  factory InvoicePage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return InvoicePage(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(InvoiceSummary.fromJson)
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

enum UploadState { enCola, procesando, revision, procesado, error, duplicado, unknown }

class UploadResult {
  const UploadResult({required this.uploadId, required this.fileId});

  final String uploadId;
  final String fileId;

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      uploadId: json['uploadId'] as String? ?? '',
      fileId: json['fileId'] as String? ?? '',
    );
  }
}

class UploadStatusResult {
  const UploadStatusResult({
    required this.uploadId,
    required this.fileId,
    required this.status,
    required this.notes,
    required this.updatedAt,
  });

  final String uploadId;
  final String fileId;
  final UploadState status;
  final String notes;
  final String updatedAt;

  factory UploadStatusResult.fromJson(Map<String, dynamic> json) {
    return UploadStatusResult(
      uploadId: json['uploadId'] as String? ?? '',
      fileId: json['fileId'] as String? ?? '',
      status: enumFromApi(UploadState.values, json['status'], UploadState.unknown),
      notes: json['notes'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
```

---

## 8. Notas de integración para Flutter

- Usa `getIdToken(true)` antes de llamadas que puedan requerir token fresco.
- Envía siempre `apiVersion: "1"` para detectar incompatibilidades.
- Trata `ok == false` como error aunque el HTTP sea 200.
- Si recibes `AUTH_INVALID` o `AUTH_EXPIRED`, renueva el token una vez y reintenta.
- Si recibes `RATE_LIMITED`, no reintentes en bucle; muestra espera.
- Guarda la sesión con `flutter_secure_storage`; nunca guardes el token en logs.
- Sigue la redirección 302 del Web App; valida el JSON, no el código HTTP.
- Para subidas, comprime imágenes y contempla el límite de 10 MB (Base64 ~13 MB).
- Tras `uploadInvoice`, consulta `getUploadStatus` cada 3 s y detén el polling en
  `PROCESADO`, `ERROR` o `DUPLICADO`.
- No envíes `uid`, `nif` ni `email` como identidad: el servidor solo confía en el
  token verificado.

---

## 9. Cambios de contrato

Cualquier cambio en campos, códigos de error o estados debe actualizar este
documento y coordinarse con la app Flutter. Los endpoints de fases posteriores se
cerrarán al implementar cada fase.

- **2026-11-26:** eliminado `aeatStatus` de `getProfile` y `registerClient`
  (y la columna `PORTAL_USERS.AEAT_ESTADO`). El estado relevante es
  `client.status`. En Flutter hay que quitar el campo `aeatStatus` de
  `PortalProfile` y el enum `AeatStatus`.

---

## 10. Herramientas de prueba (solo servidor)

Estas funciones no forman parte del contrato HTTP; se ejecutan desde el editor
de Apps Script del proyecto API.

- `portalCreateInvitation(options)`: crea una fila en `PORTAL_USERS` con
  `ESTADO=PENDIENTE`, hash SHA-256 del código, caducidad y datos del
  `CLIENTS_REGISTRY`. Devuelve `{ inviteCode, email, nif, expiresAt }`.
  Opciones: `email`, `nif` (obligatorios), `name`, `role`, `gestorEmail`,
  `ttlHours` y `allowDuplicate`.
- `portalCreateTestInvitation()`: variante sin argumentos para pruebas
  repetidas. Lee `PORTAL_TEST_EMAIL`, `PORTAL_TEST_NIF` y, opcionalmente,
  `PORTAL_TEST_NAME` y `PORTAL_TEST_GESTOR_EMAIL` de las propiedades del script.
  Imprime el código en **Ver → Logs**.

El código devuelto se envía en `registerClient` como `data.inviteCode` y solo se
puede consumir una vez.
