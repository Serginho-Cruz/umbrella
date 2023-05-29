import '../../external/schemas/income_type_table.dart';

import '../entities/income_type.dart';

abstract class IncomeTypeMapper {
  static Map<String, dynamic> toMap(IncomeType type) {
    return <String, dynamic>{
      IncomeTypeTable.id: type.id,
      IncomeTypeTable.name: type.name,
      IncomeTypeTable.icon: type.icon,
    };
  }

  static IncomeType fromMap(Map<String, dynamic> map) {
    return IncomeType(
      id: map[IncomeTypeTable.id] as int,
      name: map[IncomeTypeTable.name] as String,
      icon: map[IncomeTypeTable.icon] as String,
    );
  }
}
