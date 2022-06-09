// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leave _$LeaveFromJson(Map<String, dynamic> json) => Leave(
      reason: json['reason'] as String?,
      timeoff: (json['timeoff'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LeaveToJson(Leave instance) => <String, dynamic>{
      'reason': instance.reason,
      'timeoff': instance.timeoff,
    };

SheetsRow _$SheetsRowFromJson(Map<String, dynamic> json) => SheetsRow(
      date: DateTime.parse(json['date'] as String),
      generalComing: (json['generalComing'] as num).toDouble(),
      overTime: (json['overTime'] as num).toDouble(),
      leave: json['leave'] == null
          ? null
          : Leave.fromJson(json['leave'] as Map<String, dynamic>),
      contents: json['contents'] as String?,
    );

Map<String, dynamic> _$SheetsRowToJson(SheetsRow instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'generalComing': instance.generalComing,
      'overTime': instance.overTime,
      'leave': instance.leave,
      'contents': instance.contents,
    };

TimeSheet _$TimeSheetFromJson(Map<String, dynamic> json) => TimeSheet(
      id: json['id'] as int?,
      sheetsDate: DateTime.parse(json['sheetsDate'] as String),
      userId: json['userId'] as int,
      rows: (json['rows'] as List<dynamic>)
          .map((e) => SheetsRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      approval: json['approval'] as bool,
    );

Map<String, dynamic> _$TimeSheetToJson(TimeSheet instance) => <String, dynamic>{
      'id': instance.id,
      'sheetsDate': instance.sheetsDate.toIso8601String(),
      'userId': instance.userId,
      'rows': instance.rows,
      'approval': instance.approval,
    };
