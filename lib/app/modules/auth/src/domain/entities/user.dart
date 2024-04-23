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
}
