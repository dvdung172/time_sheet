import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class DashBoardTab extends StatelessWidget {
  DashBoardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TimeSheetProvider>(context, listen: false);
    List<charts.Series<TimeSheet, String>> generalComing = [
      charts.Series(
        id: "General Coming",
        data: provider.timeSheets,
        domainFn: (TimeSheet series, _) => series.sheetsDate.month.toString(),
        measureFn: (TimeSheet series, _) => series.rows.map((e) => e.generalComing).reduce((value, element) => value + element),
        seriesColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];

    return Container(
        height: 500,
        child: charts.BarChart(
          generalComing,
          animate: true,
          barGroupingType: charts.BarGroupingType.grouped,
          primaryMeasureAxis: new charts.NumericAxisSpec(
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
          secondaryMeasureAxis: new charts.NumericAxisSpec(
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
        ));
  }
}
