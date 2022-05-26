import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/Table_view.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Provider.of<ListTimeSheetsProvider>(context).timeSheets[0].sheetsDate.toString()),
        TableView(timeSheet: Provider.of<ListTimeSheetsProvider>(context).timeSheets[0],),
      ],
    );
  }
}
