import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/client_screen.dart';
import 'package:sopi/ui/widgets/common/dialogs/loading_data_in_progress.dart';
import 'package:sopi/ui/widgets/employee_screen.dart';
import 'package:sopi/ui/widgets/manager_screen.dart';


class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final typeAccount = context.watch<UserModel>().typeAccount;
    return typeAccount == null
        ? LoadingDataInProgress(withScaffold: true)
        : _buildPageForTypeAccount(typeAccount);
  }

  Widget _buildPageForTypeAccount(String typeAccount) {
    switch (typeAccount) {
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
