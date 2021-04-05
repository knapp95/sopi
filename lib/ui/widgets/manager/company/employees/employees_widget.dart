import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/users/user_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class EmployeesWidget extends StatefulWidget {
  @override
  _EmployeesWidgetState createState() => _EmployeesWidgetState();
}

class _EmployeesWidgetState extends State<EmployeesWidget> {
  final _userService = UserService.singleton;
  List<UserModel> _users;
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });

      _userService.fetchAllEmployees().then((value) {
        if (mounted) {
          _users = value;
          setState(() {
            _isLoading = false;
          });
        }
      });
      _isInit = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (_, int index) {
                    UserModel user = _users[index];
                    return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.solidStar,
                                          color: Colors.yellow,
                                        ),
                                        Text('4.43 / 5')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          margin:
                                              EdgeInsets.only(right: 8, top: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text('Offline'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/no_photo.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ],
          );
  }
}
