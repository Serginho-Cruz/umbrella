import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_record.dart';
import '../../domain/models/paiyable_model.dart';
import '../../errors/errors.dart';

abstract interface class PaiyableStore<P extends PaiyableModel<T>,
    T extends Paiyable> {
  List<PaymentRecord<T>> get paymentsToDo;

  double get totalPaying;

  void addPayment({required PaymentMethod method, required Account account});
  void removePayment(PaymentMethod method);
  void setPaymentAccount({
    required PaymentMethod method,
    required Account account,
  });
  void setPaymentCreditCard(CreditCard? card);
  void setPaymentValue({
    required PaymentMethod method,
    required double value,
  });

  List<PaymentMethod> get allowedMethods;
  List<PaymentMethod> get remainingMethods;
  void restartPayments();

  Future<Fail?> switchAccount();
  Future<Fail?> updateValue();
  Future<Fail?> pay();

  void setValue(double value);
  void setAccount(Account? acc);

  Account? get account;

  String? validateValue(double value);
  String? validateAccount(Account? acc);
}
