import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/client/client_widget.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/employee/employee_widget.dart';
import 'package:sopi/ui/widgets/manager/manager_widget.dart';

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({Key? key}) : super(key: key);

  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  UserType? _typeAccount;

  @override
  void didChangeDependencies() {
    _typeAccount = Provider.of<UserModel>(context).typeAccount;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _typeAccount == null
        ? const LoadingDataInProgressWidget(withScaffold: true)
        : _buildPageForTypeAccount(context);
  }

  Widget _buildPageForTypeAccount(BuildContext context) {
    switch (_typeAccount) {
      case UserType.client:
        return const ClientWidget();
      case UserType.manager:
        return const ManagerWidget();
      case UserType.employee:
        return const EmployeeWidget();
      default:
        return const Text('No data');
    }
  }
}
