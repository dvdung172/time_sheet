import 'package:odoo_rpc/odoo_rpc.dart';

class AppSession {
  static OdooSession? session;
  static OdooClient baseURL = OdooClient('http://172.29.4.126:8069');
}