class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;

  @override
  String toString() =>
      '$runtimeType {id: $id, username: $name, email: $email, avatar: $avatar}';
}
