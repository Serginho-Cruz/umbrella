import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_parcel_model.dart';

import 'finance_card.dart';

class ExpenseCard extends FinanceCard {
  ExpenseCard({
    super.key,
    required ExpenseParcelModel model,
  }) : super(
          name: model.name,
          overdueDate: model.overdueDate,
          remainingValue: model.remainingValue,
          status: model.status,
          totalValue: model.totalValue,
        );
}
