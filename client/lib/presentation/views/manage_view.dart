import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/core/theme.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/presentation/providers/list_timesheet_provider.dart';
import 'package:hsc_timesheet/presentation/providers/timesheet_creation_provider.dart';
import 'package:hsc_timesheet/presentation/widgets/table_view.dart';
import 'package:hsc_timesheet/presentation/widgets/custom_month_picker.dart';
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
    final args = ModalRoute.of(context)?.settings.arguments as List<dynamic> ;
    logger.d(args.toString());
    return Scaffold(
        backgroundColor: args[1] == "approval" ? null : const Color(0xFFD5D3D3),
        appBar: AppBar(
          title: args[1] == "approval" ? Text('Not Approved') : Text('Approved'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: args[1] == "approval"
            ? Column(
                children: [
                  Consumer<ListTimeSheetsProvider>(
                      builder: (context, provider, child) {
                    if (provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return TableView(timeSheet: provider.unapprovedTimeSheets[args[0]]);
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
            : Column(
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
                  Consumer<ListTimeSheetsProvider>(
                      builder: (context, provider, child) {
                    if (provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final TimeSheet? timeSheet = provider.timeSheets
                        .firstWhereOrNull((p) =>
                            DateFormat(DateFormat.YEAR_MONTH)
                                .format(p.sheetsDate)
                                .compareTo(DateFormat(DateFormat.YEAR_MONTH)
                                    .format(_date)) ==
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
