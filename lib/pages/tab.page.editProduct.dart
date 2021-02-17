import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;

  EditProductPage({this.addProduct, this.updateProduct, this.product});

  @override
  State<StatefulWidget> createState() {
    return _EditProductPageState();
  }
}

class _EditProductPageState extends State<EditProductPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/images/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _saveProduct() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      widget.addProduct(_formData);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deiceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deiceWidth > 550.0 ? 500.0 : deiceWidth * 0.95;
    final double targetPadding = deiceWidth - targetWidth;
    return Container(
      width: targetWidth,
      margin: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Title',
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Title is required';
                }
              },
              onSaved: (String value) {
                _formData['title'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Price',
              ),
              keyboardType: TextInputType.number,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Price is required';
                }
              },
              onSaved: (String value) {
                _formData['price'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Description',
              ),
              maxLines: 3,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Description is required';
                }
              },
              onSaved: (String value) {
                _formData['description'] = value;
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
      ),
    );
  }
}
