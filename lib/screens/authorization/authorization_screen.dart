import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/auth_service.dart';
import 'package:sopi/widgets/dialogs/info_dialog.dart';
import 'package:sopi/factory/field_builder_factory.dart';

class AuthorizationScreen extends StatefulWidget {
  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

enum AuthMode { singIn, singUp, resetPassword }
enum Field { mail, password, confirmPassword }

final List<GenericItemModel> accountTypes = [
  GenericItemModel(id: 'client', name: 'Klient'),
  GenericItemModel(id: 'menager', name: 'Menager'),
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

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      Auth auth = Provider.of<Auth>(context, listen: false);
      switch (_authMode) {
        case AuthMode.singIn:
          {
            await auth.login(
              _emailController.text,
              _passwordController.text,
            );
          }
          break;
        case AuthMode.singUp:
          {
            await auth.signUp(
              _emailController.text,
              _passwordController.text,
            );

            if (auth.isAuth) {
              print(auth.userId);
               DatabaseReference _dbReference = FirebaseDatabase.instance.reference().child('test');
//               _dbReference.set('testowa wartość -- ${auth.userId}');

            }

          }
          break;
        case AuthMode.resetPassword:
          {
            await auth.resetPassword(
              _passwordController.text,
            );
          }
          break;
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => InfoDialog(
            title: 'Error', content: 'The data you\'ve entered is incorrect.'),
      );
    }
  }

  bool get _isSingInShow {
    return _authMode == AuthMode.singIn;
  }

  void _onChangeTypeAccount(value) {
    _typeAccount = value;
  }

  void _switchAuthMode({AuthMode resetPassword}) {
    UserModel.test();

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
      backgroundColor: Theme.of(context).primaryColor,
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
                ),
                if (_authMode == AuthMode.singUp)
                  _formFactory.buildDropdownField(
                    labelText: 'Type account',
                    items: accountTypes,
                    onChanged: _onChangeTypeAccount,
                  ),
                _formFactory.buildTextField(
                  isVisible: _authMode != AuthMode.resetPassword,
                  controller: _passwordController,
                  labelText: 'Password',
                  suffixIcon: _buildSuffixIconPassword(),
                  obscureText: !_passwordVisible,
                ),
                _formFactory.buildTextField(
                  isVisible: _authMode == AuthMode.singUp,
                  controller: _confirmPasswordController,
                  labelText: 'Repeat password',
                  suffixIcon: _buildSuffixIconPassword(),
                  obscureText: !_passwordVisible,
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(_getNameForButton,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
                  onPressed: _submit,
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
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _isSingInShow ? 'Register' : 'Log in',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
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
