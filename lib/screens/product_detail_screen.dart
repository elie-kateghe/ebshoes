import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late PageController _imageController;
  late AnimationController _favoriteController;
  late AnimationController _cartController;
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  int _selectedSize = 0;
  int _quantity = 1;
  bool _isAddingToCart = false;

  final List<String> _productImages = [
    'assets/img01.jpg',
    'assets/img02.jpg',
    'assets/img03.jpg',
    'assets/img04.jpg',
  ];

  final List<String> _sizes = ['39', '40', '41', '42', '43', '44', '45'];

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
    _favoriteController = AnimationController(
      duration: AppTheme.fastAnimationDuration,
      vsync: this,
    );
    _cartController = AnimationController(
      duration: AppTheme.defaultAnimationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _imageController.dispose();
    _favoriteController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with Image Background
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryBlack,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: AnimatedBuilder(
                    animation: _favoriteController,
                    builder: (context, child) {
                      return Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? AppTheme.errorRed
                            : AppTheme.pureWhite,
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: IconButton(
                  onPressed: _shareProduct,
                  icon: const Icon(Icons.share),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image Carousel
                  PageView.builder(
                    controller: _imageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: _productImages.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: _productImages[index],
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
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),

                  // Image Indicators
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _productImages.asMap().entries.map((entry) {
                        return AnimatedContainer(
                          duration: AppTheme.fastAnimationDuration,
                          width: _currentImageIndex == entry.key ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentImageIndex == entry.key
                                ? AppTheme.accentGold
                                : AppTheme.mediumGray.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sneaker Premium ${widget.productId}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: AppTheme.pureWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Row(
                              children: [
                                Text(
                                  '1,250 MAD',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppTheme.accentGold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Text(
                                  '1,500 MAD',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: AppTheme.mediumGray,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                                const SizedBox(width: AppTheme.spacingS),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorRed,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-20%',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppTheme.pureWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Rating and Reviews
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            color: AppTheme.accentGold,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        '4.0 (124 avis)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _navigateToComments(),
                        child: Text(
                          'Voir tous',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.accentGold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Size Selection
                  Text(
                    'Pointure',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sizes.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedSize == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSize = index;
                            });
                          },
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.only(
                              right: AppTheme.spacingS,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accentGold
                                  : AppTheme.darkGray,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusM,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.accentGold
                                    : AppTheme.mediumGray.withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _sizes[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? AppTheme.primaryBlack
                                      : AppTheme.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Quantity Selection
                  Text(
                    'Quantité',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.darkGray,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? _decreaseQuantity
                                  : null,
                              icon: const Icon(Icons.remove),
                              iconSize: 20,
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '$_quantity',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppTheme.pureWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            IconButton(
                              onPressed: _increaseQuantity,
                              icon: const Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Total: ${(1250 * _quantity).toStringAsFixed(0)} MAD',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    'Découvrez notre nouvelle collection de sneakers premium. Conçus avec des matériaux de haute qualité, alliant confort et style pour une expérience exceptionnelle. Parfait pour toutes vos occasions quotidiennes.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGray,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: _isAddingToCart
                              ? 'Ajout...'
                              : 'Ajouter au panier',
                          onPressed: _isAddingToCart
                              ? null
                              : () => _addToCart(),
                          icon: Icons.shopping_bag_outlined,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: WhatsAppButton(
                          message: AppConstants.whatsappOrderMessage,
                          phoneNumber: AppConstants.whatsappContact,
                          text: 'Commander',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      _favoriteController.forward();
    } else {
      _favoriteController.reverse();
    }
  }

  void _shareProduct() {
    // Implémenter le partage
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    // Simuler l'ajout au panier
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isAddingToCart = false;
    });

    _cartController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Produit ajouté au panier!'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    _cartController.reverse();
  }

  void _navigateToComments() {
    Navigator.pushNamed(
      context,
      AppConstants.commentsRoute,
      arguments: widget.productId,
    );
  }
}
