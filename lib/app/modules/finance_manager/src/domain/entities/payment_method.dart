import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final int id;
  final String name;
  final String icon;

  const PaymentMethod.money()
      : id = 1,
        name = 'Dinheiro',
        icon = 'icons/methods/money.png';

  const PaymentMethod.debit()
      : id = 2,
        name = 'Débito',
        icon = 'icons/methods/debit.png';

  const PaymentMethod.pix()
      : id = 3,
        name = 'Pix',
        icon = 'icons/methods/pix.png';

  const PaymentMethod.credit()
      : id = 4,
        name = 'Crédito',
        icon = 'icons/methods/credit.png';

  const PaymentMethod.boleto()
      : id = 5,
        name = 'Boleto',
        icon = 'icons/methods/boleto.png';

  const PaymentMethod.creditInInstallments()
      : id = 6,
        name = 'Crédito Parcelado',
        icon = 'icons/methods/credit.png';

  static List<PaymentMethod> get normals => const [
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
