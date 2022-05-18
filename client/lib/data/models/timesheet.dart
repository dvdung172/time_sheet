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

class DataRow {
  final DateTime date;
  final double generalComing;
  final double overTime;
  final Leave? leave;
  final String contents;

  DataRow(
      {required this.date,
      required this.generalComing,
      required this.overTime,
      required this.contents,
      this.leave});

  factory DataRow.fromJson(Map<String, dynamic> json) {
    try {
      return DataRow(
        date: DateTime.parse(json['date']),
        generalComing: double.parse("${json['generalComing']}"),
        overTime: double.parse("${json['overTime']}"),
        contents: json['contents'],
        leave: json['leave'] == null ? null : Leave.fromJson(json['leave']),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class TimeSheet {
  final DateTime id;
  final int userId;
  final List<DataRow> rows;

  TimeSheet({required this.id, required this.userId, required this.rows});

  factory TimeSheet.fromJson(Map<String, dynamic> json) {
    final List<DataRow> temprows = [];
    json["rows"].forEach((row) => temprows.add(DataRow.fromJson(row)));
    try {
      return TimeSheet(
        id: DateTime.parse(json['id']),
        userId: json['userId'],
        rows: temprows,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "rows": List<dynamic>.from(rows.map((x) => x)),
      };
}
