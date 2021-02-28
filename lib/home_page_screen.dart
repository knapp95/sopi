import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/authentication_service.dart';
import 'package:sopi/ui/widgets/client_screen.dart';
import 'package:sopi/ui/widgets/common/dialogs/loading_data_in_progress.dart';
import 'package:sopi/ui/widgets/employee_screen.dart';
import 'package:sopi/ui/widgets/manager_screen.dart';

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
        return Column(
          children: [
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out -- tmp $_typeAccount"),
            ),
            Expanded(child: ClientScreen()),
          ],
        );
      case 'manager':
        return Column(
          children: [
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out -- tmp $_typeAccount"),
            ),
            Expanded(child: ManagerScreen()),
          ],
        );
      //  return ManagerScreen();
      case 'employee':
        return Column(
          children: [
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out -- tmp $_typeAccount"),
            ),
            Expanded(child: EmployeeScreen()),
          ],
        );
        return EmployeeScreen();
      default:
        return Container(child: Text('No data'));
    }
  }
}
