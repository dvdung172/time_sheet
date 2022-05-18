import 'package:client/core/di.dart';
import 'package:client/core/theme.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:client/presentation/widgets/custom_month_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class ViewSheets extends StatefulWidget {
  const ViewSheets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewSheets();
  }
}

class _ViewSheets extends State<ViewSheets> {
  late DateTime _date= Provider.of<TimeSheetProvider>(context).timeSheet!.rows[0].date;
  @override
  void initState() {
    super.initState();
    sl<TimeSheetProvider>().getTimeSheetById(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
              '${DateFormat(DateFormat.YEAR_MONTH).format(_date)}',
              style: CustomTheme.mainTheme.textTheme.headline2,
            )),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<TimeSheetProvider>(
                    builder: (context, provider, child) {
                  if (provider.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                   final timeSheet = provider.timeSheet!;
                  return DataTable(
                    dividerThickness: 0,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text(
                          'General\ncomming',
                          maxLines: 2,
                        ),
                      ),
                      DataColumn(
                        label: Text('OverTime'),
                      ),
                      DataColumn(
                        label: Text('Leave'),
                      ),
                      DataColumn(
                        label: Text('Task contents'),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      timeSheet.rows.length,
                      (int index) => DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          // All rows will have the same selected color.
                          if (timeSheet.rows[index].date
                                  .weekday >
                              5) {
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(0.4);
                          } // Use default value for other states and odd rows.
                        }),
                        cells: <DataCell>[
                          DataCell(Text(
                              '${DateFormat(DateFormat.YEAR_NUM_MONTH_WEEKDAY_DAY).format(timeSheet.rows[index].date)}')),
                          DataCell(
                            Text('${timeSheet.rows[index].generalComing}'),
                          ),
                          DataCell(
                            Text('${timeSheet.rows[index].overTime.toString()}'),
                          ),
                          DataCell(

                            Text(timeSheet.rows[index].leave==null ? '-' : '${timeSheet.rows[index].leave?.reason}: ${timeSheet.rows[index].leave?.timeoff}'),
                          ),
                          DataCell(
                            Text('${timeSheet.rows[index].contents}'),
                          ),
                        ],
                        onLongPress: () {},
                      ),
                    ),
                  );
                })),
          ),
        ),
      ],
    );
  }
}
