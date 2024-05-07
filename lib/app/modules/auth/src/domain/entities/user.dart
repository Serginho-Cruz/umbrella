class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final bool isToReminder;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.isToReminder = false,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    bool? isToReminder,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isToReminder: isToReminder ?? this.isToReminder,
    );
  }
}
