import '../../external/schemas/income_table.dart';
import '../../utils/extensions.dart';
import '../entities/frequency.dart';
import '../entities/income.dart';
import 'income_type_mapper.dart';

abstract class IncomeMapper {
  static Map<String, dynamic> toMap(Income income) {
    return <String, dynamic>{
      IncomeTable.id: income.id,
      IncomeTable.name: income.name,
      IncomeTable.value: income.value,
      IncomeTable.typeId: income.type.id,
      IncomeTable.paymentDate: income.paymentDate.date,
      IncomeTable.frequency: frequencyToInt(income.frequency),
      IncomeTable.personName: income.personName,
    };
  }

  static Income fromMap(Map<String, dynamic> map) {
    return Income(
      id: map[IncomeTable.id] as int,
      name: map[IncomeTable.name] as String,
      value: map[IncomeTable.value] as double,
      type: IncomeTypeMapper.fromMap(map),
      paymentDate: DateTime.parse(map[IncomeTable.paymentDate] as String),
      frequency: frequencyFromInt(map[IncomeTable.frequency] as int),
      personName: map[IncomeTable.personName] as String?,
    );
  }
}
