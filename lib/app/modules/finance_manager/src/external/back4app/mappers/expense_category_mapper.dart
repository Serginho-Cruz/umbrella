import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseObject;

import '../../../domain/entities/category.dart';
import '../parse_objects.dart';

sealed class ExpenseCategoryMapper {
  static ExpenseCategoryObject toParse(Category category) {
    var object = ExpenseCategoryObject();

    object.objectId = category.id;
    object.set('name', category.name);
    object.set('iconName', category.icon);

    return object;
  }

  static Category fromParse(ParseObject object) {
    String id = object.objectId!;
    String name = object.get('name');
    String icon = object.get('iconName');

    return Category(id: id, name: name, icon: icon);
  }
}
