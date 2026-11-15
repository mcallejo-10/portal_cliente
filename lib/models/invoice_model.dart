class InvoiceModel {
  final String id;
  final String userId;
  final double amount;
  final DateTime date;

  InvoiceModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
  });
}
