import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_theme.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String? category;
  final VoidCallback onTap;
  final bool isNew;
  final double? discount;
  final int likes;
  final bool isLiked;
  final VoidCallback? onLike;
  final int comments;
  final VoidCallback? onComments;

  const ProductCard({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.category,
    required this.onTap,
    this.isNew = false,
    this.discount,
    this.likes = 0,
    this.isLiked = false,
    this.onLike,
    this.comments = 0,
    this.onComments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container avec badges
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusL),
                          topRight: Radius.circular(AppTheme.radiusL),
                        ),
                        color: AppTheme.darkGray,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusL),
                          topRight: Radius.circular(AppTheme.radiusL),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppTheme.darkGray,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.darkGray,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppTheme.mediumGray,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Badges
                    if (isNew || discount != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isNew)
                              _buildBadge('NEW', AppTheme.successGreen),
                            if (discount != null) ...[
                              if (isNew) const SizedBox(width: 4),
                              _buildBadge(
                                '-${discount!.toInt()}%',
                                AppTheme.errorRed,
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Product info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category
                      if (category != null)
                        Text(
                          category!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.w500,
                              ),
                        ),

                      // Product name
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // Price and Likes
                      Column(
                        children: [
                          // Price row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                price,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 16,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Likes and Comments row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Likes
                              InkWell(
                                onTap: onLike,
                                borderRadius: BorderRadius.circular(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 14,
                                      color: isLiked
                                          ? AppTheme.errorRed
                                          : AppTheme.mediumGray,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      likes.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.mediumGray,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Comments
                              InkWell(
                                onTap: onComments,
                                borderRadius: BorderRadius.circular(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.comment_outlined,
                                      size: 14,
                                      color: AppTheme.mediumGray,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      comments.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.mediumGray,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.pureWhite,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;
  final int productCount;

  const CategoryCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
    this.productCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.darkGray.withOpacity(0.8),
                AppTheme.primaryBlack.withOpacity(0.9),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                  placeholder: (context, url) => Container(
                    color: AppTheme.darkGray,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.accentGold,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppTheme.darkGray,
                    child: const Icon(
                      Icons.category,
                      color: AppTheme.mediumGray,
                      size: 32,
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    if (productCount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$productCount produits',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightGray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
