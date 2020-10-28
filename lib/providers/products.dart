import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> addProduct(Product newproduct) {
    const url = 'https://flutter-cod3r-4af01.firebaseio.com/products.json';
    return post(
      url,
      body: json.encode({
        'title': newproduct.title,
        'description': newproduct.description,
        'price': newproduct.price,
        'imageUrl': newproduct.imageUrl,
        'isFavorite': newproduct.isFavorite,
      }),
    ).then((response) {
      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: newproduct.title,
        description: newproduct.description,
        price: newproduct.price,
        imageUrl: newproduct.imageUrl,
      ));
      notifyListeners();
    });
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
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
