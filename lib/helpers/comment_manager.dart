class CommentManager {
  static final Map<String, List<ProductComment>> _productComments = {};

  static List<ProductComment> getComments(String productId) {
    return _productComments[productId] ?? _generateMockComments(productId);
  }

  static void addComment(String productId, ProductComment comment) {
    if (_productComments[productId] == null) {
      _productComments[productId] = [];
    }
    _productComments[productId]!.insert(0, comment);
  }

  static void updateComment(
    String productId,
    String commentId,
    ProductComment updatedComment,
  ) {
    final comments = _productComments[productId];
    if (comments != null) {
      final index = comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        comments[index] = updatedComment;
      }
    }
  }

  static void deleteComment(String productId, String commentId) {
    final comments = _productComments[productId];
    if (comments != null) {
      comments.removeWhere((c) => c.id == commentId);
    }
  }

  static void likeComment(String productId, String commentId) {
    final comments = _productComments[productId];
    if (comments != null) {
      final comment = comments.firstWhere((c) => c.id == commentId);
      if (comment.isLiked) {
        comment.likes--;
        comment.isLiked = false;
      } else {
        comment.likes++;
        comment.isLiked = true;
      }
    }
  }

  static double getAverageRating(String productId) {
    final comments = getComments(productId);
    if (comments.isEmpty) return 0.0;

    final totalRating = comments.fold<double>(
      0,
      (sum, comment) => sum + comment.rating,
    );
    return totalRating / comments.length;
  }

  static Map<int, int> getRatingDistribution(String productId) {
    final comments = getComments(productId);
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (final comment in comments) {
      final rating = comment.rating.round();
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }

    return distribution;
  }

  static List<ProductComment> _generateMockComments(String productId) {
    final comments = <ProductComment>[];
    final names = [
      'Karim Alaoui',
      'Fatima Zahra',
      'Youssef Ben',
      'Amina El',
      'Omar Tazi',
    ];
    final contents = [
      'Excellent produit! Très confortable et de bonne qualité.',
      'Beau design mais la taille est un peu petite.',
      'Produit conforme à la description. Livraison rapide.',
      'Bon rapport qualité-prix. Recommande vivement.',
      'Superbe qualité, exactement comme sur les photos.',
    ];

    for (int i = 0; i < 5; i++) {
      comments.add(
        ProductComment(
          id: '${productId}_comment_$i',
          userName: names[i % names.length],
          userAvatar: names[i % names.length][0],
          content: contents[i % contents.length],
          rating: 3.0 + (i % 3),
          date: DateTime.now().subtract(Duration(days: i * 2)),
          likes: 5 + (i * 12),
          isLiked: i % 2 == 0,
        ),
      );
    }

    _productComments[productId] = comments;
    return comments;
  }
}

class ProductComment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final double rating;
  final DateTime date;
  final List<String> images;
  int likes;
  bool isLiked;

  ProductComment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.rating,
    required this.date,
    this.images = const [],
    this.likes = 0,
    this.isLiked = false,
  });
}
