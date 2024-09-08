import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String icon;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
  });

  const PaymentMethod.money()
      : id = 'knSCMXiWbL',
        name = 'Dinheiro',
        icon = 'money.png';

  const PaymentMethod.debit()
      : id = 'IDKNGPwFB6',
        name = 'Débito',
        icon = 'debit.png';

  const PaymentMethod.pix()
      : id = 'O3RFqTJRXw',
        name = 'Pix',
        icon = 'pix.png';

  const PaymentMethod.credit()
      : id = 'ZZzrJEQ9Np',
        name = 'Crédito',
        icon = 'credit.png';

  const PaymentMethod.boleto()
      : id = 'KNqRrtSPbG',
        name = 'Boleto',
        icon = 'boleto.png';

  static List<PaymentMethod> get all => const [
        PaymentMethod.money(),
        PaymentMethod.debit(),
        PaymentMethod.pix(),
        PaymentMethod.credit(),
        PaymentMethod.boleto()
      ];

  bool get isCredit {
    return this == const PaymentMethod.credit();
  }

  @override
  List<Object?> get props => [id, name, icon];
}
