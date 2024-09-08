import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/category.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/mappers/income_category_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/parse_objects.dart';

import '../../../infra/datasources/income_category_datasource.dart';
import '../functions.dart';

class Back4AppIncomeCategoryDatasource implements IncomeCategoryDatasource {
  @override
  Future<List<Category>> getAll() async {
    final object = IncomeCategoryObject();

    var query = QueryBuilder(object);
    query.orderByAscending('name');

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      var objects = response.results as List<ParseObject>;

      return objects.map(IncomeCategoryMapper.fromParse).toList();
    }

    throw extractFail(response);
  }
}
