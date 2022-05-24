class Leave {
  late String reason;
  late double timeoff;

  Leave({required this.reason, required this.timeoff});

  factory Leave.fromJson(Map<String, dynamic> json) {
    try {
      return Leave(
        reason: json['reason'],
        timeoff: double.parse("${json['timeoff']}"),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class SheetsRow {
  late DateTime date;
  late double generalComing;
  late double overTime;
  late Leave? leave;
  late String? contents;

  SheetsRow(
      {required this.date,
      required this.generalComing,
      required this.overTime,
      required this.contents,
      required this.leave});

  factory SheetsRow.fromJson(Map<String, dynamic> json) {
    try {
      return SheetsRow(
        date: DateTime.parse(json['date']),
        generalComing: double.parse("${json['generalComing']}"),
        overTime: double.parse("${json['overTime']}"),
        contents: json['contents'] ?? '',
        leave: json['leave'] == null ? null : Leave.fromJson(json['leave']),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class TimeSheet {
  late DateTime sheetsDate;
  late int userId;
  late List<SheetsRow> rows;

  TimeSheet(
      {required this.sheetsDate, required this.rows, required this.userId});

  factory TimeSheet.fromJson(Map<String, dynamic> json) {
    final List<SheetsRow> temps = [];
    json["rows"].forEach((row) => temps.add(SheetsRow.fromJson(row)));
    try {
      return TimeSheet(
        userId: json['userId'],
        sheetsDate: DateTime.parse(json['sheetsDate']),
        rows: temps,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "sheetsDate": sheetsDate,
        "rows": List<dynamic>.from(rows.map((x) => x)),
      };
}
