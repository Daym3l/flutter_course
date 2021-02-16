import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  final Function addProduct;

  CreateProductPage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<CreateProductPage> {
  String _titleValue;
  String _descriptionValue;
  double _priceValue;

  _saveProduct() {
    final Map<String, dynamic> product = {
      'title': _titleValue,
      'description': _descriptionValue,
      'price': _priceValue,
      'image': 'assets/images/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double deiceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deiceWidth > 550.0 ? 500.0 : deiceWidth * 0.95;
    final double targetPadding = deiceWidth - targetWidth;
    return Container(
      width: targetWidth,
      margin: EdgeInsets.all(8.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Product Title',
            ),
            onChanged: (String value) {
              setState(() {
                _titleValue = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Product Price',
            ),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() {
                _priceValue = double.parse(value);
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Product Description',
            ),
            maxLines: 3,
            onChanged: (String value) {
              setState(() {
                _descriptionValue = value;
              });
            },
          ),
          SizedBox(
            height: 8.0,
          ),
          RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              onPressed: _saveProduct)
        ],
      ),
    );
  }
}
