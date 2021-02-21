import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/services/authentication_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';

class AuthorizationScreen extends StatefulWidget {
  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

enum AuthMode { singIn, singUp, resetPassword }
enum Field { mail, password, confirmPassword }

final List<GenericItemModel> accountTypes = [
  GenericItemModel(id: 'client', name: 'Klient'),
  GenericItemModel(id: 'manager', name: 'Manager'),
  GenericItemModel(id: 'employee', name: 'Pracownik'),
];

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  AuthMode _authMode = AuthMode.singIn;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _typeAccount = 'client';
  bool _passwordVisible = false;

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    GenericResponseModel responseMessage;
    switch (_authMode) {
      case AuthMode.singIn:
        {
          responseMessage = await context.read<AuthenticationService>().signIn(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );
        }
        break;
      case AuthMode.singUp:
        {
          if (_confirmPasswordController.text != _passwordController.text) {
            responseMessage =
                GenericResponseModel("The password is not the same", false);
          } else {
            responseMessage =
                await context.read<AuthenticationService>().signUp(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      typeAccount: _typeAccount,
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
    showBottomNotification(context, responseMessage);
  }

  bool get _isSingInShow {
    return _authMode == AuthMode.singIn;
  }

  void _onChangeTypeAccount(value) {
    _typeAccount = value;
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
                if (_authMode == AuthMode.singUp)
                  _formFactory.buildDropdownField(
                    labelText: 'Type account',
                    labelColor: Colors.white24,
                    labelDropdownColor: Colors.white,
                    dropdownColor: primaryColor,
                    items: accountTypes,
                    initialValue: _typeAccount,
                    onChangedHandler: _onChangeTypeAccount,
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
                RaisedButton(
                  color: accentColor,
                  child: Text(_getNameForButton,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
                  onPressed: () => _submit(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                if (_authMode != AuthMode.resetPassword)
                  FlatButton(
                    onPressed: () =>
                        _switchAuthMode(resetPassword: AuthMode.resetPassword),
                    child: Text(
                      'Forgot password',
                      style: TextStyle(
                        color: accentColor,
                      ),
                    ),
                  ),
                FlatButton(
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
