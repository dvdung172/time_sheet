import 'package:charts_flutter/flutter.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/tab_index.dart';
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
    var tabIndexProvider = Provider.of<TabIndex>(context,listen: false);

    List<charts.Series<TimeSheet, String>> SheetData = [
      charts.Series<TimeSheet, String>(
        id: "General Coming",
        data: listTimeSheetProvider.get4Month(DateTime.now()),
        domainFn: (TimeSheet series, _) => DateFormat(DateFormat.YEAR_MONTH).format(series.sheetsDate),
        measureFn: (TimeSheet series, _) =>
            series.rows.map((e) => e.generalComing).toList().sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      charts.Series<TimeSheet, String>(
        id: "Over Time",
        data: listTimeSheetProvider.get4Month(DateTime.now()),
        domainFn: (TimeSheet series, _) => DateFormat(DateFormat.YEAR_MONTH).format(series.sheetsDate),
        measureFn: (TimeSheet series, _) =>
            series.rows.map((e) => e.overTime).toList().sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      charts.Series<TimeSheet, String>(
        id: "Leave",
        data: listTimeSheetProvider.get4Month(DateTime.now()),
        domainFn: (TimeSheet series, _) => DateFormat(DateFormat.YEAR_MONTH).format(series.sheetsDate),
        measureFn: (TimeSheet series, _) => series.rows
            .map((e) => e.leave?.timeoff)
            .toList()
            .whereNotNull()
            .toList()
            .sum,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];
    return SizedBox(
        height: 500,
        child: charts.BarChart(
          SheetData,
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
            SelectionModelConfig(
                changedListener: (SelectionModel model) {
                  tabIndexProvider.currentIndex = 1;
                  tabIndexProvider.date =  DateFormat(DateFormat.YEAR_MONTH).parse(model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
                }
            )
          ],
        ));
  }
}
