import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/client/client_widget.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/employee/employee_widget.dart';
import 'package:sopi/ui/widgets/manager/manager_widget.dart';

class HomePageWrapper extends StatefulWidget {
  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  UserType _typeAccount;

  @override
  void didChangeDependencies() {
    _typeAccount = Provider.of<UserModel>(context).typeAccount;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _typeAccount == null
        ? LoadingDataInProgressWidget(withScaffold: true)
        : _buildPageForTypeAccount(context);
  }

  Widget _buildPageForTypeAccount(BuildContext context) {
    switch (_typeAccount) {
      case UserType.CLIENT:
         return ClientWidget();
      case UserType.MANAGER:
        return ManagerWidget();
      case UserType.EMPLOYEE:
        return EmployeeWidget();
      default:
        return Container(child: Text('No data'));
    }
  }
}
