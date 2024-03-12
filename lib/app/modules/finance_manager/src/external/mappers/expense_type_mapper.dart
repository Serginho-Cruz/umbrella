import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_type_table.dart';

import '../../domain/entities/expense_type.dart';

abstract class ExpenseTypeMapper {
  static Map<String, dynamic> toMap(ExpenseType type) {
    return {
      ExpenseTypeTable.id: type.id,
      ExpenseTypeTable.name: type.name,
      ExpenseTypeTable.icon: type.icon,
    };
  }

  static ExpenseType fromMap(Map<String, dynamic> map) {
    return ExpenseType(
      id: map[ExpenseTypeTable.id] as int,
      name: map[ExpenseTypeTable.name] as String,
      icon: map[ExpenseTypeTable.icon] as String,
    );
  }
}
