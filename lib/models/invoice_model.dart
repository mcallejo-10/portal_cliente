import 'api_response.dart';

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
