class User {
  const User({
    required this.position,
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  final int id;
  final String name;
  final String email;
  final String position;
  final String avatar;

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
          email: json['email'],
          avatar: json['avatar'],
          name: json['name'],
          id: json['userId'], position: json['position']);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  String toString() =>
      '$runtimeType {id: $id, username: $name, email: $email, position: $position, avatar: $avatar}';
}
