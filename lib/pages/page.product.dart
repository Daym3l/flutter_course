import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/widget.dialog.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(imageUrl),
              Container(
                child: Text(title),
                padding: EdgeInsets.all(8.0),
              ),
              Container(
                child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text("DELETE"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyDialog();
                          });
                    }),
                padding: EdgeInsets.all(8.0),
              )
            ],
          ),
        ),
        onWillPop: () {
          print("saliendo");
          Navigator.pop(context, false);
          return Future.value(false);
        });
  }
}
