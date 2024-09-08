import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/category.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/mappers/expense_category_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/parse_objects.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/expense_category_datasource.dart';

import '../functions.dart';

class Back4AppExpenseCategoryDatasource implements ExpenseCategoryDatasource {
  @override
  Future<List<Category>> getAll() async {
    final object = ExpenseCategoryObject();

    var query = QueryBuilder(object);
    query.orderByAscending('name');

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      var objects = response.results as List<ParseObject>;

      return objects.map(ExpenseCategoryMapper.fromParse).toList();
    }

    throw extractFail(response);
  }
}
