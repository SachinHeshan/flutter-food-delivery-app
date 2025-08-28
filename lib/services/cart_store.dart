import 'package:flutter/foundation.dart';

class CartItem {
  CartItem({required this.name, required this.price, required this.image, this.quantity = 1});
  final String name;
  final double price;
  final String image;
  int quantity;
}

class CartStore extends ChangeNotifier {
  final List<CartItem> _items = <CartItem>[];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem item) {
    final int index = _items.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String name) {
    _items.removeWhere((i) => i.name == name);
    notifyListeners();
  }

  void increment(String name) {
    final int idx = _items.indexWhere((i) => i.name == name);
    if (idx >= 0) {
      _items[idx].quantity += 1;
      notifyListeners();
    }
  }

  void decrement(String name) {
    final int idx = _items.indexWhere((i) => i.name == name);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity -= 1;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final CartStore cartStore = CartStore();
