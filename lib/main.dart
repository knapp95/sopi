import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/services/auth_service.dart';
import 'package:sopi/screens/add_item.dart';
import 'package:sopi/screens/authorization/authorization_screen.dart';
import 'package:sopi/screens/client_screen.dart';
import 'package:sopi/widgets/dialogs/loading_data_in_progress.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

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
          home: FutureBuilder(
            future: _fbApp,
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? LoadingDataInProgress()
                    : auth.isAuth
                        ? ClientScreen()
                        : FutureBuilder(
                            future: auth.tryAutoLogin(),
                            builder: (ctx, authResultSnapshot) =>
                                authResultSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? LoadingDataInProgress()
                                    : AuthorizationScreen(),
                          ),
          ),
          routes: {
            AddItem.routeName: (ctx) => AddItem(),
          },
        ),
      ),
    );
  }
}
