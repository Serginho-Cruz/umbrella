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

  Account copyWith({
    int? id,
    String? name,
    bool? isDefault,
    double? actualBalance,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      actualBalance: actualBalance ?? this.actualBalance,
    );
  }

  @override
  List<Object?> get props => [id, name, isDefault, actualBalance];
}
