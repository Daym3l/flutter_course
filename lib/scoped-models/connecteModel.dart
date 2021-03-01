import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;

  void addProducts(
      String title, String description, String image, double price) {
    final Product _newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email);
    _products.add(_newProduct);
    notifyListeners();
  }
}

class UserModel extends ConnectedModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'qwe', email: email, password: password);
  }
}

class ProductsModel extends ConnectedModel {
  bool _showFavorite = false;

  List<Product> get allproducts {
    return List.from(_products);
  }

  List<Product> get displayProducts {
    if (_showFavorite) {
      return _products.where((Product p) => p.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  bool get displayFavoriteOnly {
    return _showFavorite;
  }

  Product get selectedProduct {
    if (selectedProductIndex != null) {
      return _products[selectedProductIndex];
    }
    return null;
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product _newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userId: selectedProduct.userId,
        userEmail: selectedProduct.userEmail);
    _products[selectedProductIndex] = _newProduct;

    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void toogleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavaoriteStatus = !isCurrentlyFavorite;
    final Product newProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email,
        isFavorite: newFavaoriteStatus);
    _products[selectedProductIndex] = newProduct;
    _selProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
