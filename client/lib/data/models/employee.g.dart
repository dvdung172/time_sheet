// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      departmentId: json['department_id'],
      id: json['id'] as int,
      name: json['name'] as String,
      workEmail: json['work_email'],
      avatar: json['image_small'] as String,
      lastUpdate: json['__last_update'] as String,
      workPhoneOdoo: json['work_phone'],
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'work_email': instance.workEmail,
      'department_id': instance.departmentId,
      'image_small': instance.avatar,
      '__last_update': instance.lastUpdate,
      'work_phone': instance.workPhoneOdoo,
    };
