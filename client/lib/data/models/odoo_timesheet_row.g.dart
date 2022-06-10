// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odoo_timesheet_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OdooTimeSheetRow _$OdooTimeSheetRowFromJson(Map<String, dynamic> json) =>
    OdooTimeSheetRow(
      userId: json['user_id'] as int,
      id: json['id'] as String,
      unitAmount: json['unit_amount'] as String,
      date: json['date'] as String,
      projectId: json['project_id'] as String,
      displayName: json['display_name'] as String,
      employeeId: json['employee_id'] as String,
      taskId: json['task_id'] as String,
    );

Map<String, dynamic> _$OdooTimeSheetRowToJson(OdooTimeSheetRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'unit_amount': instance.unitAmount,
      'date': instance.date,
      'project_id': instance.projectId,
      'display_name': instance.displayName,
      'employee_id': instance.employeeId,
      'task_id': instance.taskId,
    };
