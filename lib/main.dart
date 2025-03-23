import 'package:flutter/material.dart';
import 'elementGroups.dart';
import 'serverDataControl.dart';
import 'addGroup.dart';
import 'productList.dart';
import 'addEditProduct.dart';
import 'authController.dart';
import 'authScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await ServerDataControl.initialize();

  // статус авторизации
  final isAuthenticated = await AuthController.isAuthenticated();
  final userId = await AuthController.getCurrentUserId();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isAuthenticated && userId != null
        ? elementGroups(currentUserId: userId)
        : const AuthScreen(),
    routes: {
      '/elementGroups': (BuildContext context) => const elementGroups(currentUserId: 0,),
      '/addGroup': (BuildContext context) => const addGroup(currentUserId: 0,),
      '/productList': (BuildContext context) => const ProductList(groupId: 0, groupName: '',),
      '/addEditProduct': (BuildContext context) => const AddEditProduct(groupId: 0,),
      '/authScreen': (BuildContext context) => const AuthScreen(),
    },
    onGenerateRoute: (routeSettings) {
      var path = routeSettings.name!.split('/');

      if (path[1] == "elementGroups") {
        return MaterialPageRoute(
          builder: (context) => const elementGroups(currentUserId: 0,),
          settings: routeSettings,
        );
      }

      if (path[1] == "addGroup") {
        return MaterialPageRoute(
          builder: (context) => const addGroup(currentUserId: 0),
          settings: routeSettings,
        );
      }

      if (path[1] == "productList") {
        return MaterialPageRoute(
          builder: (context) => const ProductList(groupId: 0, groupName: '',),
          settings: routeSettings,
        );
      }

      if (path[1] == "addEditProduct") {
        return MaterialPageRoute(
          builder: (context) => const AddEditProduct(groupId: 0),
          settings: routeSettings,
        );
      }

      if (path[1] == "authScreen") {
        return MaterialPageRoute(
          builder: (context) => const AuthScreen(),
          settings: routeSettings,
        );
      }
      return null;
    },
  ));
}

