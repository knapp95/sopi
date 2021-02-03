import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/providers/Auth.dart';
import 'package:sopi/screens/add_item.dart';
import 'package:sopi/screens/authorization/authorization_screen.dart';
import 'package:sopi/screens/client_screen.dart';
import 'package:sopi/widgets/dialogs/loading_data_in_progress.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            primaryColor: Colors.lightGreen,
            accentColor: Color.fromRGBO(255, 241, 169, 1),
          ),
          home: auth.isAuth
              ? ClientScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingDataInProgress()
                          : AuthorizationScreen(),
                ),
          routes: {
            AddItem.routeName: (ctx) => AddItem(),
          },
        ),
      ),
    );
  }
}
