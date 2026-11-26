# Plan de la app Flutter — Portal Cliente (MVP)

**Fecha:** 26/11/2026 · **Entrega del curso:** 16/12/2026
**Alcance:** pantallas A01 a A05. El chat (A06) y las notificaciones push quedan fuera.
**Alta de usuarios:** solo por invitación. La gestoría crea el usuario en Firebase, el cliente pone la contraseña con el enlace del correo y activa la cuenta con el código de invitación.
**Contrato de la API:** `docs/API_CONTRACT.md` (manda sobre este plan si hay diferencias).

Cómo usar este documento: cada fase tiene tareas con casilla, lo que se aprende de Flutter y un criterio de "hecho". Sigue el orden: cada fase se apoya en la anterior. Las tareas marcadas con **(opcional)** se pueden recortar si falta tiempo.

---

## 1. Dónde estamos

| Parte | Estado |
|---|---|
| Sistema de diseño (`lib/styles/app_styles.dart`) | Hecho |
| Splash, login, activar cuenta / recuperar contraseña | Hecho (solo Firebase, sin llamar a la API) |
| Navegación inferior con 3 pestañas (`home_screen.dart`) | Hecho |
| App bar común y avatar con iniciales | Hecho |
| Cerrar sesión con confirmación | Hecho |
| Modelos Dart del contrato (`lib/models/`) | Hecho, con `aeatStatus` por quitar |
| Capa de red (`services/`), llamadas a la API | **Nada** |
| Gestión de estado | **Nada** (solo `setState`) |
| Inicio (A02), Documentos (A03), Detalle (A04), Perfil (A05) | **Esqueletos vacíos** |
| Código de invitación (`registerClient`) | **No existe pantalla** |
| Subida de facturas | **Nada** |
| Tests | **Nada** (no hay carpeta `test/`) |

---

## 2. Decisiones de arquitectura

- **Estado:** `provider` con `ChangeNotifier`. Un provider por área (sesión, facturas, dashboard, subida).
- **Red:** paquete `http`. Un `ApiClient` genérico y, encima, un `PortalApi` con un método por acción.
- **Capas:** pantalla → provider → `PortalApi` → `ApiClient`. Las pantallas nunca llaman a `http` ni a `FirebaseAuth` directamente.
- **Token:** `getIdToken()` normal en cada llamada (Firebase lo renueva solo al caducar) y `getIdToken(true)` solo al reintentar tras `AUTH_INVALID` / `AUTH_EXPIRED`. Forzar la renovación en todas las llamadas añade una petición extra cada vez.
- **Sesión:** Firebase ya guarda la sesión en el móvil. No hace falta `flutter_secure_storage` en el MVP: el token no se guarda en ningún sitio.
- **URL de la API:** fuera del repositorio, con `--dart-define-from-file` (archivo en `.gitignore`, igual que `firebase_options.dart`).

### Services y providers: qué hace cada uno

Son dos capas con trabajos distintos:

| | **Service** (`lib/services/`) | **Provider** (`lib/providers/`) |
|---|---|---|
| Pregunta que responde | *¿Cómo consigo los datos?* | *¿Qué está viendo ahora la pantalla?* |
| Qué hace | Habla con el exterior: la API, Firebase, el sistema de archivos | Guarda el estado de la interfaz: cargando, lista, filtro, error |
| Guarda estado | No. Recibe parámetros y devuelve un `Future` | Sí. Variables que cambian con el tiempo |
| Avisa a la UI | No sabe que la UI existe | Llama a `notifyListeners()` y los widgets se repintan |
| Importa Flutter | No (Dart puro): fácil de testear | Sí (`ChangeNotifier`) |
| Ejemplo | `PortalApi.getInvoices(tipo: 'RECIBIDAS', page: 2)` | `InvoicesProvider` con `items`, `isLoading`, `error`, `selectedFilter`, `loadNextPage()` |

Una analogía: el service es el repartidor que trae el pedido; el provider es la mesa donde se sirve, que sabe qué hay encima y avisa cuando cambia.

El flujo de una acción, por ejemplo cambiar el chip a "Recibidas":

