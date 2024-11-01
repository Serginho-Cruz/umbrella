import '../../../domain/entities/income.dart';
import '../parse_objects.dart';
import 'account_mapper.dart';
import 'income_category_mapper.dart';

sealed class FrequentIncomeMapper {
  static FrequentIncomeObject toParse(Income income) {
    var object = FrequentIncomeObject();

    object.objectId = income.frequentIncomeId;
    object.set('name', income.name);
    object.set('totalValue', income.totalValue);
    object.set('frequency', income.frequency);
    object.set('overdueDate', income.dueDate.toDateTime());
    object.set('personName', income.personName);
    object.set('category', IncomeCategoryMapper.toParse(income.category));
    object.set('account', AccountMapper.toParse(income.account));

    return object;
  }
}
