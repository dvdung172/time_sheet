// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      employeeIds: json['employee_ids'] as List<dynamic>,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['image_small'] as String?,
      lastUpdate: json['__last_update'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'employee_ids': instance.employeeIds,
      'image_small': instance.avatar,
      '__last_update': instance.lastUpdate,
    };
