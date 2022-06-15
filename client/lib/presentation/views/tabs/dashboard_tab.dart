import 'package:charts_flutter/flutter.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/presentation/providers/list_timesheet_provider.dart';
import 'package:hsc_timesheet/presentation/providers/tab_index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class DashBoardTab extends StatelessWidget {
  const DashBoardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listTimeSheetProvider = Provider.of<ListTimeSheetsProvider>(context);
    var tabIndexProvider = Provider.of<TabIndex>(context, listen: false);
    var timesheetData = listTimeSheetProvider.get4Month(DateTime.now());

    List<charts.Series<TimeSheet, String>> sheetData = [
      charts.Series<TimeSheet, String>(
        id: "General Coming",
        data: timesheetData,
        domainFn: (TimeSheet series, _) =>
            DateFormat(DateFormat.YEAR_NUM_MONTH).format(series.sheetsDate),
        measureFn: (TimeSheet series, _) =>
            series.rows.map((e) => e.generalComing).sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      charts.Series<TimeSheet, String>(
        id: "Over Time",
        data: timesheetData,
        domainFn: (TimeSheet series, _) =>
            DateFormat(DateFormat.YEAR_NUM_MONTH).format(series.sheetsDate),
        measureFn: (TimeSheet series, _) =>
            series.rows.map((e) => e.overTime).sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      charts.Series<TimeSheet, String>(
        id: "Leave",
        data: timesheetData,
        domainFn: (TimeSheet series, _) =>
            DateFormat(DateFormat.YEAR_NUM_MONTH).format(series.sheetsDate),
        measureFn: (TimeSheet series, _) =>
            series.rows.map((e) => e.leave?.timeoff ?? 0).sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];
    return SizedBox(
        height: 500,
        child: charts.BarChart(
          sheetData,
          animate: false,
          barGroupingType: charts.BarGroupingType.grouped,
          behaviors: [
            charts.SeriesLegend(),
            charts.ChartTitle('hours',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                    charts.OutsideJustification.startDrawArea),
          ],
          selectionModels: [
            SelectionModelConfig(changedListener: (SelectionModel model) {
              tabIndexProvider.currentIndex = 1;
              tabIndexProvider.date = DateFormat(DateFormat.YEAR_NUM_MONTH).parse(
                  model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index));

            }),
          ],
        ));
  }
}