```
Pantalla ──(1) context.read<InvoicesProvider>().setFilter(RECIBIDAS)
   ▲
   │                    InvoicesProvider
   │                    (2) isLoading = true; notifyListeners()
   │                    (3) await portalApi.getInvoices(...)  ──▶  PortalApi (service)
   │                                                                  └▶ ApiClient ──▶ Apps Script
   │                    (4) items = resultado; isLoading = false
   └──(5) notifyListeners() → la pantalla se repinta con context.watch
```

Esqueleto para ver la forma (no es la implementación):

```dart
// Service: sin estado, solo sabe pedir datos.
class PortalApi {
  PortalApi(this._client);
  final ApiClient _client;

  Future<InvoicePage> getInvoices({required String tipo, int page = 1}) { ... }
}

// Provider: guarda lo que la pantalla necesita y avisa al cambiar.
class InvoicesProvider extends ChangeNotifier {
  InvoicesProvider(this._api);
  final PortalApi _api;

  List<InvoiceSummary> items = [];
  bool isLoading = false;
  ApiException? error;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      items = (await _api.getInvoices(tipo: 'TODAS')).items;
      error = null;
    } on ApiException catch (e) {
      error = e;
    }
    isLoading = false;
    notifyListeners();
  }
}
```

Reglas para no mezclarlos:

- Una pantalla nunca llama a un service directamente: siempre pasa por su provider.
- Un service nunca llama a `notifyListeners()` ni recibe un `BuildContext`.
- Si una pantalla tiene un estado muy local (por ejemplo, la casilla de "mostrar contraseña"), basta con `setState`. No todo necesita provider.
- Los services se crean una vez en `main()` y se pasan a los providers por el constructor. Así en los tests se puede pasar un service falso.

### Estructura de carpetas objetivo

```
lib/
├── config/      api_config.dart
├── models/      (existentes) + dashboard_model.dart
├── services/    api_client.dart, api_exception.dart, portal_api.dart, auth_service.dart
├── providers/   session_provider.dart, invoices_provider.dart,
│                dashboard_provider.dart, upload_provider.dart
├── screens/     (existentes) + invite_code_screen.dart, account_blocked_screen.dart
├── widgets/     invoice_card.dart, status_badge.dart, state_views.dart (carga/error/vacío)
├── utils/       formatters.dart
└── styles/      app_styles.dart
```

### Paquetes a añadir

| Paquete | Para qué | Fase |
|---|---|---|
| `http` | Llamadas a la API | 1 |
| `provider` | Gestión de estado | 2 |
| `intl` + `flutter_localizations` | Importes en euros y fechas en español | 3 |
| `url_launcher` | Abrir el correo del gestor | 3 |
| `image_picker` | Cámara y galería (ya comprime con `imageQuality`) | 6 |
| `file_picker` | Elegir un PDF | 6 |
| `path_provider` + `open_filex` | Guardar y abrir el PDF descargado | 5 |

`firebase_ui_auth` está en `pubspec.yaml` pero no se usa en `lib/`: comprobar y quitar.

---

## 3. Cambios de diseño respecto al Figma

El Figma muestra datos que la API no da. Lo que cambia:

| Pantalla | En el Figma | En el MVP |
|---|---|---|
| A01 Login | Pie "Cumplimiento RGPD & Veri*factu" | Quitar la mención a Veri*factu |
| A02 Inicio | "Deducción estimada 71 % optimizado" | Tarjeta de IVA: repercutido, soportado y saldo (`outputVat`, `deductibleVat`, `vatBalance`). No hay fórmula de deducción hasta que Daniel la valide |
| A02 Inicio | Insignia "+12 %" en gastos | Quitar: no hay dato de comparación |
| A02 Inicio | "¿Tienes dudas? Consultar" (chat) | Enlace al correo del gestor (`managerEmail`) o quitar |
| A02 Inicio | Cifras únicas | Dos bloques: confirmado (`confirmed`) y pendiente de revisión (`provisional`) |
| A03 Documentos | Conmutador Gastos/Ingresos **y** chips | Solo chips: Todas, Emitidas, Recibidas, Tickets |
| A03 Documentos | Chip "Rectificativas" | Quitar: la API no tiene ese tipo |
| A03 Documentos | Categoría ("Software & SaaS") | Quitar: no viene en la API |
| A04 Detalle | Bloque Veri*factu, QR y huella | Quitar |
| A04 Detalle | Jurisdicción fiscal, concepto/categoría, tipo de IVA | Quitar. El tipo de IVA se puede calcular como `vat / base` **(opcional)** |
| A04 Detalle | Botón "Subir factura" | Quitar de aquí: la subida va en Inicio y en el botón + de Documentos |
| A05 Perfil | "Conexión AEAT activa · Sincronizado hoy" | Insignia con `client.status` (Activo / Semiactivo) |
| A05 Perfil | Epígrafe IAE, plan de asesoría | Quitar: no vienen en la API |
| A05 Perfil | Notificaciones, Facturación Veri*factu | Quitar. Queda "Cambiar contraseña" y una tarjeta "Tu gestor" |
| Todas | Campana de notificaciones | Ocultar: no hay backend |
| Navegación | 4 pestañas con Consultas | 3 pestañas (ya está así) |

