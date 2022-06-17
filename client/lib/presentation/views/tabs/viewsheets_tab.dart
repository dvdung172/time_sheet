import 'package:hsc_timesheet/core/di.dart';
import 'package:hsc_timesheet/core/theme.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/presentation/providers/index.dart';
import 'package:hsc_timesheet/presentation/providers/list_timesheet_provider.dart';
import 'package:hsc_timesheet/presentation/providers/tab_index.dart';
import 'package:hsc_timesheet/presentation/widgets/table_view.dart';
import 'package:hsc_timesheet/presentation/widgets/custom_month_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ViewSheets extends StatefulWidget {
  const ViewSheets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewSheets();
  }
}

class _ViewSheets extends State<ViewSheets> {
  late DateTime _date = Provider.of<TabIndex>(context).date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            DatePicker.showPicker(
              context,
              pickerModel: CustomMonthPicker(
                  minTime: DateTime(2020, 1, 1),
                  maxTime: DateTime.now(),
                  currentTime: _date),
              showTitleActions: true,
              onConfirm: (date) {
                setState(() {
                  _date = date;
                });
              },
            );
          },
          child: Text(
            DateFormat(DateFormat.YEAR_MONTH).format(_date),
            style: CustomTheme.mainTheme.textTheme.headline2,
          ),
        ),
        Consumer<ListTimeSheetsProvider>(builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final TimeSheet? timeSheet = provider.timeSheets.firstWhereOrNull(
                  (p) =>
              DateFormat(DateFormat.YEAR_MONTH)
                  .format(p.sheetsDate)
                  .compareTo(
                  DateFormat(DateFormat.YEAR_MONTH).format(_date)) ==
                  0);
          if (timeSheet == null) {
            return const Center(
              child: Text('No Time Sheet Available'),
            );
          } else {
            return TableView(
                timeSheet: timeSheet,
                canChanged: timeSheet.userId != sl<UserProvider>().currentUser!.id ? false : true);
          }
        }),
      ],
    );
  }
}
