import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/product/widget.product.dart';
import 'package:flutter_course/widgets/iu_elements/widget.drawer.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  HomePage(this.products);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: Products(products),
    );
  }
}
