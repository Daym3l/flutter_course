import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/map');
            },
          ),
          Divider(),
          ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
            return ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                model.logout();
              },
            );
          })
        ],
      ),
    );
  }
}
