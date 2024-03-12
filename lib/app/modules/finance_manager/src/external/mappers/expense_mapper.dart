import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_table.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import 'expense_type_mapper.dart';

abstract class ExpenseMapper {
  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map[ExpenseTable.id] as int,
      name: map[ExpenseTable.name] as String,
      totalValue: map[ExpenseTable.totalValue] as double,
      paidValue: map[ExpenseTable.paidValue] as double,
      remainingValue: map[ExpenseTable.remainingValue] as double,
      paymentDate: map[ExpenseTable.paymentDate] == null
          ? null
          : Date.parse(map[ExpenseTable.paymentDate] as String),
      dueDate: Date.parse(map[ExpenseTable.overdueDate] as String),
      type: ExpenseTypeMapper.fromMap(map),
      frequency: FrequencyMethods.fromInt(map[ExpenseTable.frequency] as int),
      personName: map[ExpenseTable.personName] as String?,
    );
  }

  static Map<String, dynamic> toMap(Expense expense) {
    return {
      ExpenseTable.id: expense.id,
      ExpenseTable.name: expense.name,
      ExpenseTable.totalValue: expense.totalValue,
      ExpenseTable.paidValue: expense.paidValue,
      ExpenseTable.remainingValue: expense.remainingValue,
      ExpenseTable.overdueDate: expense.dueDate.toString(),
      ExpenseTable.paymentDate: expense.paymentDate.toString(),
      ExpenseTable.personName: expense.personName,
      ExpenseTable.frequency: expense.frequency.toInt(),
      ExpenseTable.typeId: expense.type.id,
    };
  }
}
