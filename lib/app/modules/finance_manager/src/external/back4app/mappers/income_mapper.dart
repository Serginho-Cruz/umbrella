import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseObject;

import '../../../domain/entities/account.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/frequency.dart';
import '../../../domain/entities/income.dart';
import '../parse_objects.dart';
import 'account_mapper.dart';
import 'income_category_mapper.dart';

sealed class IncomeMapper {
  static IncomeObject toParse(Income income, {bool noId = false}) {
    var object = IncomeObject();

    if (!noId) object.objectId = income.id;

    object.set('name', income.name);
    object.set('totalValue', income.totalValue);
    object.set('paidValue', income.paidValue);
    object.set('remainingValue', income.remainingValue);
    object.set('frequency', income.frequency.toInt());
    object.set('overdueDate', income.dueDate.toDateTime());
    object.set('personName', income.personName);
    object.set('category', IncomeCategoryMapper.toParse(income.category));
    object.set('account', AccountMapper.toParse(income.account));

    return object;
  }

  static Income fromParse(ParseObject object) {
    String id = object.objectId!;
    String name = object.get('name') as String;
    double totalValue = (object.get('totalValue') as num).toDouble();
    double paidValue = (object.get('paidValue') as num).toDouble();
    double remainingValue = (object.get('remainingValue') as num).toDouble();
    String? personName = object.get('personName') as String?;
    String? frequentIncomeId = object.get('frequent')?.objectId;

    Frequency frequency =
        FrequencyMethods.fromInt(object.get('frequency') as int);

    Date dueDate = Date.fromDateTime(object.get('overdueDate') as DateTime);

    Account account =
        AccountMapper.fromParse(object.get('account') as ParseObject);

    Category category =
        IncomeCategoryMapper.fromParse(object.get('category') as ParseObject);

    return Income(
      id: id,
      name: name,
      totalValue: totalValue,
      paidValue: paidValue,
      remainingValue: remainingValue,
      frequency: frequency,
      dueDate: dueDate,
      account: account,
      category: category,
      personName: personName,
      frequentIncomeId: frequentIncomeId,
    );
  }
}
