import 'package:client/core/di.dart';
import 'package:client/core/theme.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:client/presentation/views/tabs/viewsheets_tab.dart';
import 'package:client/presentation/widgets/Table_view.dart';
import 'package:client/presentation/widgets/custom_month_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class ManageView extends StatefulWidget {
  const ManageView({Key? key}) : super(key: key);

  @override
  State<ManageView> createState() => _ManageViewState();
}

class _ManageViewState extends State<ManageView> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: Text('TimeSheet'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: args == "approval"
            ? Column(
                children: [
                  Consumer<TimeSheetProvider>(
                      builder: (context, provider, child) {
                    if (provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return TableView(timeSheet: provider.timeSheet);
                    }
                  }),
                  BottomAppBar(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: TextButton(
                              child: const Text('APPROVE'),
                              onPressed: () {
                                /* ... */
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: TextButton(
                              child: const Text(
                                'DECLINE',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                /* ... */
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : ViewSheets());
  }
}
