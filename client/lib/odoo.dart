import 'dart:io';

import 'package:odoo_rpc/odoo_rpc.dart';

// void sessionChanged(OdooSession sessionId) async {
//   print('We got new session ID: ' + sessionId.id);
//   // write to persistent storage
// }
//
// void loginStateChanged(OdooLoginEvent event) async {
//   if (event == OdooLoginEvent.loggedIn) {
//     print('Logged in');
//   }
//   if (event == OdooLoginEvent.loggedOut) {
//     print('Logged out');
//   }
// }
//
// void inRequestChanged(bool event) async {
//   if (event) print('Request is executing'); // draw progress indicator
//   if (!event) print('Request is finished'); // hide progress indicator
// }

void main() async {
  // Restore session ID from storage and pass it to client constructor.
  const baseUrl = 'http://172.29.4.126:8069';
  final client = OdooClient(baseUrl);
  // // Subscribe to session changes to store most recent one
  // var subscription = client.sessionStream.listen(sessionChanged);
  // var loginSubscription = client.loginStream.listen(loginStateChanged);
  // var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  try {
    // Authenticate to server with db name and credentials
    final session = await client.authenticate('odoo', 'admin', 'admin');
    // Read our user's fields
    // final uid = session.userId;
    var res = await client.callKw({
      'model': 'account.analytic.line',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [['date', '=','2022-06-09'],['user_id', '=',16]],
        'fields': [],
      },
    });
    print('\nUser info: \n' + res.toString());
    // compute avatar url if we got reply
    // if (res.length == 1) {
    //   var unique = res[0]['__last_update'] as String;
    //   unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
    // }
    //
    // Create partner
    // var partner_id = await client.callKw({
    //   'model': 'res.partner',
    //   'method': 'delete',
    //   'args': [
    //     {'partner_id': 99},
    //   ],
    //   'kwargs': {},
    // });
    // print(partner_id);
    // // Update partner by id
    // res = await client.callKw({
    //   'model': 'account.analytic.line',
    //   'method': 'create',
    //   'args': [
    //     {
    //       'unit_amount': 9.0,
    //       'date': '2022-06-08',
    //       'project_id': 4,
    //       'employee_id': 2,
    //       'name':'vsdvsdv'
    //     },
    //   ],
    //   'kwargs': {},
    // });
    // print(res);
    //
    // // Get list of installed modules
    // res = await client.callRPC('/web/session/modules', 'call', {});
    // print('\nInstalled modules: \n' + res.toString());
    //
    // // Check if loggeed in
    //
    //
    // // Log out
    // print('\nDestroying session');
    // await client.destroySession();
    // print('ok');
  } on OdooException catch (e) {
    // Cleanup on odoo exception
    print(e);
    // await subscription.cancel();
    // await loginSubscription.cancel();
    // await inRequestSubscription.cancel();
    client.close();
    exit(-1);
  }

  // print('\nChecking session while logged out');
  // try {
  //   var res = await client.checkSession();
  //   print(res);
  // } on OdooSessionExpiredException {
  //   print('Odoo Exception:Session expired');
  // }
  // await client.inRequestStream.isEmpty;
  // await subscription.cancel();
  // await loginSubscription.cancel();
  // await inRequestSubscription.cancel();
  // client.close();
}