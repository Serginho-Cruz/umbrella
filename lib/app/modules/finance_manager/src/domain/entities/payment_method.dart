import 'package:equatable/equatable.dart';

class PaymentMethod with EquatableMixin {
  int id;
  String name;
  String icon;
  bool isCredit;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.isCredit,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, isCredit, icon];
}
