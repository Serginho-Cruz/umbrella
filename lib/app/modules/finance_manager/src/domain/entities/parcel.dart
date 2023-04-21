abstract class Parcel {
  int id;
  double paidValue;
  double remainingValue;
  DateTime paymentDate;
  double parcelValue;

  Parcel({
    required this.id,
    required this.paidValue,
    required this.remainingValue,
    required this.paymentDate,
    required this.parcelValue,
  });
}
