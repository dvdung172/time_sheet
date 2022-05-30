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
    'General Coming',
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
        onLongPress: widget.canChanged == true
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
        firstColumnWidth: 100,
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
        rows: List.generate(
            widget.timeSheet.rows.length,
            (rowIndex) => ExpandableTableRow(
                    height: 60,
                    firstCell: cusTomeCell(
                        index: rowIndex,
                        text: DateFormat('EE, dd/MM')
                            .format(widget.timeSheet.rows[rowIndex].date)),
                    children: <Widget>[
                      cusTomeCell(
                        index: rowIndex,
                        text: widget.timeSheet.rows[rowIndex].generalComing
                            .toString(),
                      ),
                      cusTomeCell(
                        index: rowIndex,
                        text:
                            widget.timeSheet.rows[rowIndex].overTime.toString(),
                      ),
                      cusTomeCell(
                          index: rowIndex,
                          text: widget.timeSheet.rows[rowIndex].leave == null
                              ? '-'
                              : '${widget.timeSheet.rows[rowIndex].leave?.reason}: ${widget.timeSheet.rows[rowIndex].leave?.timeoff}'),
                      cusTomeCell(
                        index: rowIndex,
                        text:
                            "${widget.timeSheet.rows[rowIndex].contents ?? ''}",
                      ),
                    ])),
      ),
    );
  }

  void longPress(BuildContext context, int index) {
    String? dropdownValue = widget.timeSheet.rows[index].leave?.reason;
    TextEditingController _gcController = TextEditingController(
        text: widget.timeSheet.rows[index].generalComing.toString());
    TextEditingController _otController = TextEditingController(
        text: widget.timeSheet.rows[index].overTime.toString());
    TextEditingController _leaveController = TextEditingController(
        text: widget.timeSheet.rows[index].leave?.timeoff.toString());
    TextEditingController _contentController = TextEditingController(
        text: widget.timeSheet.rows[index].contents.toString());
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(DateFormat('EEEE, dd/MM')
                  .format(widget.timeSheet.rows[index].date)),
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
                      widget.timeSheet.rows[index] = SheetsRow(
                          date: widget.timeSheet.rows[index].date,
                          generalComing: double.parse(_gcController.text == ''
                              ? '0'
                              : _gcController.text),
                          overTime: double.parse(_otController.text == ''
                              ? '0'
                              : _otController.text),
                          contents: _contentController.text == ""
                              ? null
                              : _contentController.text,
                          leave: dropdownValue == null
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
