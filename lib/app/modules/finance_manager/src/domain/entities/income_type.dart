import 'package:equatable/equatable.dart';

class IncomeType with EquatableMixin {
  int id;
  String name;
  String icon;

  IncomeType({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}
