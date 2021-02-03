import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/widget.drawer.dart';
import '../product_manager.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  HomePage(this.products);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('EasyList'),
      ),
      body: ProductManager(products),
    );
  }
}
