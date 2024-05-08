import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int id;
  final String name;
  final bool isDefault;
  final double actualBalance;

  const Account({
    required this.id,
    required this.name,
    required this.actualBalance,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, isDefault, actualBalance];
}
