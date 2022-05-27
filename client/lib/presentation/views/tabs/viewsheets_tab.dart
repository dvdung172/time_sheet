import 'package:client/core/theme.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/widgets/Table_view.dart';
import 'package:client/presentation/widgets/custom_month_picker.dart';
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
            )),
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
            return TableView(timeSheet: timeSheet, canChanged: true);
          }
        }),
      ],
    );
  }
}
