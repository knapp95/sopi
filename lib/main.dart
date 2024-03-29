import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/home_page_wrapper.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/basket/basket_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/authentication/authentication_service.dart';
import 'package:sopi/ui/shared/styles/theme_data_style.dart';
import 'package:sopi/ui/widgets/authorization/authorization_widget.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

import 'models/products/products_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(),
        ),
        ChangeNotifierProvider<AssetModel>(
          create: (_) => AssetModel(),
        ),
        ChangeNotifierProvider<ProductsModel>(
          create: (_) => ProductsModel(),
        ),
        ChangeNotifierProvider<BasketModel>(
          create: (_) => BasketModel(),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: GetMaterialApp(
        navigatorKey: Get.addKey(GlobalKey()),
        theme: themeDataStyle,
        debugShowCheckedModeBanner: false,
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<AuthenticationService>().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingDataInProgressWidget(withScaffold: true);
          } else if (snapshot.hasData) {
            Provider.of<UserModel>(context).setTypeAccount();
            return const HomePageWrapper();
          } else {
            return const AuthorizationWidget();
          }
        });
  }
}
