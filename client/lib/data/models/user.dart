import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.position,
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.lastUpdate,
  });

  final int id;

  final String name;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'department_id')
  final String? position;

  @JsonKey(name: 'image_small')
  final String? avatar;

  @JsonKey(name: '__last_update')
  final String lastUpdate;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() =>
      '$runtimeType {id: $id, username: $name, email: $email, position: $position, avatar: $avatar}';
}
