import 'package:flutter_course/models/auth.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:rxdart/subjects.dart';
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
  String _secretApiKey = '';

  bool get getLoading {
    return _isLoaing;
  }

  int get getTabIndex {
    notifyListeners();
    return _tabIndex;
  }

  String get apiKey {
    return _secretApiKey;
  }

  void setSecret(String value) {
    _secret = value;
  }

  void setSecretApiKey(String value) {
    _secretApiKey = value;
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
  Timer _authTimer;
  PublishSubject<bool> _subject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _subject;
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _subject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), () {
      logout();
    });
  }

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
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _subject.add(true);
      final now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', responseData['idToken']);
      pref.setString('userEmail', email);
      pref.setString('userId', responseData['localId']);
      pref.setString('expiryTime', expiryTime.toIso8601String());
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
    final String expiryTimeString = pref.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiredTime = DateTime.parse(expiryTimeString);
      if (parsedExpiredTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = pref.getString('userEmail');
      final String userId = pref.getString('userId');
      final int tokenlife = parsedExpiredTime.difference(now).inSeconds;
      setAuthTimeout(tokenlife);
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _subject.add(true);
      notifyListeners();
    }
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

  Future<Null> fetchProducts({onlyForUser = false}) {
    _isLoaing = true;
    notifyListeners();
    return http
        .get(
            "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products.json?auth=${_authenticatedUser.token}")
        .then((http.Response res) {
      _isLoaing = false;
      final List<Product> fetchedproductList = [];
      final Map<String, dynamic> productListResponse = json.decode(res.body);
      if (productListResponse != null && productListResponse.length >= 0) {
        productListResponse.forEach((id, productData) {
          final Product product = Product(
              id: id,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              image: productData['image'],
              userId: productData['userId'],
              userEmail: productData['userEmail'],
              isFavorite: productData['wishlistUsers'] != null
                  ? (productData['wishlistUsers'] as Map<String, dynamic>)
                      .containsKey(_authenticatedUser.id)
                  : false);
          fetchedproductList.add(product);
        });
        if (onlyForUser) {
          _products = fetchedproductList
              .where((element) => element.userId == _authenticatedUser.id)
              .toList();
        } else {
          _products = fetchedproductList;
        }
      }
      notifyListeners();
      _selProductId = null;
    });
  }

  void toogleProductFavoriteStatus() async {
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
    notifyListeners();
    http.Response res;
    if (newFavaoriteStatus) {
      res = await http.put(
          "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products/${selectedProductId}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}",
          body: json.encode(true));
    } else {
      res = await http.delete(
          "https://flutter-products-6ce3a-default-rtdb.firebaseio.com/products/${selectedProductId}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}");
    }
    if (res != null && res.statusCode != 200 && res.statusCode != 201) {
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
      notifyListeners();
    }

    _selProductId = null;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
