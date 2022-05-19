import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/leave_dialog.dart';

class NewTimeSheet extends StatefulWidget {
  const NewTimeSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewTimeSheet();
  }
}

class _NewTimeSheet extends State<NewTimeSheet> {
  @override
  Widget build(BuildContext context) {
    DateTime _date = ModalRoute.of(context)!.settings.arguments as DateTime;//get argrument
    var numItems = DateUtils.getDaysInMonth(_date.year, _date.month);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Time Sheet'),
        actions:  [
          IconButton(onPressed: () {}, icon: const Icon(Icons.save_outlined))
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: InteractiveViewer(
        constrained: false,
        child: DataTable(
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
            numItems,
            (int index) => DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (DateTime(_date.year, _date.month, index + 1).weekday > 5) {
                  return Theme.of(context).primaryColor.withOpacity(0.4);
                } // Use default value for other states and odd rows.
              }),
              cells: <DataCell>[
                DataCell(Text(
                    DateFormat(DateFormat.YEAR_NUM_MONTH_WEEKDAY_DAY).format(DateTime(_date.year, _date.month, index + 1)))),
                DataCell(
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                      text:
                          DateTime(_date.year, _date.month, index + 1).weekday >
                                  5
                              ? ''
                              : '8',
                    ),
                  ),
                ),
                DataCell(
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                ),
                DataCell(const Text("-"),
                    onTap: () async {
                  List<String> _leave =  await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) =>
                        const LeaveDialog(),
                      );
                  print('sdas');
                  print(_leave[0]);
                    }),
                const DataCell(
                  TextField(
                    maxLines: 8, //or null
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
