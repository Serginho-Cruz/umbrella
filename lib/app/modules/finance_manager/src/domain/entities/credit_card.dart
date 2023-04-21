class CreditCard {
  int? id;
  String name;
  double annuity;
  String color;
  DateTime cardInvoiceClosingDate;
  DateTime cardInvoiceExpirationDate;

  CreditCard({
    this.id,
    required this.name,
    required this.annuity,
    required this.color,
    required this.cardInvoiceClosingDate,
    required this.cardInvoiceExpirationDate,
  });
}
