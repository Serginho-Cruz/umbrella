import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/credit_card_model.dart';

class CreditCardStore extends Store<List<CreditCardModel>> {
  CreditCardStore() : super([]);

  Future<void> getAll() async {
    setLoading(true);

    const colors = <String>['58F5FF', 'C786F9', '85FF5A', 'FF6F6F', 'F8F36B'];

    await Future.delayed(const Duration(seconds: 5), () {
      var creditCards = List.generate(
        5,
        (index) => CreditCardModel(
          name: 'Cartão Nº${index + 1}',
          color: colors[index],
          overdueDate: Date(day: 5, month: 2, year: 2024),
          castValue: 509.43 * (index + 1),
        ),
      );

      update(creditCards);
    });

    setLoading(false);
  }
}
