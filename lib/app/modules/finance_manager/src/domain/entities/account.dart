import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int id;
  final String name;
  final bool isDefault;

  const Account({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, isDefault];
}
