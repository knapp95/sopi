import 'package:flutter/material.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/screens/client_screen.dart';
import 'package:sopi/screens/employee_screen.dart';
import 'package:sopi/screens/manager_screen.dart';
import 'package:sopi/widgets/dialogs/loading_data_in_progress.dart';

class HomePageScreen extends StatefulWidget {
  final firebaseUser;
  HomePageScreen(this.firebaseUser);
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String _typeAccount;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _getTypeAccount();
    super.initState();
  }

  _getTypeAccount() {

    UserModel.getUserTypeAccountFromFirebase(widget.firebaseUser?.uid).then(
      (value) => setState(() {
        _typeAccount = value;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingDataInProgress(withScaffold: true) : _buildPageForTypeAccount();
  }

  Widget _buildPageForTypeAccount() {
    switch (_typeAccount) {
      case 'client':
        return ClientScreen();
      case 'manager':
        return ManagerScreen();
      case 'employee':
        return EmployeeScreen();
      default:
        return Container(child: Text('No data'));
    }
  }

}
