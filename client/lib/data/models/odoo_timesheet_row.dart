import 'package:json_annotation/json_annotation.dart';

part 'odoo_timesheet_row.g.dart';

@JsonSerializable()
class OdooTimeSheetRow {
  OdooTimeSheetRow(
      {required this.userId,
        required this.id,
        required this.unitAmount,
        required this.date,
        required this.projectId,
        required this.displayName,
        required this.employeeId,
        required this.taskId});

  final String id;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'unit_amount')
  final String unitAmount;

  final String date;

  @JsonKey(name: 'project_id')
  final String projectId;

  @JsonKey(name: 'display_name')
  final String displayName;

  @JsonKey(name: 'employee_id')
  final String employeeId;

  @JsonKey(name: 'task_id')
  final String taskId;

  factory OdooTimeSheetRow.fromJson(Map<String, dynamic> json) =>
      _$OdooTimeSheetRowFromJson(json);

  Map<String, dynamic> toJson() => _$OdooTimeSheetRowToJson(this);

  @override
  String toString() =>
      '$runtimeType {id: $id, user_id: $userId, unit_amount: $unitAmount, date: $date, project_id: $projectId, display_name: $displayName, employee_id: $employeeId, task_id: $taskId}';
}