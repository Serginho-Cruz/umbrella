import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final int id;
  final String name;
  final String icon;
  final bool isCredit;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.isCredit,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, isCredit, icon];
}
