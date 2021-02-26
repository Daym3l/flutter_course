import 'package:flutter/material.dart';
import 'package:flutter_course/pages/tab.page.editProduct.dart';
import 'package:flutter_course/pages/tab.page.productList.dart';
import 'package:flutter_course/widgets/iu_elements/widget.drawer.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [EditProductPage(), ProductListPage()],
        ),
      ),
    );
  }
}
