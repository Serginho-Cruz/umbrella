import '../../external/schemas/expense_table.dart';
import '../../utils/extensions.dart';
import '../entities/expense.dart';
import '../entities/frequency.dart';
import 'expense_type_mapper.dart';

abstract class ExpenseMapper {
  static Map<String, dynamic> toMap(Expense expense) {
    return <String, dynamic>{
      ExpenseTable.id: expense.id,
      ExpenseTable.value: expense.value,
      ExpenseTable.name: expense.name,
      ExpenseTable.expirationDate: expense.expirationDate.date,
      ExpenseTable.personName: expense.personName,
      ExpenseTable.frequency: frequencyToInt(expense.frequency),
      ExpenseTable.typeId: expense.type.id,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map[ExpenseTable.id] as int,
      value: map[ExpenseTable.value] as double,
      name: map[ExpenseTable.name] as String,
      personName: map[ExpenseTable.personName] as String?,
      expirationDate:
          DateTime.parse(map[ExpenseTable.expirationDate] as String),
      frequency: frequencyFromInt(map[ExpenseTable.frequency] as int),
      type: ExpenseTypeMapper.fromMap(map),
    );
  }
}
