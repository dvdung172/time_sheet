class Leave {
  final String reason;
  final double timeoff;

  Leave({required this.reason, required this.timeoff});

  factory Leave.fromJson(Map<String, dynamic> json) {
    try {
      return Leave(
        reason: json['reason'] ,
        timeoff: double.parse("${json['timeoff']}"),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class SheetsRow {

  final DateTime date;
  final double generalComing;
  final double overTime;
  final Leave? leave;
  final String? contents;

  SheetsRow(
      {required this.date,
      required this.generalComing,
      required this.overTime,
      this.contents,
      this.leave});

  factory SheetsRow.fromJson(Map<String, dynamic> json) {
    try {
      return SheetsRow(
        date: DateTime.parse(json['date']),
        generalComing: double.parse("${json['generalComing']}"),
        overTime: double.parse("${json['overTime']}"),
        contents: json['contents'] ?? '' ,
        leave: json['leave'] == null ? null : Leave.fromJson(json['leave']),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class TimeSheet {
  final int id;
  final DateTime sheetsDate;
  final int userId;
  final List<SheetsRow> rows;

  TimeSheet( {required this.id,required this.sheetsDate, required this.userId, required this.rows});

  factory TimeSheet.fromJson(Map<String, dynamic> json) {
    final List<SheetsRow> temps = [];
    json["rows"].forEach((row) => temps.add(SheetsRow.fromJson(row)));
    try {
      return TimeSheet(
        id:json['id'] ,
        sheetsDate: DateTime.parse(json['sheetsDate']),
        userId: json['userId'],
        rows: temps,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
    "sheetsDate": sheetsDate,
        "userId": userId,
        "rows": List<dynamic>.from(rows.map((x) => x)),
      };
}
