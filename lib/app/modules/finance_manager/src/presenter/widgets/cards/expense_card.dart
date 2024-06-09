import '../../../domain/models/expense_model.dart';
import 'finance_card.dart';

class ExpenseCard extends FinanceCard {
  ExpenseCard({
    super.key,
    required ExpenseModel model,
  }) : super(
          name: model.name,
          overdueDate: model.overdueDate,
          remainingValue: model.remainingValue,
          status: model.status,
          totalValue: model.totalValue,
        );
}