---

## 4. Calendario hasta la entrega

Hay 20 días de calendario y el trabajo estimado es de 13 a 17 días, así que va justo: no hay margen para retrasarse más de un par de días sin recortar (ver §6). Fines de semana y festivos (6 y 8 de diciembre) cuentan como días de trabajo; si alguno no lo es, adelanta el recorte.

| Fechas | Fase | Hito para seguir en plazo |
|---|---|---|
| Jue 26 – Vie 27 nov | 0 y 1 (inicio) | Proyecto limpio, `ApiClient` escrito |
| Sáb 28 – Dom 29 nov | 1 | **`ping` funciona desde el móvil** (si no, todo lo demás se bloquea) |
| Lun 30 nov – Mié 2 dic | 2 | Login → invitación → Home con perfil real |
| Jue 3 dic | 3 | Perfil A05 con datos reales |
| Vie 4 – Dom 6 dic | 4 | Listado A03 con filtros y paginación |
| Lun 7 – Mar 8 dic | 5 | Detalle A04 y ver PDF |
| Mié 9 – Vie 11 dic | 6 | **Subida con foto hasta ver el estado final** |
| Sáb 12 – Dom 13 dic | 7 | Dashboard A02 |
| Lun 14 – Mar 15 dic | 8 | Pruebas en dispositivo, APK, README, capturas |
| **Mié 16 dic** | Entrega | — |

Puntos de control: si el **2 de diciembre** la Fase 2 no está cerrada, recorta ya los dos primeros niveles de §6. Si el **11 de diciembre** la subida no funciona, entrega sin "Última actividad" en Inicio y sin PDF en la subida.

---

## 5. Fases

Las estimaciones son orientativas.

### Fase 0 — Puesta al día (0,5 día)

Dejar el proyecto coherente con el contrato actual antes de construir encima.

- [x] Quitar `AeatStatus` y el campo `aeatStatus` de `lib/models/user_model.dart` (cambio de contrato del 26/11).
- [ ] Actualizar `agent.md`: quitar `AeatStatus`, corregir la lista de endpoints (todos son `POST` con el token en el cuerpo, no `GET ?userUid=`), y la estructura de carpetas.
- [x] La fuente Sarabun está en `AppStyles.fontFamily` pero no está declarada en `pubspec.yaml`, así que hoy se ve la fuente por defecto. Añadir los `.ttf` a `assets/fonts/` y la sección `fonts:`.
- [x] `lib/main.dart`: el prefijo de `debugPrint` es `[Receptari]` (de otro proyecto). Cambiarlo.
- [ ] Quitar "Veri*factu" del pie de `lib/widgets/auth_layout.dart`.
- [ ] Renombrar a inglés las variables en castellano de `login_screen.dart`, `activate_account_screen.dart` y `user_avatar.dart` (`_ocultarPassword`, `_mostrarMensaje`, `recuperarPassword`…), como pide `agent.md`.
- [ ] Hacer commit de `docs/API_CONTRACT.md` y `auth_layout.dart`, que están modificados sin confirmar.

**Aprendizaje Flutter:** declarar fuentes y assets en `pubspec.yaml`; `flutter analyze`.
**Hecho cuando:** `flutter analyze` sin avisos y la app arranca con Sarabun.

### Fase 1 — Capa de red y `ping` (1,5 a 2 días)

