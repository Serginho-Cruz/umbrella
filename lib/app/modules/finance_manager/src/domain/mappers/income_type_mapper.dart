import '../entities/income_type.dart';

abstract class IncomeTypeMapper {
  static Map<String, dynamic> toMap(IncomeType type) {
    return <String, dynamic>{
      'type_id': type.id,
      'type_name': type.name,
      'type_icon': type.icon,
    };
  }

  static IncomeType fromMap(Map<String, dynamic> map) {
    return IncomeType(
      id: map['type_id'] as int,
      name: map['type_name'] as String,
      icon: map['type_icon'] as String,
    );
  }
}
