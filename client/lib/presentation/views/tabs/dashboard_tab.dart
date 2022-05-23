import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
class DashBoardTab extends StatelessWidget {
  const DashBoardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ListTimeSheetsProvider>(context);

    List<charts.Series<TimeSheet, String>> SheetData = [
      charts.Series<TimeSheet, String>(
        id: "General Coming",
        data: provider.timeSheets,
        domainFn: (TimeSheet series, _) => series.sheetsDate.month.toString(),
        measureFn: (TimeSheet series, _) => series.rows.map((e) => e.generalComing).toList().sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      charts.Series<TimeSheet, String>(
        id: "Over Time",
        data: provider.timeSheets,
        domainFn: (TimeSheet series, _) => series.sheetsDate.month.toString(),
        measureFn: (TimeSheet series, _) => series.rows.map((e) => e.overTime).toList().sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      charts.Series<TimeSheet, String>(
        id: "Leave",
        data: provider.timeSheets,
        domainFn: (TimeSheet series, _) => series.sheetsDate.month.toString(),
        measureFn: (TimeSheet series, _) => series.rows.map((e) => e.leave?.timeoff).toList().whereNotNull().toList().sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];
    return SizedBox(
        height: 500,
        child: charts.BarChart(
          SheetData,
          animate: false,
          barGroupingType: charts.BarGroupingType.grouped,
          behaviors: [charts.SeriesLegend()],
        ));
  }
}
