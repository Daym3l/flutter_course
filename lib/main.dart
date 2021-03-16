import 'package:flutter/material.dart';
import 'package:flutter_course/pages/page.gmap.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/pages/page.auth.dart';
import 'package:flutter_course/pages/page.productsList.dart';
import 'pages/page.productDetails.dart';
import 'pages/page.productsAdmin.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.setSecret(FlutterConfig.get('FIREBASE_KEY'));
    _model.setSecretApiKey(FlutterConfig.get('API_KEY'));
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurpleAccent,
              buttonColor: Colors.deepPurpleAccent),
          routes: {
            '/': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : HomePage(_model),
            '/admin': (BuildContext context) => ProductsAdminPage(_model),
            '/product': (BuildContext context) => ProductPage(),
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => HomePage(_model));
          },
        ));
  }
}
