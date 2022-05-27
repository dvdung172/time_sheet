
import 'package:client/core/routes.dart';
import 'package:client/core/utility.dart';
import 'package:client/data/models/user.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


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
    // TODO
    const currentUser = User(
      id: 1,
      name: 'Demo User',
      email: 'demo@mail.com',
      position: 'Empolyee',
      avatar: 'https://i.pravatar.cc/100',
    );

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
              child: CircleAvatar(
                radius: 32,
                foregroundImage: NetworkImage(currentUser.avatar),
                // NetworkImage(currentUser.avatar),
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
          selected: provider.currentIndex == 0,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 0;
          },
        ),
        ListTile(
          title: Text(tr('tabs.views.title')),
          leading: const Icon(Icons.book_outlined),
          selected: provider.currentIndex == 1,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 1;
          },
        ),
        ListTile(
          title: Text(tr('tabs.manage.title')),
          leading: const Icon(Icons.people_alt),
          selected: provider.currentIndex == 2,
          onTap: () {
            Navigator.pop(context);
            provider.currentIndex = 2;
          },
        ),
        ListTile(
          title: Text(tr('tabs.settings.title')),
          leading: const Icon(Icons.settings),
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
          leading: const Icon(Icons.logout),
          onTap: () async {
            await showDialog<String>(
              context: scaffoldKey.currentContext!,
              builder: _buildConfirmLogoutDialog,
            );
          },
        ),
        if (kDebugMode || dotenv.env['ENABLE_DEV_FEATURES'] == 'true')
          _buildDeveloperMenu(context),
      ],
    );
  }

  Widget _buildDeveloperMenu(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Testing area (dev only)',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
        ListTile(
          title: const Text(
            'Charts',
            style: TextStyle(color: Colors.red),
          ),
          leading: const Icon(
            Icons.add_chart_outlined,
            color: Colors.red,
          ),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.of(context).pushNamed(Routes.testChart);
          },
        ),
        ListTile(
          title: const Text(
            'Open map',
            style: TextStyle(color: Colors.red),
          ),
          leading: const Icon(
            Icons.open_in_browser,
            color: Colors.red,
          ),
          onTap: () async {
            // const _url = 'https://www.aliexpress.com/';
            const _url =
                'https://www.google.com/maps/search/?api=1&query=52.32,4.917';
            await canLaunchUrl(Uri.parse(_url))
                ? await launchUrl(Uri.parse(_url))
                : throw Exception('Could not launch $_url');
          },
        ),
      ],
    );
  }

  Widget _buildConfirmLogoutDialog(BuildContext context) => AlertDialog(
        title: Text(tr('drawer.confirm_logout_dialog.title')),
        content: Text(tr('drawer.confirm_logout_dialog.confirm_content')),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(scaffoldKey.currentContext!, 'Cancel'),
            child: Text(
              tr('common.cancel'),
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              // close dialog and drawer
              Navigator.pop(context, 'OK'); // close alert
              Navigator.of(scaffoldKey.currentContext!).pop();

              await logout();

              // then go back to login screen
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

  Future<void> logout() async {
    throw UnimplementedError('app_drawer.logout');
  }
}
