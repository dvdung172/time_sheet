import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hsc_timesheet/core/app_style.dart';
import 'package:hsc_timesheet/core/constants.dart';
import 'package:hsc_timesheet/core/di.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/core/routes.dart';
import 'package:hsc_timesheet/core/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsc_timesheet/presentation/providers/index.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController =
      TextEditingController(text: dotenv.env['USERNAME'] ?? '');
  final TextEditingController _passwordEditingController =
      TextEditingController(text: dotenv.env['PASSWORD'] ?? '');

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  bool _obscureText = true;
  bool _emailCheck = true;
  bool _passwordCheck = true;

  late bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
    _emailCheck = true;
    _passwordCheck = true;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      activeColor: CustomTheme.mainTheme.primaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text(tr('screens.login.remember_me')),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: _buildLoginButton(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr('screens.login.dont_have_account')),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          tr('screens.login.signup'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.mainTheme.primaryColor),
                        ))
                  ],
                ),
                SizedBox(
                  child: Text(tr('screens.login.signin_with')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70.0,
                      height: 70.0,
                      child: TextButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 44)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/login_google.png',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 70.0,
                      height: 70.0,
                      child: TextButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 44)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/login_facebook.png',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
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
            child: Icon(
              Icons.flutter_dash_rounded,
              size: 60,
            ),
            // Image(
            //   image: AssetImage("images/logo.png"),
            // ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            tr('screens.login.signin'),
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
    final authProvider = Provider.of<AuthProvider>(context);

    return ElevatedButton(
      focusNode: _viewNode,
      key: const Key("login"),
      style: AppStyles.buttonStyle,
      onPressed: () async {
        logger.d('Validating before login');
        var emailValid = _emailEditingController.text.isNotEmpty;
        var passwordValid = _passwordEditingController.text.isNotEmpty;
        setState(() {
          _emailCheck = emailValid;
          _passwordCheck = passwordValid;
        });

        if (emailValid && passwordValid) {
          logger.d('Logging in');
          var loginResponse = await authProvider.login(
              _emailEditingController.text, _passwordEditingController.text);
          if (loginResponse.status == 0) {
            logger.d('Logged in user: $loginResponse');
            await sl<UserProvider>().getUserById(loginResponse.data!.userId);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.home, (Route route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                '${tr('messages.login_failed')}\r\n${loginResponse.errors![0].message}',
                textAlign: TextAlign.center,
                style: AppStyles.messageStyle,
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ));
            logger.e('failed to login');
          }
        }
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
        errorText: _emailCheck == false
            ? tr('messages.invalid_item', args: ['email'])
            : null,
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
        labelText: tr('screens.login.email'),
        labelStyle: CustomTheme.mainTheme.textTheme.headline6,
      ),
      cursorColor: CustomColor.hintColor,
      onTap: () {
        setState(() {});
      },
      onFieldSubmitted: (term) {
        if (_emailEditingController.text.isNotEmpty) {
          setState(() {
            _emailCheck = true;
          });
        }
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
          errorText: _passwordCheck == false
              ? tr('messages.invalid_item', args: ['password'])
              : null,
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
          labelText: tr('screens.login.password'),
          labelStyle: CustomTheme.mainTheme.textTheme.headline5,
          suffixIcon: IconButton(
            icon: _obscureText == true
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.visibility_off),
            color: CustomColor.hintColor,
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        cursorColor: CustomColor.hintColor,
        onTap: () => setState(() {}),
        onFieldSubmitted: (term) {
          if (_passwordEditingController.text.isNotEmpty) {
            setState(() {
              _passwordCheck = true;
            });
          }
          _fieldFocusChange(context, _passwordNode, _viewNode);
        });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
