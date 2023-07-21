import 'package:equatable/equatable.dart';

class ExpenseType extends Equatable {
  final int id;
  final String name;
  final String icon;

  const ExpenseType({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}