Es la fase con más riesgo técnico: hazla antes que cualquier pantalla.

- [ ] Añadir `http`. Crear `config/api_config.dart` que lea la URL con `String.fromEnvironment`. Crear el archivo de entorno, añadirlo a `.gitignore` y configurar el lanzamiento en `.vscode/launch.json`.
- [ ] `services/api_exception.dart`: una excepción propia con `ApiErrorCode`, mensaje y `requestId`. Añadir casos para "sin conexión" y "tiempo agotado", que no vienen de la API.
- [ ] `services/api_client.dart`: un método `post(action, data, {auth})` que monta el envoltorio (`action`, `apiVersion: "1"`, `idToken`, `data`), envía, decodifica y devuelve `ApiResponse<T>` o lanza `ApiException`.
- [ ] **Redirección 302.** Apps Script responde al `POST` con un 302 hacia `googleusercontent.com`, y el cliente HTTP de Dart no sigue redirecciones en `POST`. Hay que leer la cabecera `location` y hacer un `GET` a esa URL. Pruébalo con `ping` en un dispositivo real.
- [ ] Timeout (30 s; las subidas necesitarán más) y captura de `SocketException` / `TimeoutException`.
- [ ] Reintento único: ante `AUTH_INVALID` / `AUTH_EXPIRED`, pedir `getIdToken(true)` y repetir una vez. Ante `RATE_LIMITED`, no reintentar.
- [ ] `services/portal_api.dart`: empezar con `ping()` y `getProfile()`.
- [ ] Android: añadir el permiso `INTERNET` en `android/app/src/main/AndroidManifest.xml` (en debug funciona sin él; en release no).
- [ ] Tests unitarios: `fromJson` de los modelos y `ApiClient` con `MockClient` de `package:http/testing.dart` (respuesta correcta, `ok: false`, 302, sin red).

**Aprendizaje Flutter:** `Future` / `async` / `await`; `jsonEncode` / `jsonDecode`; genéricos (`ApiResponse<T>` con función `fromData`); excepciones propias y `try` / `on` / `catch`; inyección de dependencias por constructor para poder testear; `--dart-define`; primeros tests con `flutter test`.
**Hecho cuando:** `ping` devuelve `pong: true` desde el móvil y los tests pasan.

### Fase 2 — Sesión y control de acceso (2 días)

Hoy el login lleva directo a `HomeScreen` sin preguntar a la API si la cuenta está activa.

- [ ] Añadir `provider`. Mover `Firebase.initializeApp` de `splash_screen.dart` a `main()` y envolver la app en `MultiProvider`.
- [ ] `services/auth_service.dart`: envolver `FirebaseAuth` (login, logout, enlace de contraseña, token). Las pantallas dejan de importar `firebase_auth`.
- [ ] `providers/session_provider.dart` con un estado claro: `loading`, `signedOut`, `pendingInvite`, `active` (con `PortalProfile`), `blocked`, `error`.
- [ ] Lógica al arrancar y tras el login: si hay usuario verificado → `getProfile` →
  - correcto → Home;
  - `ACCOUNT_PENDING` → pantalla de código de invitación;
  - `ACCOUNT_DISABLED` / `FORBIDDEN` → pantalla de cuenta bloqueada con botón de cerrar sesión;
  - sin red → pantalla de error con "Reintentar".
- [ ] Sustituir los `Navigator.pushReplacement` de splash, login y logout por un widget raíz que elija pantalla según el estado de la sesión.
- [ ] `screens/invite_code_screen.dart`: campo del código, llamada a `registerClient`, mensajes para `FORBIDDEN` (código inválido, caducado o usado) y `RATE_LIMITED`. Reutiliza `AuthLayout`, `AuthField` y `AuthSubmitButton`.
- [ ] Correo sin verificar: hoy el login cierra la sesión y muestra un aviso. Añadir "Reenviar correo de verificación" **(opcional)**.
- [ ] `splash_screen.dart`: quitar la espera fija de 2 s y el `setState` posterior a la navegación.
- [ ] `PortalAppBar` y `ClientProfileScreen` leen el usuario del provider, no de `FirebaseAuth.instance`. Al tocar el avatar se va a la pestaña Perfil.
- [ ] Probar el flujo completo con `portalCreateTestInvitation()` (ver §10 del contrato).

