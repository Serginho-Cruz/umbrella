import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PaymentMethod with EquatableMixin {
  int id;
  String name;
  bool isCredit;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.isCredit,
  });

  @override
  List<Object?> get props => [id, name, isCredit];
}
