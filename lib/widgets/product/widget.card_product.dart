import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/iu_elements/widget.price.dart';
import 'package:flutter_course/widgets/iu_elements/widget.title.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  ProductCard(this.product, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      borderOnForeground: true,
      shadowColor: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  FadeInImage(
                      placeholder: AssetImage('assets/images/food.jpg'),
                      height: 300,
                      fit: BoxFit.cover,
                      image: NetworkImage(product.image)),
                  Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ScopedModelDescendant(builder:
                          (BuildContext context, Widget child,
                              MainModel model) {
                        Product _selectedProduct = model.allproducts[index];
                        return FloatingActionButton(
                            heroTag: product.id,
                            child: Icon(
                              _selectedProduct.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: _selectedProduct.isFavorite
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            backgroundColor: Color.fromARGB(180, 223, 227, 235),
                            onPressed: () {
                              model.selectProduct(product.id);
                              model.toogleProductFavoriteStatus();
                            });
                      }))
                ],
              ),
            ),
            ListTile(
                title: FormatTitle(product.title),
                subtitle: FormatPrice(product.price.toString()),
                trailing: ClipOval(
                  child: Material(
                      color: Theme.of(context).accentColor, // button color
                      child: ScopedModelDescendant(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.info_outlined,
                                  color: Colors.white,
                                )),
                            onTap: () {
                              model.selectProduct(product.id);
                              Navigator.pushNamed(context, '/product');
                            },
                          );
                        },
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
