import '../entities/expense_type.dart';

abstract class ExpenseTypeMapper {
  static Map<String, dynamic> toMap(ExpenseType type) {
    return <String, dynamic>{
      'type_id': type.id,
      'type_name': type.name,
      'type_icon': type.icon,
    };
  }

  static ExpenseType fromMap(Map<String, dynamic> map) {
    return ExpenseType(
      id: map['type_id'] as int,
      name: map['type_name'] as String,
      icon: map['type_icon'] as String,
    );
  }
}
