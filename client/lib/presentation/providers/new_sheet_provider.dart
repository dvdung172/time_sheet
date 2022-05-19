import 'package:client/data/models/timesheet.dart';
import 'package:flutter/material.dart';

class NewSheetProvider extends ChangeNotifier {
  TimeSheet? timeSheet;
  List<SheetsRow>? rows;

  NewSheetProvider(Object object);



}