**Aprendizaje Flutter:** `ChangeNotifier`, `notifyListeners`, `context.watch` / `context.read` / `Consumer`; por qué subir el estado por encima de las pantallas; navegación declarativa según estado frente a `Navigator.push` imperativo; `enum` con `switch` exhaustivo; ciclo de vida y `mounted`.
**Hecho cuando:** una cuenta nueva pasa por invitación y entra; una bloqueada no ve datos; al reabrir la app se entra sin volver a hacer login.

### Fase 3 — Perfil, A05 (1 día)

La pantalla con datos más sencilla: el perfil ya está cargado en la sesión.

- [ ] Añadir `intl` y `flutter_localizations`; configurar `locale` español en `MaterialApp`. Crear `utils/formatters.dart` (importes `1.452,00 €`, fechas `24 mar 2026`).
- [ ] Tarjeta de empresa: avatar con iniciales, `client.name`, `client.nif`, `client.address`.
- [ ] `widgets/status_badge.dart`: insignia reutilizable (texto + color). Usarla para `client.status`.
- [ ] Tarjeta "Tu gestor" con `managerEmail` y botón que abre el correo (`url_launcher`).
- [ ] Fila "Cambiar contraseña": envía el enlace con el método que ya existe y muestra confirmación.
- [ ] Datos de cuenta: correo, miembro desde, último acceso.
- [ ] Mantener el botón de cerrar sesión; convertir la pantalla en desplazable.
- [ ] Versión de la app en el pie **(opcional)**.

**Aprendizaje Flutter:** composición de widgets y extracción de componentes; `ListTile`, `Card`, `SingleChildScrollView`; formateo con `intl`; localización; abrir apps externas.
**Hecho cuando:** A05 muestra datos reales del cliente de prueba y no desborda en pantallas pequeñas.

### Fase 4 — Listado de documentos, A03 (2 a 3 días)

- [ ] `PortalApi.getInvoices(...)` con `tipo`, `search`, `page`, `pageSize`, y fechas.
- [ ] `providers/invoices_provider.dart`: lista, filtro actual, texto de búsqueda, página, `total`, y estados de carga inicial, carga de más, error y vacío.
- [ ] `widgets/invoice_card.dart`: nombre y NIF de la contraparte, fecha, importe total e insignia de estado. Se reutiliza en Inicio.
- [ ] Textos de estado para el cliente: `revisado` → "Revisada"; `ok` → "Procesada, pendiente de revisión"; `revisionNeeded` → "En revisión"; `noFactura` → "No es factura". Confirmar los textos con la gestoría.
- [ ] Chips de filtro (Todas, Emitidas, Recibidas, Tickets). Al cambiar, se reinicia la paginación.
- [ ] Buscador con espera de 400 ms antes de llamar (`Timer`), para no gastar el límite de 120 peticiones por minuto.
- [ ] Scroll infinito: `ListView.builder` + `ScrollController`; pedir la página siguiente cerca del final mientras `items.length < total`.
- [ ] `RefreshIndicator` para recargar tirando hacia abajo.
- [ ] `widgets/state_views.dart`: vistas de carga, error con "Reintentar" y lista vacía. Se usan en todas las pantallas.
- [ ] Contador "18 documentos" con `total`.
- [ ] Filtro por fechas con `showDateRangePicker` **(opcional)**.
- [ ] Botón flotante + (se conecta en la Fase 6).
- [ ] Al tocar una tarjeta, navegar al detalle pasando el `id`.
- [ ] Test de widget de `InvoiceCard`.

**Aprendizaje Flutter:** `ListView.builder` y por qué es perezoso; `ScrollController` y `dispose`; paginación; `RefreshIndicator`; debounce con `Timer`; `ChoiceChip`; estados de carga, error y vacío; `IndexedStack` y por qué las pestañas conservan su estado; tests de widget.
**Hecho cuando:** se ven las facturas reales, filtrar y buscar funciona, y con más de 20 facturas carga la segunda página.

### Fase 5 — Detalle de factura, A04 (1,5 a 2 días)

