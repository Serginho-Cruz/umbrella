import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/paiyable_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/paiyable.dart';

abstract class PaiyableStore<E extends Paiyable, T extends PaiyableModel<E>>
    extends Store<List<T>> {
  PaiyableStore(super.initialState);

  AsyncResult<int, Fail> register(E entity);
  AsyncResult<void, Fail> updateValue(T paiyable, double newValue);

  AsyncResult<void, Fail> switchAccount(
    T paiyable,
    Account newAccount,
  );

  AsyncResult<void, Fail> edit({
    required E oldPaiyable,
    required E newPaiyable,
  });

  Future<void> getForAll({
    required List<Account> accounts,
    required int month,
    required int year,
  });

  Future<void> getAllOf({
    required int month,
    required int year,
    required Account account,
  });

  AsyncResult<void, Fail> pay({
    required List<Payment<E>> payments,
    CreditCard? card,
  });
}
