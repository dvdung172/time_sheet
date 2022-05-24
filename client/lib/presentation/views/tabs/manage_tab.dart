import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);

class ManageTab extends StatefulWidget {
  const ManageTab({Key? key}) : super(key: key);

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
    ListTile(
      title: Text('tabs.home.title'),
      leading: const Icon(Icons.home),
      onTap: () {
        setState(() {
          visible = !visible;
        });
      },
    ),
     Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: visible,
       child: DataTable(
         columns: const <DataColumn>[
           DataColumn(
             label: Text(
               'Name',
               style: TextStyle(fontStyle: FontStyle.italic),
             ),
           ),
           DataColumn(
             label: Text(
               'Age',
               style: TextStyle(fontStyle: FontStyle.italic),
             ),
           ),
           DataColumn(
             label: Text(
               'Role',
               style: TextStyle(fontStyle: FontStyle.italic),
             ),
           ),
         ],
         rows: const <DataRow>[
           DataRow(
             cells: <DataCell>[
               DataCell(Text('Sarah')),
               DataCell(Text('19')),
               DataCell(Text('Student')),
             ],
           ),
           DataRow(
             cells: <DataCell>[
               DataCell(Text('Janine')),
               DataCell(Text('43')),
               DataCell(Text('Professor')),
             ],
           ),
           DataRow(
             cells: <DataCell>[
               DataCell(Text('William')),
               DataCell(Text('27')),
               DataCell(Text('Associate Professor')),
             ],
           ),
         ],
       ),
    ),
        ListTile(
          title: Text('tabs.home.title'),
          leading: const Icon(Icons.home),
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visible,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Age',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Role',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Sarah')),
                  DataCell(Text('19')),
                  DataCell(Text('Student')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Janine')),
                  DataCell(Text('43')),
                  DataCell(Text('Professor')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('William')),
                  DataCell(Text('27')),
                  DataCell(Text('Associate Professor')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
