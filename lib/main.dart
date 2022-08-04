import 'package:flutter/material.dart';
import 'package:planningpoker/view/app/navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouteParser _routeInformationParser = AppRouteParser();
  final AppRouterDelegate _routerDelegate = AppRouterDelegate();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Planning poker',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routeInformationParser: _routeInformationParser,
        routerDelegate: _routerDelegate);
  }
}
