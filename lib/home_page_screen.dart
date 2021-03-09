import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/client/client_screen.dart';
import 'package:sopi/ui/widgets/common/dialogs/loading_data_in_progress.dart';
import 'package:sopi/ui/widgets/employee/employee_screen.dart';
import 'package:sopi/ui/widgets/manager/manager_screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String _typeAccount;

  @override
  void didChangeDependencies() {
    _typeAccount = Provider.of<UserModel>(context).typeAccount;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _typeAccount == null
        ? LoadingDataInProgress(withScaffold: true)
        : _buildPageForTypeAccount(context);
  }

  Widget _buildPageForTypeAccount(BuildContext context) {
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
