import 'package:json_annotation/json_annotation.dart';

// part 'timesheet.g.dart';

// @JsonSerializable()
class Leave {
  late String? reason;
  late double? timeoff;

  Leave({
    required this.reason,
    required this.timeoff,
  });
  //
  // factory Leave.fromJson(Map<String, dynamic> json) => _$LeaveFromJson(json);
  // Map<String, dynamic> toJson() => _$LeaveToJson(this);
}

// @JsonSerializable()
class SheetsRow {
  late DateTime date;
  late double generalComing;
  late double overTime;
  late Leave? leave;
  late String contents;

  SheetsRow({
    required this.date,
    required this.generalComing,
    required this.overTime,
    required this.leave,
    required this.contents,
  });

  // factory SheetsRow.fromJson(Map<String, dynamic> json) =>
  //     _$SheetsRowFromJson(json);
  // Map<String, dynamic> toJson() => _$SheetsRowToJson(this);
}

// @JsonSerializable()
class TimeSheet {
  late int? id;
  late DateTime sheetsDate;
  late dynamic employeeId;
  late List<SheetsRow> rows;
  late bool approval;

  TimeSheet({
    this.id,
    required this.sheetsDate,
    required this.employeeId,
    required this.rows,
    required this.approval,
  });

  SheetsRow addRow(SheetsRow newRow) {
    rows.add(newRow);

    return newRow;
  }
  //
  // factory TimeSheet.fromJson(Map<String, dynamic> json) =>
  //     _$TimeSheetFromJson(json);
  // Map<String, dynamic> toJson() => _$TimeSheetToJson(this);
}
