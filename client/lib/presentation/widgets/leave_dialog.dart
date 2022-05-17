import 'package:flutter/material.dart';

class LeaveDialog extends StatefulWidget {
  const LeaveDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaveDialog();
  }
}

class _LeaveDialog extends State<LeaveDialog> {
  String dropdownValue = '-Select leave-';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Leave'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                '-Select leave-',
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
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                labelText: 'Time off',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
