import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, int> _items = {};

  Map<String, int> get items => _items;

  void addItem(Map<String, dynamic> product) {
    final key = product['name'];
    if (_items.containsKey(key)) {
      _items[key] = _items[key]! + 1;
    } else {
      _items[key] = 1;
    }
    notifyListeners();
  }

  void removeItem(String productName) {
    if (_items.containsKey(productName)) {
      _items.remove(productName);
      notifyListeners();
    }
  }

  void updateQuantity(String productName, int quantity) {
    if (_items.containsKey(productName) && quantity > 0) {
      _items[productName] = quantity;
      notifyListeners();
    } else if (quantity <= 0) {
      removeItem(productName);
    }
  }

  int getQuantity(String productName) {
    return _items[productName] ?? 0;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
