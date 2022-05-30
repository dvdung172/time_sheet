import 'package:flutter/material.dart';

class TabIndex extends ChangeNotifier {
  int _currentIndex = 0;
  DateTime _date = DateTime.now();
  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  DateTime get date => _date;
  set date(DateTime index) {
    _date = index;
    notifyListeners();
  }

}
