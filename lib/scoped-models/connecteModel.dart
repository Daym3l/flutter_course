import 'package:flutter_course/models/auth.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConnectedModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoaing = false;
  int _tabIndex = 0;
  String _secret = '';

  bool get getLoading {
    return _isLoaing;
  }

  int get getTabIndex {
    notifyListeners();
    return _tabIndex;
  }

  void setSecret(String value) {
    _secret = value;
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  Future<bool> addProducts(
      String title, String description, String image, double price) {
    _isLoaing = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          "https://superinteresante.files.wordpress.com/2008/02/chocolate.jpg",
      'price': price,
      'userId': _authenticatedUser.id,
      'userEmail': _authenticatedUser.email,
    };
    return http
        .post(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products.json?auth=${_authenticatedUser.token}",
            body: json.encode(productData))
        .then((http.Response res) {
      _isLoaing = false;
      if (res.statusCode != 200 && res.statusCode != 201) {
        return false;
      }

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
      return true;
    }).catchError((e) {
      _isLoaing = false;
      notifyListeners();
      return false;
    });
  }
}

class UserModel extends ConnectedModel {
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoaing = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${_secret}',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${_secret}',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }

    _isLoaing = false;
    notifyListeners();

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: responseData['email'],
          token: responseData['idToken']);

      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', responseData['idToken']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message =
          'There is no user record for this identifier. The user may have been removed.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid or the user does not have a password.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exist.';
    }
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token');
    if (token != null) {}
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

  String get selectedProductId {
    return _selProductId;
  }

  int get selectedProducIndex {
    return _products.indexWhere((Product p) => p.id == selectedProductId);
  }

  bool get displayFavoriteOnly {
    return _showFavorite;
  }

  Product get selectedProduct {
    if (selectedProductId != null) {
      return _products.firstWhere((Product p) => p.id == selectedProductId);
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
      'image':
          "https://superinteresante.files.wordpress.com/2008/02/chocolate.jpg",
      'price': price,
      'userId': selectedProduct.userId,
      'userEmail': selectedProduct.userEmail,
    };
    return http
        .put(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}",
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

      _products[selectedProducIndex] = _newProduct;
      notifyListeners();
    }).catchError((e) {
      _isLoaing = false;
      notifyListeners();
      return false;
    });
  }

  void deleteProduct() {
    _isLoaing = true;
    _products.removeAt(selectedProducIndex);
    notifyListeners();
    http
        .delete(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products/${selectedProductId}.json?auth=${_authenticatedUser.token}")
        .then((res) {
      _isLoaing = false;
      _selProductId = null;
      notifyListeners();
    }).catchError((e) {
      _isLoaing = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoaing = true;
    notifyListeners();
    return http
        .get(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products.json?auth=${_authenticatedUser.token}")
        .then((http.Response res) {
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
      _selProductId = null;
    });
  }

  void toogleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavaoriteStatus = !isCurrentlyFavorite;
    final Product newProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userId: selectedProduct.userId,
        userEmail: selectedProduct.userEmail,
        isFavorite: newFavaoriteStatus);

    _products[selectedProducIndex] = newProduct;
    _selProductId = null;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProductId = productId;
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
