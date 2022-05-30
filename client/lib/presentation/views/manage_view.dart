import 'package:client/core/di.dart';
import 'package:client/core/theme.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:client/presentation/widgets/Table_view.dart';
import 'package:client/presentation/widgets/custom_month_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
class ManageView extends StatefulWidget {
  const ManageView({Key? key}) : super(key: key);

  @override
  State<ManageView> createState() => _ManageViewState();
}

class _ManageViewState extends State<ManageView> {
  late DateTime _date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: args == "approval"?Text('Not Approved'):Text('Approved'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: args == "approval"
            ? Column(
                children: [
                  Consumer<TimeSheetProvider>(
                      builder: (context, provider, child) {
                    if (provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return TableView(timeSheet: provider.timeSheet);
                    }
                  }),
                  BottomAppBar(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          child: TextButton(
                            child: const Text('APPROVE'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          child: TextButton(
                            child: const Text(
                              'DECLINE',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            :  Column(
          children: [
            Center(
              child: TextButton(
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
                return TableView(timeSheet: timeSheet);
              }
            })
          ],
        ));
  }
}
