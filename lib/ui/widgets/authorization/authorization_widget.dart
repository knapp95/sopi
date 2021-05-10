import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/services/authentication_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class AuthorizationWidget extends StatefulWidget {
  @override
  _AuthorizationWidgetState createState() => _AuthorizationWidgetState();
}

enum AuthMode { singIn, singUp, resetPassword }
enum Field { mail, password, confirmPassword }

class _AuthorizationWidgetState extends State<AuthorizationWidget> {
  final _formKey = GlobalKey<FormState>();
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  AuthMode _authMode = AuthMode.singIn;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;

  void _submit(BuildContext context) async {
    /// TODO comment for test
    // if (!_formKey.currentState.validate()) {
    //   return;
    // }

    _formKey.currentState.save();
    GenericResponseModel responseMessage;
    switch (_authMode) {
      case AuthMode.singIn:
        {
          // await context.read<AuthenticationService>().signIn(
          //       email: 'client@wp.pl',
          //       password: 'client123',
          //     );
          // responseMessage = await context.read<AuthenticationService>().signIn(
          //       email: 'kamil@wp.pl',
          //       password: 'kamil123',
          //     );
          responseMessage = await context.read<AuthenticationService>().signIn(
                email: 'manager@wp.pl',
                password: 'manager123',
              );
        }
        break;
      case AuthMode.singUp:
        {
          if (_confirmPasswordController.text != _passwordController.text) {
            responseMessage = GenericResponseModel(
              "The password is not the same",
              correct: false,
            );
          } else {
            responseMessage =
                await context.read<AuthenticationService>().signUp(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
          }
        }
        break;
      case AuthMode.resetPassword:
        {
          responseMessage =
              await context.read<AuthenticationService>().resetPassword(
                    email: _emailController.text.trim(),
                  );
        }
        break;
    }
    if (responseMessage != null)
      showBottomNotification(context, responseMessage);
  }

  bool get _isSingInShow {
    return _authMode == AuthMode.singIn;
  }

  void _switchAuthMode({AuthMode resetPassword}) {
    if (resetPassword != null) {
      setState(() {
        _authMode = AuthMode.resetPassword;
      });
    } else {
      if (_isSingInShow) {
        setState(() {
          _authMode = AuthMode.singUp;
        });
      } else {
        setState(() {
          _authMode = AuthMode.singIn;
        });
      }
    }
  }

  String get _getNameForButton {
    String name = '';
    switch (_authMode) {
      case AuthMode.singIn:
        {
          name = 'Sign in';
        }
        break;
      case AuthMode.singUp:
        {
          name = 'Registration';
        }
        break;
      case AuthMode.resetPassword:
        {
          name = 'Forget password';
        }
        break;
    }
    return name;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: mediaQuery.size.width * 0.1,
              right: mediaQuery.size.width * 0.1,
              top: mediaQuery.size.height * 0.1,
            ),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/sopi_logo.png',
                  width: mediaQuery.size.width * 0.7,
                ),
                SizedBox(height: 20),
                Text(
                  'Rich flavors and unique interiors, \n a restaurant with deep traditions.',
                  style: TextStyle(color: Colors.white),
                ),
                _formFactory.buildTextField(
                  controller: _emailController,
                  labelText: 'Adress e-mail',
                  labelColor: Colors.white24,
                  valueColor: Colors.white,
                ),
                _formFactory.buildTextField(
                  isVisible: _authMode != AuthMode.resetPassword,
                  controller: _passwordController,
                  labelText: 'Password',
                  labelColor: Colors.white24,
                  valueColor: Colors.white,
                  suffixIcon: _buildSuffixIconPassword(),
                  obscureText: !_passwordVisible,
                ),
                _formFactory.buildTextField(
                  isVisible: _authMode == AuthMode.singUp,
                  controller: _confirmPasswordController,
                  labelText: 'Repeat password',
                  labelColor: Colors.white24,
                  valueColor: Colors.white,
                  suffixIcon: _buildSuffixIconPassword(),
                  obscureText: !_passwordVisible,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(_getNameForButton,
                      style: TextStyle(
                        fontSize: fontSize20,
                        color: Colors.black,
                      )),
                  onPressed: () => _submit(context),
                ),
                if (_authMode != AuthMode.resetPassword)
                  TextButton(
                    onPressed: () =>
                        _switchAuthMode(resetPassword: AuthMode.resetPassword),
                    child: Text(
                      'Forgot password',
                      style: TextStyle(
                        color: accentColor,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _isSingInShow ? 'Register' : 'Log in',
                    style: TextStyle(
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuffixIconPassword() {
    return IconButton(
      icon: Icon(
        _passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    );
  }
}
