import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/pages/page.gmap.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/iu_elements/widget.spiner.dart';
import 'package:scoped_model/scoped_model.dart';

class EditProductPage extends StatefulWidget {
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

  _saveProduct(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [String selectedId]) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (selectedId == null) {
        addProduct(
          _formData['title'],
          _formData['description'],
          _formData['image'],
          _formData['price'],
        ).then((bool success) {
          if (success) {
            Navigator.pushReplacementNamed(context, '/')
                .then((_) => setSelectedProduct(null));
          } else {
            return AlertDialog();
          }
        });
      } else {
        updateProduct(
          _formData['title'],
          _formData['description'],
          _formData['image'],
          _formData['price'],
        ).then((_) => Navigator.pushReplacementNamed(context, '/')
            .then((_) => setSelectedProduct(null)));
      }
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.getLoading
          ? Spiner("Saving Data...")
          : RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              onPressed: () => _saveProduct(
                  model.addProducts,
                  model.updateProduct,
                  model.selectProduct,
                  model.selectedProductId),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deiceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deiceWidth > 550.0 ? 500.0 : deiceWidth * 0.95;
    final double targetPadding = deiceWidth - targetWidth;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: targetWidth,
      margin: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Title',
              ),
              initialValue: product == null ? "" : product.title,
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
              initialValue: product == null ? "" : product.price.toString(),
              keyboardType: TextInputType.number,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Price is required';
                }
              },
              onSaved: (String value) {
                _formData['price'] = double.parse(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Description',
              ),
              initialValue: product == null ? "" : product.description,
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
            Center(
              child: Padding(
                child: Text('Product Location'),
                padding: EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
            Gmap(),
            SizedBox(
              height: 8.0,
            ),
            _buildSubmitButton()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
      return model.selectedProducIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Product'),
              ),
              body: pageContent,
            );
    });
  }
}
