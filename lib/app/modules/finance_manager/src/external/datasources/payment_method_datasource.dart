import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/payment_method_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/invoice.dart';
import '../../errors/errors.dart';

enum PaiyableType { income, expense, invoice }

class TemporaryPaymentMethodDatasource implements PaymentMethodDatasource {
  final Map<({int id, PaiyableType type}), Map<PaymentMethod, double>> _data =
      {};

  @override
  Future<void> deletePaymentRecord(Paiyable paiyable) {
    var type = _determineTypeOf(paiyable);

    _data.remove((id: paiyable.id, type: type));

    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<double> getValuePaidWithMethod(
    Paiyable paiyable,
    PaymentMethod method,
  ) {
    var type = _determineTypeOf(paiyable);

    var register = _data[(id: paiyable.id, type: type)]?[method];

    return Future.delayed(const Duration(seconds: 1), () {
      return register ?? 0.00;
    });
  }

  @override
  Future<void> registerPayment({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  }) {
    var type = _determineTypeOf(paiyable);

    var paymentRegister = _data[(id: paiyable.id, type: type)];

    if (paymentRegister == null) {
      _data.putIfAbsent((id: paiyable.id, type: type), () => {});
    }

    _data[(id: paiyable.id, type: type)]!.update(
        method, (v) => (v + value).roundToDecimal(),
        ifAbsent: () => value);

    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> removeValueFromPaymentRecord({
    required Paiyable paiyable,
    required PaymentMethod method,
    required double value,
  }) {
    var type = _determineTypeOf(paiyable);

    if (_data[(id: paiyable.id, type: type)]?[method] == null) {
      var name = switch (type) {
        PaiyableType.income => 'receita',
        PaiyableType.expense => 'despesa',
        PaiyableType.invoice => 'fatura',
      };
      throw Fail("Não há registros de pagamento para essa $name");
    }

    _data[(id: paiyable.id, type: type)]!.update(
        method, (v) => v >= value ? (v - value).roundToDecimal() : 0.00);

    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> updatePaymentRecord({
    required Paiyable paiyable,
    required double newValue,
    required PaymentMethod method,
  }) {
    var type = _determineTypeOf(paiyable);
    final String name = switch (type) {
      PaiyableType.income => 'receita',
      PaiyableType.expense => 'despesa',
      PaiyableType.invoice => 'fatura',
    };

    if (_data[(id: paiyable.id, type: type)] == null) {
      throw Fail("Não há registros de pagamento para essa $name");
    }

    if (_data[(id: paiyable.id, type: type)]![method] == null) {
      throw Fail(
          "Não há registros de pagamento com o método de pagamento ${method.name} para essa $name");
    }

    _data[(id: paiyable.id, type: type)]!.update(method, (value) => newValue);

    return Future.delayed(const Duration(seconds: 1));
  }

  PaiyableType _determineTypeOf(Paiyable paiyable) {
    return switch (Paiyable) {
      Invoice() => PaiyableType.invoice,
      Expense() => PaiyableType.expense,
      Income() => PaiyableType.invoice,
      _ => throw Fail('Não Implementado'),
    };
  }
}