- [ ] Modelo `InvoiceDetail` (los campos de `InvoiceSummary` más `reviewedBy` y `reviewedAt`) y `PortalApi.getInvoice(id)`.
- [ ] `InvoiceDetailScreen` recibe el `id` y, si viene del listado, el resumen para pintar al instante mientras carga el detalle.
- [ ] Cabecera: tipo, número, importe total destacado.
- [ ] Bloque de revisión: estado, revisado por y fecha.
- [ ] Bloque de contraparte: "Proveedor" si es recibida o ticket, "Cliente" si es emitida.
- [ ] Desglose: fecha, base imponible, cuota de IVA, retención de IRPF y total. Mostrar la divisa si no es EUR.
- [ ] `NOT_FOUND`: mensaje "Factura no disponible" y volver.
- [ ] Ver el documento (si `hasPdf`): `getInvoiceFile` → `base64Decode` → guardar en la carpeta temporal → abrir con `open_filex`. Las imágenes se pueden mostrar con `Image.memory`. Indicador de carga: esta llamada es lenta.
- [ ] Botón compartir **(opcional)**.

**Aprendizaje Flutter:** paso de argumentos entre pantallas; `FutureBuilder` frente a provider para estado local de una pantalla; `Uint8List` y Base64; sistema de archivos con `path_provider`; app bar con botón atrás.
**Hecho cuando:** desde el listado se abre el detalle con datos reales y se puede ver el PDF.

### Fase 6 — Subida de facturas (2 a 3 días)

- [ ] Añadir `image_picker` y `file_picker`. Permisos: `NSCameraUsageDescription` y `NSPhotoLibraryUsageDescription` en `ios/Runner/Info.plist`.
- [ ] Hoja inferior con tres opciones: hacer foto, elegir de la galería, elegir PDF.
- [ ] Comprimir las fotos al capturarlas (`imageQuality` ~75 y `maxWidth` ~2000).
- [ ] Validar antes de enviar: tipo (PDF, JPEG, PNG) y tamaño máximo de 10 MB.
- [ ] Codificar a Base64 fuera del hilo principal con `compute`, para que la interfaz no se congele.
- [ ] `PortalApi.uploadInvoice(...)` con timeout más largo (90 s) e indicador de progreso.
- [ ] Errores con mensaje propio: `DUPLICATE`, `FILE_TOO_LARGE`, `UNSUPPORTED_MEDIA_TYPE`, `CLIENT_FOLDER_NOT_READY`.
- [ ] `providers/upload_provider.dart`: tras subir, consultar `getUploadStatus` cada 3 s. Parar en `PROCESADO`, `ERROR`, `DUPLICADO` y también en `REVISION` (para el cliente es final hasta que la gestoría revise).
- [ ] Límite de espera: el pipeline puede tardar hasta 5 minutos. Tras unos 2 minutos, dejar de consultar y mostrar "Seguimos procesándola; la verás en Documentos". No bloquear la app mientras tanto.
- [ ] Cancelar el temporizador en `dispose`.
- [ ] Al terminar, recargar el listado y el dashboard.
- [ ] Conectar el botón + de Documentos.

**Aprendizaje Flutter:** plugins nativos y permisos por plataforma; `showModalBottomSheet`; `dart:io` `File` y bytes; isolates con `compute`; `Timer.periodic` y su cancelación; comunicación entre providers; probar en dispositivo real (la cámara no va en el simulador de iOS).
**Hecho cuando:** una foto hecha con el móvil aparece en la hoja `FACTURAS` y la app muestra su estado final.

### Fase 7 — Inicio / dashboard, A02 (1,5 a 2 días)

Va al final porque reutiliza la tarjeta de factura y la subida.

