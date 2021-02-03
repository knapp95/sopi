import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/providers/Auth.dart';
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
            title: 'Error',
            content: 'The data you\'ve entered is incorrect.'),
      );
    }
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
          name = 'Logowanie';
        }
        break;
      case AuthMode.singUp:
        {
          name = 'Rejestracja';
        }
        break;
      case AuthMode.resetPassword:
        {
          name = 'Przypomnij hasło';
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
                  'Bogate smaki i niepowtarzalne wnętrza,\n restauracja z głębokimi tradycjami.',
                  style: TextStyle(color: Colors.white),
                ),
                _formFactory.buildTextField(
                  controller: _emailController,
                  labelText: 'Adres e-mail',
                ),
                _formFactory.buildDropdownField(
                  isVisible: _authMode != AuthMode.singUp,
                  labelText: 'Typ konta',
                  items: accountTypes,
                ),
                _formFactory.buildTextField(
                  isVisible: _authMode != AuthMode.resetPassword,
                  controller: _passwordController,
                  labelText: 'Hasło',
                  suffixIcon: _buildSuffixIconPassword(),
                  obscureText: !_passwordVisible,
                ),
                _formFactory.buildTextField(
                  isVisible: _authMode == AuthMode.singUp,
                  controller: _confirmPasswordController,
                  labelText: 'Powtórz hasło',
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
                      'Zapomniałem hasła',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _isSingInShow ? 'Nie mam jeszcze konta' : 'Logowanie',
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
