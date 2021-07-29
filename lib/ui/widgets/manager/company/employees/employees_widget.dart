import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/users/user_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class EmployeesWidget extends StatefulWidget {
  const EmployeesWidget({Key? key}) : super(key: key);

  @override
  _EmployeesWidgetState createState() => _EmployeesWidgetState();
}

class _EmployeesWidgetState extends State<EmployeesWidget> {
  final _userService = UserService.singleton;
  late List<UserModel> _users;
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
        ? const LoadingDataInProgressWidget()
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (_, int index) {
                    final UserModel user = _users[index];
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  user.username!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
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
                                      margin: const EdgeInsets.only(
                                          right: 8, top: 8),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const Text('Offline'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/no_photo.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              border: Border.all(color: primaryColor),
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
