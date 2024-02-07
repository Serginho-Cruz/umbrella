import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_parcel_model.dart';

import 'finance_card.dart';

class IncomeCard extends FinanceCard {
  IncomeCard({
    super.key,
    required IncomeParcelModel model,
  }) : super(
          name: model.name,
          overdueDate: model.overdueDate,
          remainingValue: model.remainingValue,
          status: model.status,
          totalValue: model.totalValue,
        );
}
