// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odoo_timesheet_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OdooTimeSheetRow _$OdooTimeSheetRowFromJson(Map<String, dynamic> json) =>
    OdooTimeSheetRow(
      name: json['name'] as String?,
      projectIdOdoo: json['project_id'],
      employeeIdOdoo: json['employee_id'],
      taskIdOdoo: json['task_id'],
      date: DateTime.parse(json['date'] as String),
      userIdOdoo: json['user_id'],
      unitAmount: (json['unit_amount'] as num).toDouble(),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$OdooTimeSheetRowToJson(OdooTimeSheetRow instance) =>
    <String, dynamic>{
      'name': instance.name,
      'project_id': instance.projectIdOdoo,
      'employee_id': instance.employeeIdOdoo,
      'task_id': instance.taskIdOdoo,
      'date': instance.date.toIso8601String(),
      'user_id': instance.userIdOdoo,
      'unit_amount': instance.unitAmount,
      'id': instance.id,
    };
