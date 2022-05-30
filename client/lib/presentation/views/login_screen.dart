import 'package:client/core/constants.dart';
import 'package:client/core/routes.dart';
import 'package:client/core/theme.dart';
import 'package:client/core/utility.dart';
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
                    const Text('Remember me'),
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
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                const SizedBox(
                  child: Text('Or sign in with...'),
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
                        child: Image.network(
                            'https://pngimg.com/uploads/google/small/google_PNG19635.png',
                            fit: BoxFit.cover),
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
                        child: Image.network(
                            'https://pngimg.com/uploads/facebook_logos/facebook_logos_PNG19753.png',
                            fit: BoxFit.cover),
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
            "Sign In",
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
    return FlatButton(
      focusNode: _viewNode,
      key: const Key("login"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: CustomColor.logoBlue,
      onPressed: () async {
        if (_emailEditingController.text.isEmail() == true &&
            _emailEditingController.text.isNotEmpty == true) {
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.home, (Route route) => false);
        } else {
          print('login failed');
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
        errorText: _emailCheck == false ? 'invalid email' : null,
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
      onChanged: (value) {
        if (_emailEditingController.text.isEmail() == true) {
          setState(() {
            _emailCheck = true;
          });
        }
      },
      onFieldSubmitted: (term) {
        if (_emailEditingController.text.isEmail() == true) {
          _fieldFocusChange(context, _emailNode, _passwordNode);
        } else {
          setState(() {
            _emailCheck = false;
          });
        }
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
          errorText: _passwordCheck == false ? 'invalid password' : null,
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
        onFieldSubmitted: (term) {
          if (_passwordEditingController.text.isNotEmpty) {
            setState(() {
              _passwordCheck = true;
            });
            _fieldFocusChange(context, _passwordNode, _viewNode);
          } else {
            setState(() {
              _passwordCheck = false;
            });
          }
        });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