- [ ] `models/dashboard_model.dart`: `DashboardPeriod`, `DashboardTotals` y `Dashboard`, según §5.6 del contrato (no vienen hechos).
- [ ] `PortalApi.getDashboard()` y `providers/dashboard_provider.dart`.
- [ ] Saludo con `client.name` y chip con `period.quarterLabel`.
- [ ] Tarjeta de IVA: repercutido, soportado y saldo, con texto "a ingresar" o "a compensar" según el signo. Aviso "Cálculo orientativo".
- [ ] Tarjeta de cierre: `daysToClose`, `filingDeadline` y `daysToDeadline`.
- [ ] Dos tarjetas pequeñas: facturas del trimestre (confirmadas y pendientes) y gastos.
- [ ] Distinguir visualmente `confirmed` de `provisional` ("pendiente de revisión").
- [ ] Si `nonEurCount > 0`, avisar de que hay facturas en otra divisa sin sumar.
- [ ] Tarjeta "Subida de documentos" con los botones de la Fase 6.
- [ ] "Última actividad": las 5 facturas más recientes (`getInvoices` con `pageSize: 5`) con `InvoiceCard`. "Ver todas" cambia a la pestaña Documentos.
- [ ] `RefreshIndicator` y estados de carga y error.
- [ ] Renombrar `main_screen.dart` a `dashboard_screen.dart` y la etiqueta "Home" a "Inicio" **(opcional)**.

**Aprendizaje Flutter:** `Row` / `Expanded` / `Flexible` y diseño en rejilla; `LinearProgressIndicator`; `Future.wait` para llamadas en paralelo; cambiar de pestaña desde una pantalla hija (callback o provider de navegación).
**Hecho cuando:** las cifras de `confirmed` coinciden con el libro registro del cliente de prueba.

### Fase 8 — Pulido, pruebas y entrega (1,5 a 2 días)

- [ ] Repasar cada pantalla en los cuatro estados: cargando, con datos, vacía y con error.
- [ ] Probar sin conexión (modo avión) en cada pantalla.
- [ ] Probar en pantalla pequeña y con el tamaño de letra del sistema ampliado.
- [ ] Probar en Android e iOS reales: login, invitación, listado, detalle, PDF, subida con cámara.
- [ ] Revisar que no se imprimen tokens ni Base64 en los logs.
- [ ] Icono y nombre de la app **(opcional)**.
- [ ] `README.md`: qué es, cómo configurar Firebase (`flutterfire configure`), cómo pasar la URL de la API y cómo ejecutar.
- [ ] `flutter analyze` y `flutter test` limpios.
- [ ] Generar el APK de release y probarlo instalado (aquí salen los fallos de permisos).
- [ ] Capturas de pantalla para la entrega del curso.

**Aprendizaje Flutter:** modos debug y release; `flutter build apk`; accesibilidad básica (`Semantics`, `textScaler`); documentación de un proyecto.

---

## 6. Si falta tiempo: qué recortar

Orden de recorte, de lo primero que cae a lo último:

1. Todo lo marcado como **(opcional)**.
2. Filtro por fechas y compartir.
3. "Última actividad" en Inicio (dejar solo las tarjetas de cifras).
4. Subida de PDF (dejar solo cámara y galería).
5. Ver el PDF en el detalle (dejar solo los datos).

No recortables para que el MVP tenga sentido: Fases 0, 1, 2, el listado, el detalle con datos y la subida con foto.

---

## 7. Riesgos

| Riesgo | Qué hacer |
|---|---|
| El 302 de Apps Script rompe los `POST` | Resolverlo en la Fase 1 con `ping`, antes de cualquier pantalla |
| Cada llamada a Apps Script tarda 1 a 3 s | Guardar perfil y dashboard en los providers; pintar lo que ya se tiene mientras se recarga |
| El pipeline tarda hasta 5 min en procesar | Límite de espera en el polling y mensaje claro (Fase 6); pedir que el trigger se baje a 1 min para la demo |
| Subidas grandes agotan el tiempo | Comprimir fotos, validar tamaño antes de enviar, timeout largo |
| 120 peticiones por minuto | Debounce en la búsqueda, polling cada 3 s, sin reintentos en bucle |
| La fórmula fiscal no está cerrada | El dashboard muestra IVA y saldo con aviso "orientativo"; sin "deducción estimada" |
| Plazo justo (20 días para 13 a 17 de trabajo) | Puntos de control del 2 y el 11 de diciembre (§4) y orden de recorte (§6) |
| El usuario de prueba no existe en Firebase o la invitación caduca | Preparar el cliente de prueba (usuario Firebase + `portalCreateTestInvitation()`) en la Fase 2 y tener uno de reserva para la demo |

---

## 8. Pendiente de decidir

- Textos de los estados de factura que ve el cliente (confirmar con la gestoría).
- Las tres preguntas fiscales para Daniel (§12 del plan de la API).
