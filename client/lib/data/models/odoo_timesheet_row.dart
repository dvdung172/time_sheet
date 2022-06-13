import 'package:hsc_timesheet/data/models/index.dart';
import 'package:json_annotation/json_annotation.dart';

part 'odoo_timesheet_row.g.dart';

@JsonSerializable()
class OdooTimeSheetRow {
  OdooTimeSheetRow({
    required this.displayName,
    required this.projectIdOdoo,
    required this.employeeIdOdoo,
    required this.taskIdOdoo,
    required this.date,
    required this.userIdOdoo,
    required this.unitAmount,
     this.id,
  });

  @JsonKey(name: 'display_name')
  final String displayName;

  @JsonKey(name: 'project_id')
  final dynamic projectIdOdoo;
  int get projectId {
    if (projectIdOdoo is List<dynamic> && projectIdOdoo.isNotEmpty) {
      return projectIdOdoo[0] as int;
    }

    return 0;
  }

  String get projectName =>
      projectIdOdoo is List<dynamic> && projectIdOdoo.length > 1
          ? projectIdOdoo[1]
          : '';

  @JsonKey(name: 'employee_id')
  final dynamic employeeIdOdoo;
  int get employeeId {
    if (employeeIdOdoo is List<dynamic> && employeeIdOdoo.isNotEmpty) {
      return employeeIdOdoo[0] as int;
    }
    return 0;
  }

  String get employeeName =>
      employeeIdOdoo is List<dynamic> && employeeIdOdoo.length > 1
          ? employeeIdOdoo[1]
          : '';

  @JsonKey(name: 'task_id')
  final dynamic taskIdOdoo;
  int get taskId {
    if (taskIdOdoo is List<dynamic> && taskIdOdoo.isNotEmpty) {
      return taskIdOdoo[0] as int;
    }
    return 0;
  }

  String get taskName =>
      taskIdOdoo is List<dynamic> && taskIdOdoo.length > 1 ? taskIdOdoo[1] : '';

  final DateTime date;

  @JsonKey(name: 'user_id')
  final dynamic userIdOdoo;
  int get userId {
    if (userIdOdoo is List<dynamic> && userIdOdoo.length > 0) {
      return userIdOdoo[0] as int;
    }
    return 0;
  }

  String get userName =>
      userIdOdoo is List<dynamic> && userIdOdoo.length > 1 ? userIdOdoo[1] : '';

  @JsonKey(name: 'unit_amount')
  final double unitAmount;

  final int? id;

  factory OdooTimeSheetRow.fromJson(Map<String, dynamic> json) =>
      _$OdooTimeSheetRowFromJson(json);

  Map<String, dynamic> toJson() => _$OdooTimeSheetRowToJson(this);

  @override
  String toString() =>
      '$runtimeType {id: $id, user_id: $userId, unit_amount: $unitAmount, date: $date, project_id: $projectId, display_name: $displayName, employee_id: $employeeId, task_id: $taskId}';
}
