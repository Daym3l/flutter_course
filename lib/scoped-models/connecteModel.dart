import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

final String url =
    "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products.json";

class ConnectedModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;
  bool _isLoaing = false;

  bool get getLoading {
    return _isLoaing;
  }

  Future<Null> addProducts(
      String title, String description, String image, double price) {
    _isLoaing = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': 'assets/images/food.jpg',
      'price': price,
      'userId': _authenticatedUser.id,
      'userEmail': _authenticatedUser.email,
    };
    return http
        .post(url, body: json.encode(productData))
        .then((http.Response res) {
      _isLoaing = false;
      final Map<String, dynamic> responseData = json.decode(res.body);
      final Product _newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email);
      _products.add(_newProduct);
      notifyListeners();
    });
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

  Future<Null> updateProduct(
      String title, String description, String image, double price) {
    _isLoaing = true;
    notifyListeners();
    final Map<String, dynamic> updatedProduct = {
      'title': title,
      'description': description,
      'image': 'assets/images/food.jpg',
      'price': price,
      'userId': selectedProduct.userId,
      'userEmail': selectedProduct.userEmail,
    };
    return http
        .put(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json",
            body: json.encode(updatedProduct))
        .then((res) {
      _isLoaing = false;
      final Product _newProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userId: selectedProduct.userId,
          userEmail: selectedProduct.userEmail);
      _products[selectedProductIndex] = _newProduct;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _isLoaing = true;
    final deleletedId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductIndex = null;
    notifyListeners();
    http
        .delete(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products/${deleletedId}.json")
        .then((res) {
      _isLoaing = false;

      notifyListeners();
    });
  }

  void fetchProducts() {
    _isLoaing = true;
    notifyListeners();
    http.get(url).then((http.Response res) {
      _isLoaing = false;
      final List<Product> fetchedproductList = [];
      final Map<String, dynamic> productListResponse = json.decode(res.body);
      if (productListResponse.length >= 0) {
        productListResponse.forEach((id, productData) {
          final Product product = Product(
              id: id,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              image: productData['image'],
              userId: productData['userId'],
              userEmail: productData['userEmail']);
          fetchedproductList.add(product);
        });
        _products = fetchedproductList;
      }
      notifyListeners();
    });
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
