import 'package:odoo_rpc/odoo_rpc.dart';

class AppSession {
  static OdooSession? _session;

  static OdooSession? get session => _session;

  static set session(OdooSession? session) {
    _session = session;
  }
}