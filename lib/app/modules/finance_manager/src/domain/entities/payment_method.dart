import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final int id;
  final String name;
  final String icon;

  const PaymentMethod._({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory PaymentMethod.money() => const PaymentMethod._(
      id: 1, name: 'Dinheiro', icon: 'icons/methods/money.png');

  factory PaymentMethod.debit() => const PaymentMethod._(
      id: 2, name: 'Débito', icon: 'icons/methods/debit.png');

  factory PaymentMethod.pix() =>
      const PaymentMethod._(id: 3, name: 'Pix', icon: 'icons/methods/pix.png');

  factory PaymentMethod.credit() => const PaymentMethod._(
      id: 4, name: 'Crédito', icon: 'icons/methods/credit.png');

  factory PaymentMethod.boleto() => const PaymentMethod._(
      id: 5, name: 'Boleto', icon: 'icons/methods/boleto.png');

  factory PaymentMethod.creditInInstallments() => const PaymentMethod._(
      id: 6, name: 'Crédito Parcelado', icon: 'icons/methods/credit.png');

  static List<PaymentMethod> get normals => [
        PaymentMethod.money(),
        PaymentMethod.debit(),
        PaymentMethod.pix(),
        PaymentMethod.credit(),
        PaymentMethod.boleto()
      ];

  @override
  List<Object?> get props => [id, name, icon];
}
