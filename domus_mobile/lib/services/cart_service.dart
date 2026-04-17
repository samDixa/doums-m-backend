import 'package:flutter/material.dart';

class CartService {
  // Singleton pattern
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // ValueNotifier for the cart count
  final ValueNotifier<int> cartCount = ValueNotifier<int>(0);

  void addToCart() {
    cartCount.value++;
  }

  void resetCart() {
    cartCount.value = 0;
  }
}
