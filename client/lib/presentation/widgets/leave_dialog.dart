import 'package:flutter/material.dart';

class LeaveDialog extends StatefulWidget {
  const LeaveDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaveDialog();
  }
}

class _LeaveDialog extends State<LeaveDialog> {
  late String? dropdownValue = null ;
  final _textcontroller = TextEditingController();
  List<String> leaveList = [];
  @override
  void initState() {
    super.initState();
  }
@override
  void dispose() {
    _textcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Leave'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
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
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _textcontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Time off',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            leaveList.add(dropdownValue!);
            leaveList.add(_textcontroller.text);
            Navigator.pop(context, leaveList);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
