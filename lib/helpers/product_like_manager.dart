import 'package:flutter/material.dart';

class ProductLikeManager {
  static final Map<String, ProductLikeData> _productsLikes = {};

  static ProductLikeData getLikeData(String productId) {
    return _productsLikes[productId] ?? 
        ProductLikeData(likes: _generateRandomLikes(), isLiked: false);
  }

  static void toggleLike(String productId) {
    final product = _productsLikes[productId];
    if (product != null) {
      if (product.isLiked) {
        _productsLikes[productId] = ProductLikeData(
          likes: product.likes - 1,
          isLiked: false,
        );
      } else {
        _productsLikes[productId] = ProductLikeData(
          likes: product.likes + 1,
          isLiked: true,
        );
      }
    } else {
      _productsLikes[productId] = ProductLikeData(
        likes: 1,
        isLiked: true,
      );
    }
  }

  static int _generateRandomLikes() {
    // Génère un nombre de likes aléatoire entre 5 et 150
    return 5 + (DateTime.now().millisecondsSinceEpoch % 146);
  }

  static Map<String, ProductLikeData> getAllLikes() {
    return Map.from(_productsLikes);
  }
}

class ProductLikeData {
  final int likes;
  final bool isLiked;

  ProductLikeData({
    required this.likes,
    required this.isLiked,
  });
}
