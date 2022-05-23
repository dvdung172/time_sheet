import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);
class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  ExpandableTable _buildSimpleTable() {
    const int COLUMN_COUNT = 20;
    const int ROW_COUNT = 20;

    //Creation header
    ExpandableTableHeader header = ExpandableTableHeader(
        firstCell: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: const Center(
                child: Text(
                  'Simple\nTable',
                  style: textStyle,
                ))),
        children: List.generate(
            COLUMN_COUNT - 1,
                (index) => Container(
                color: primaryColor,
                margin: const EdgeInsets.all(1),
                child: Center(
                    child: Text(
                      'Column $index',
                      style: textStyle,
                    )))));
//Creation rows
    List<ExpandableTableRow> rows = List.generate(
        ROW_COUNT,
            (rowIndex) => ExpandableTableRow(
          height: 50,
          firstCell: Container(
            width: 10,
              color: primaryColor,
              margin: const EdgeInsets.all(1),
              child: Center(
                  child: Text(
                    'Row $rowIndex',
                    style: textStyle,
                  ))),
          children: List<Widget>.generate(
              COLUMN_COUNT - 1,
                  (columnIndex) => Container(
                  color: primaryColor,
                  margin: const EdgeInsets.all(1),
                  child: Center(
                      child: Text(
                        'Cell $rowIndex:$columnIndex',
                        style: textStyle,
                      )))),
        ));

    return ExpandableTable(
      headerHeight: 100,
      firstColumnWidth: 100,
      rows: rows,
      header: header,
      scrollShadowColor: accentColor,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildSimpleTable(),
    );
  }
}
