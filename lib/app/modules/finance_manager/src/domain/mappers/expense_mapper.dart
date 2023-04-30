import '../entities/expense.dart';
import '../../utils/datetime_extension.dart';
import '../entities/frequency.dart';
import 'expense_type_mapper.dart';
import 'payment_method_mapper.dart';

abstract class ExpenseMapper {
  static Map<String, dynamic> toMap(Expense expense) {
    return <String, dynamic>{
      'expense_id': expense.id,
      'expense_value': expense.value,
      'expense_name': expense.name,
      'expense_expirationDate': expense.expirationDate.date,
      'expense_personName': expense.personName,
      'expense_paymentMethod': expense.paymentMethod.id,
      'expense_frequency': frequencyToInt(expense.frequency),
      'expense_type': expense.type.id,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      value: map['value'] as double,
      name: map['name'] as String,
      personName: map['personName'] as String,
      expirationDate: DateTime.parse(map['expense_expirationDate'] as String),
      paymentMethod: PaymentMethodMapper.fromMap(map),
      frequency: frequencyFromInt(map['frequency'] as int),
      type: ExpenseTypeMapper.fromMap(map),
    );
  }
}
