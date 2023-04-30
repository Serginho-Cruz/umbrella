import '../entities/frequency.dart';
import '../entities/income.dart';
import '../../utils/datetime_extension.dart';
import 'income_type_mapper.dart';

abstract class IncomeMapper {
  static Map<String, dynamic> toMap(Income income) {
    return <String, dynamic>{
      'income_id': income.id,
      'income_name': income.name,
      'income_value': income.value,
      'income_type': income.type.id,
      'income_paymentDay': income.paymentDay.date,
      'income_frequency': frequencyToInt(income.frequency),
      'income_personName': income.personName,
    };
  }

  static Income fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['income_id'] as int,
      name: map['income_name'] as String,
      value: map['income_value'] as double,
      type: IncomeTypeMapper.fromMap(map),
      paymentDay: DateTime.parse(map['income_paymentDay'] as String),
      frequency: frequencyFromInt(map['income_frequency'] as int),
      personName: map['income_personName'] as String,
    );
  }
}
