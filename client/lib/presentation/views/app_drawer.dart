import 'package:hsc_timesheet/core/routes.dart';
import 'package:hsc_timesheet/core/utility.dart';
import 'package:hsc_timesheet/presentation/providers/tab_index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsc_timesheet/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../core/di.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // key: _drawerKey,
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          _buildHeader(context),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final usernameStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle2!.color,
      fontSize: 20,
    );
    final userEmailStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle2!.color!.withOpacity(0.5),
      fontSize: 14,
    );
    // TODOs
    var currentUser = sl<UserProvider>().currentUser!;

    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.zero,
      child: DrawerHeader(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        // decoration: const BoxDecoration(color: Colors.red),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.grey,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: (currentUser.avatar != null)
                  ? CircleAvatar(
                      radius: 32,
                      foregroundImage: NetworkImage(currentUser.avatar!),
                      backgroundColor: Colors.grey,
                      child: Text(currentUser.name.getLetterFromName()),
                    )
                  : CircleAvatar(
                      radius: 32,
                      foregroundImage:
                          const AssetImage('assets/images/user-thumbnail.png'),
                      backgroundColor: Colors.grey,
                      child: Text(currentUser.name.getLetterFromName()),
                    ),
            ),
            const SizedBox(height: 10),
            Text(currentUser.name, style: usernameStyle),
            Text(currentUser.email, style: userEmailStyle)
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var provider = Provider.of<TabIndex>(context);

    return Column(
      children: [
        ListTile(
          title: Text(tr('tabs.home.title')),
          leading: const Icon(Icons.home),
          selectedColor: Theme.of(context).primaryColor,
          selected: provider.currentIndex == 0,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 0;
          },
        ),
        ListTile(
          title: Text(tr('tabs.views.title')),
          leading: const Icon(Icons.book_outlined),
          selectedColor: Theme.of(context).primaryColor,
          selected: provider.currentIndex == 1,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 1;
          },
        ),
        ListTile(
          title: Text(tr('tabs.manage.title')),
          leading: const Icon(Icons.people_alt),
          selectedColor: Theme.of(context).primaryColor,
          selected: provider.currentIndex == 2,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 2;
          },
        ),
        ListTile(
          title: Text(tr('tabs.settings.title')),
          leading: const Icon(Icons.settings),
          selectedColor: Theme.of(context).primaryColor,
          selected: provider.currentIndex == 3,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 3;
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            tr('common.logout'),
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          leading: Icon(Icons.logout, color: Theme.of(context).errorColor),
          onTap: () async {
            await showDialog<String>(
              context: scaffoldKey.currentContext!,
              builder: _buildConfirmLogoutDialog,
            );
          },
        ),
      ],
    );
  }

  Widget _buildConfirmLogoutDialog(BuildContext context) {
    var provider = sl<TabIndex>();
    return AlertDialog(
      title: Text(tr('drawer.confirm_logout_dialog.title')),
      content: Text(tr('drawer.confirm_logout_dialog.confirm_content')),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(scaffoldKey.currentContext!, 'Cancel'),
          child: Text(
            tr('common.cancel'),
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
        TextButton(
          onPressed: () async {
            // close dialog and drawer
            Navigator.pop(context, 'OK'); // close alert
            Navigator.of(scaffoldKey.currentContext!).pop();

            await logout();
            // then go back to login screen
            provider.clear();
            await Navigator.of(scaffoldKey.currentContext!)
                .pushReplacementNamed(Routes.login);
          },
          child: Text(
            tr('common.ok'),
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }

  Future<void> logout() async {
    //throw UnimplementedError('app_drawer.logout');
    print('logout');
  }
}
