import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/pages/page.auth.dart';
import 'package:flutter_course/pages/page.productsList.dart';
import 'pages/page.productDetails.dart';
import 'pages/page.productsAdmin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: MainModel(),
        child: MaterialApp(
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurpleAccent,
              buttonColor: Colors.deepPurpleAccent),
          routes: {
            '/': (BuildContext context) => AuthPage(),
            '/home': (BuildContext context) => HomePage(),
            '/admin': (BuildContext context) => ProductsAdminPage(),
          },
          onGenerateRoute: (RouteSettings routeSettings) {
            final List<String> pathElements = routeSettings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute(
                builder: (BuildContext context) => ProductPage(index),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => HomePage());
          },
        ));
  }
}
