import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exeptions/http_exeption.dart';
import 'product.dart';
import '../utils/constants.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/products';
  //List<Product> _items = DUMMY_PRODUCTS;
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);
    final favResponse = await http.get(
        '${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token');
    final favMap = json.decode(favResponse.body);

    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newproduct) async {
    final response = await http.post(
      '$_baseUrl.json?auth=$_token',
      body: json.encode({
        'title': newproduct.title,
        'description': newproduct.description,
        'price': newproduct.price,
        'imageUrl': newproduct.imageUrl,
      }),
    );
    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newproduct.title,
      description: newproduct.description,
      price: newproduct.price,
      imageUrl: newproduct.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        '$_baseUrl/${product.id}.json?auth=$_token',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete('$_baseUrl/${product.id}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExeption('Ocorreu um erro na exclusão do Produto.');
      }
    }
  }
}

// bool _showFavoriteOnly = false;
// void showFavoriteOnly() {
//   _showFavoriteOnly = true;
//   notifyListeners();
// }

// void showAll() {
//   _showFavoriteOnly = false;
//   notifyListeners();
// }
