import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/credit_card_datasource.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

import '../../domain/entities/account.dart';
import '../../errors/errors.dart';

class TemporaryCreditCardDatasource implements CreditCardDatasource {
  final List<CreditCard> _cards = [
    const CreditCard(
      id: 1,
      name: 'Marisa',
      annuity: 0.00,
      color: '45ACFF',
      cardInvoiceClosingDay: 9,
      cardInvoiceDueDay: 18,
      accountToDiscountInvoice:
          Account(id: 50, actualBalance: 200.00, name: 'Banco do Brasil'),
    ),
    const CreditCard(
      id: 2,
      name: 'Banco do Brasil',
      annuity: 0.00,
      color: '12601A',
      cardInvoiceClosingDay: 27,
      cardInvoiceDueDay: 7,
      accountToDiscountInvoice:
          Account(id: 50, actualBalance: 200.00, name: 'Banco do Brasil'),
    ),
    const CreditCard(
      id: 3,
      name: 'Daju',
      annuity: 10.00,
      color: '45ACFF',
      cardInvoiceClosingDay: 2,
      cardInvoiceDueDay: 12,
      accountToDiscountInvoice:
          Account(id: 49, actualBalance: 200.00, name: 'Conta Padrão'),
    ),
  ];
  @override
  Future<int> create(CreditCard card, User user) {
    int newId = _cards.last.id;

    _cards.add(card.copyWith(id: newId));

    return Future.value(newId);
  }

  @override
  Future<void> update(CreditCard newCard) async {
    int? index;

    for (var element in _cards.indexed) {
      if (element.$2.id == newCard.id) {
        index = element.$1;
        break;
      }
    }

    if (index == null) throw GenericError();

    _cards.removeAt(index);
    _cards.insert(index, newCard);
  }

  @override
  Future<List<CreditCard>> getAll(User user) {
    return Future.delayed(const Duration(seconds: 2), () => _cards);
  }

  @override
  Future<void> delete(CreditCard card) async {
    int? index;

    for (var element in _cards.indexed) {
      if (element.$2.id == card.id) {
        index = element.$1;
        break;
      }
    }

    if (index == null) throw GenericError();

    _cards.removeAt(index);
  }
}
