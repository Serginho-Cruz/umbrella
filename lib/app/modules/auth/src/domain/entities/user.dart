class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.token,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }
}
