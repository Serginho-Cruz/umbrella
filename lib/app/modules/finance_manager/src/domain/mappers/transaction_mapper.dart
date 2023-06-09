import '../../external/schemas/transaction_table.dart';
import '../../utils/extensions.dart';
import '../entities/expense_parcel.dart';
import '../entities/income_parcel.dart';
import '../entities/transaction.dart';
import 'expense_parcel_mapper.dart';
import 'income_parcel_mapper.dart';

abstract class TransactionMapper {
  static Map<String, dynamic> toMap(Transaction transaction) =>
      <String, dynamic>{
        TransactionTable.id: transaction.id,
        TransactionTable.value: transaction.value,
        TransactionTable.date: transaction.date.date,
        TransactionTable.expenseParcelId:
            transaction.parcel is ExpenseParcel ? transaction.parcel.id : null,
        TransactionTable.incomeParcelId:
            transaction.parcel is IncomeParcel ? transaction.parcel.id : null,
      };

  static Transaction fromMap(Map<String, dynamic> map) {
    var parcel = map[TransactionTable.expenseParcelId] != null
        ? ExpenseParcelMapper.fromMap(map)
        : IncomeParcelMapper.fromMap(map);

    return Transaction(
      id: map[TransactionTable.id] as int,
      value: map[TransactionTable.value] as double,
      date: DateTime.parse(map[TransactionTable.date] as String),
      parcel: parcel,
    );
  }
}
