import 'package:equatable/equatable.dart';

class ExpenseType with EquatableMixin {
  int id;
  String name;
  String icon;

  ExpenseType({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}
