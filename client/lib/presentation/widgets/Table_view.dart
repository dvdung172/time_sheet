import 'package:client/data/models/timesheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class TableView extends StatefulWidget {
  const TableView({Key? key, required this.timeSheet, this.canChanged})
      : super(key: key);
  final bool? canChanged;
  final TimeSheet timeSheet;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final List _headers = [
    'Date',
    'General\nComing',
    'Over Time',
    'Leave',
    'Task Content'
  ];

  @override
  Widget build(BuildContext context) {
    cusTomeCell({
      required int index,
      required String text,
    }) {
      return InkWell(
        onTap: widget.canChanged == true
            ? () {
                longPress(context, index);
              }
            : null,
        child: Container(
            margin: const EdgeInsets.only(bottom: 0.5),
            color: widget.timeSheet.rows[index].date.weekday > 5
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            child: Center(
              child: Text(text),
            )),
      );
    }

    return Expanded(
      child: ExpandableTable(
        headerHeight: 50,
        firstColumnWidth: 80,
        header: ExpandableTableHeader(
            firstCell: Container(
                margin: const EdgeInsets.all(1),
                child: Center(
                    child: Text(
                  _headers[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))),
            children: List.generate(
                _headers.length - 1,
                (index) => Container(
                    margin: const EdgeInsets.all(1),
                    child: Center(
                        child: Text(
                      _headers[index + 1],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))))),
        rows: List.generate(widget.timeSheet.rows.length, (rowIndex) {
          var row = widget.timeSheet.rows[rowIndex];
          return ExpandableTableRow(
              height: 60,
              firstCell: cusTomeCell(
                  index: rowIndex, text: DateFormat('EE, dd').format(row.date)),
              children: <Widget>[
                cusTomeCell(
                  index: rowIndex,
                  text: row.generalComing.toString(),
                ),
                cusTomeCell(
                  index: rowIndex,
                  text: row.overTime.toString(),
                ),
                cusTomeCell(
                    index: rowIndex,
                    text: row.leave == null
                        ? '-'
                        : '${row.leave?.reason}: ${row.leave?.timeoff}'),
                cusTomeCell(
                  index: rowIndex,
                  text: "${row.contents ?? ''}",
                ),
              ]);
        }),
      ),
    );
  }

  void longPress(BuildContext context, int index) {
    var row = widget.timeSheet.rows[index];
    String? dropdownValue = row.leave?.reason;
    TextEditingController _gcController =
        TextEditingController(text: row.generalComing.toString());
    TextEditingController _otController =
        TextEditingController(text: row.overTime.toString());
    TextEditingController _leaveController =
        TextEditingController(text: row.leave?.timeoff.toString());
    TextEditingController _contentController =
        TextEditingController(text: row.contents.toString());
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(DateFormat('EEEE, dd/MM').format(row.date)),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'General Coming'),
                          controller: _gcController,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Over Time'),
                          controller: _otController,
                        ),
                        DropdownButton<String>(
                          value: dropdownValue,
                          hint: const Text('-Select reason-'),
                          disabledHint: null,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Annual leave',
                            'Special holiday',
                            'Sick leave',
                            'Unpaid leave',
                            'Compensation leave'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Time Off'),
                          controller: _leaveController,
                        ),
                        TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration:
                              const InputDecoration(labelText: 'Task Contents'),
                          controller: _contentController,
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_leaveController.text == "") {
                        _leaveController.text = '0';
                      }
                      widget.timeSheet.rows[index] = SheetsRow(
                          date: row.date,
                          generalComing: double.parse(_gcController.text == ''
                              ? '0'
                              : _gcController.text),
                          overTime: double.parse(_otController.text == ''
                              ? '0'
                              : _otController.text),
                          contents: _contentController.text == ""
                              ? null
                              : _contentController.text,
                          leave: dropdownValue == null ||
                                  _leaveController.text == '0'
                              ? null
                              : Leave(
                                  reason: dropdownValue!,
                                  timeoff:
                                      double.parse(_leaveController.text)));
                    });
                    //
                    // _gcController.dispose();
                    // _contentController.dispose();
                    // _leaveController.dispose();
                    // _otController.dispose();

                    Navigator.pop(context, null);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
