import 'package:client/core/constants.dart';
import 'package:client/core/di.dart';
import 'package:client/core/routes.dart';
import 'package:client/core/theme.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _viewNode.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isKeyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(Constants.DEFAULT_PAGE_PADDING),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildHeader(isKeyboardOpen),
                _buildEmailField(context),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                ),
                _buildPasswordField(context),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: _buildLoginButton(),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                ),
                const SizedBox(
                  height: 40,
                  child: Text('or'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(tr('screens.login.login_with_fb')),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(tr('screens.login.login_with_gg')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isKeyboardOpen) {
    if (!isKeyboardOpen) {
      return Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 74),
          ),
          const SizedBox(
            width: 60,
            height: 60,
            child: Image(
              image: AssetImage("images/logo.png"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            "Login",
            style: CustomTheme.mainTheme.textTheme.headline2,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
          ),
        ],
      );
    }
    return const Padding(
      padding: EdgeInsets.only(top: 74),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      key: const Key("login"),
      // shape: RoundedRectangleBorder(
      //   borderRadius: new BorderRadius.circular(4.0),
      // ),
      // color: CustomColor.logoBlue,
      onPressed: () async {
        sl<ListTimeSheetsProvider>().getAllTimeSheets();
        await Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.home, (Route route) => false);
      },
      child: Text(
        tr('common.login'),
        style: CustomTheme.mainTheme.textTheme.button,
      ),
    );
  }

  TextFormField _buildEmailField(BuildContext context) {
    return TextFormField(
      focusNode: _emailNode,
      controller: _emailEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        focusColor: CustomColor.hintColor,
        hoverColor: CustomColor.hintColor,
        fillColor: CustomColor.textFieldBackground,
        filled: true,
        labelText: "Email*",
        labelStyle: CustomTheme.mainTheme.textTheme.headline6,
      ),
      cursorColor: CustomColor.hintColor,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _emailNode, _passwordNode);
      },
    );
  }

  TextFormField _buildPasswordField(BuildContext context) {
    return TextFormField(
      focusNode: _passwordNode,
      controller: _passwordEditingController,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        focusColor: CustomColor.hintColor,
        hoverColor: CustomColor.hintColor,
        fillColor: CustomColor.textFieldBackground,
        filled: true,
        labelText: "Password*",
        labelStyle: CustomTheme.mainTheme.textTheme.headline5,
        suffixIcon: IconButton(
          icon: const Icon(Icons.remove_red_eye),
          color: CustomColor.hintColor,
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      cursorColor: CustomColor.hintColor,
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
