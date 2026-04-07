import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/custom_button.dart';
import '../helpers/responsive_helper.dart';
import '../helpers/product_like_manager.dart';
import '../helpers/comment_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _bannerController = PageController();
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _bannerController.hasClients) {
        if (_currentBanner < 2) {
          _currentBanner++;
        } else {
          _currentBanner = 0;
        }
        _bannerController.animateToPage(
          _currentBanner,
          duration: AppTheme.defaultAnimationDuration,
          curve: Curves.easeInOut,
        );
        _startBannerAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar avec design amélioré
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryBlack,
                    AppTheme.darkGray.withOpacity(0.95),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  child: Row(
                    children: [
                      // Logo/Brand
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          boxShadow: AppTheme.goldShadow,
                        ),
                        child: Text(
                          'EB',
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Actions
                      Row(
                        children: [
                          // Search
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusM,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => _showSearch(context),
                              icon: const Icon(
                                Icons.search_rounded,
                                color: AppTheme.accentGold,
                                size: 24,
                              ),
                            ),
                          ),

                          const SizedBox(width: AppTheme.spacingS),

                          // Cart
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusM,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => _showCart(context),
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: AppTheme.accentGold,
                                    size: 24,
                                  ),
                                ),
                              ),
                              // Badge pour le nombre d'articles
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorRed,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: AppTheme.pureWhite,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Carousel
                    _buildBannerCarousel(),

                    const SizedBox(height: AppTheme.spacingL),

                    // Categories Section
                    _buildSectionHeader('Catégories', onViewAll: () {}),
                    _buildCategoriesGrid(),

                    const SizedBox(height: AppTheme.spacingL),

                    // Popular Products Section
                    _buildSectionHeader(
                      'Produits Populaires',
                      onViewAll: () {},
                    ),
                    _buildPopularProducts(),

                    const SizedBox(height: AppTheme.spacingL),

                    // New Arrivals Section
                    _buildSectionHeader('Nouveautés', onViewAll: () {}),
                    _buildNewArrivals(),

                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Container(
      height: ResponsiveHelper.getCarouselHeight(context),
      margin: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: PageView.builder(
          controller: _bannerController,
          onPageChanged: (index) {
            setState(() {
              _currentBanner = index;
            });
          },
          itemCount: 3,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                // Banner Image
                CachedNetworkImage(
                  imageUrl: 'assets/img0${index + 1}.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: AppTheme.darkGray,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentGold.withOpacity(0.3),
                          AppTheme.darkGray,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Promotion ${index + 1}',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AppTheme.pureWhite,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),

                // Overlay Content
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index == 0
                              ? 'Collection Été'
                              : index == 1
                              ? 'Soldes -30%'
                              : 'Nouveaux Arrivages',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppTheme.pureWhite,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        CustomButton(
                          text: 'Voir maintenant',
                          onPressed: () {},
                          isOutlined: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'Voir tout',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: AppConstants.categories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: AppTheme.spacingM),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentGold.withOpacity(0.2),
                        AppTheme.darkGray,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(
                      color: AppTheme.accentGold.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: AppTheme.accentGold,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularProducts() {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          final productId = 'product_$index';
          final likeData = ProductLikeManager.getLikeData(productId);
          final comments = CommentManager.getComments(productId);

          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: AppTheme.spacingM),
            child: ProductCard(
              id: productId,
              name: 'Sneaker Premium ${index + 1}',
              price: '${(index + 1) * 150} MAD',
              imageUrl: 'assets/img0${(index % 4) + 1}.jpg',
              category: 'Sneakers',
              onTap: () => _navigateToProductDetail(context, productId),
              isNew: index < 2,
              discount: index == 1 ? 20 : null,
              likes: likeData.likes,
              isLiked: likeData.isLiked,
              onLike: () {
                setState(() {
                  ProductLikeManager.toggleLike(productId);
                });
              },
              comments: comments.length,
              onComments: () => _navigateToComments(context, productId),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewArrivals() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          final productId = 'new_product_$index';
          final likeData = ProductLikeManager.getLikeData(productId);
          final comments = CommentManager.getComments(productId);

          return ProductCard(
            id: productId,
            name: 'Nouveau Produit ${index + 1}',
            price: '${(index + 2) * 200} MAD',
            imageUrl: 'assets/img0${(index % 4) + 1}.jpg',
            category: 'Nouveautés',
            onTap: () => _navigateToProductDetail(context, productId),
            isNew: true,
            likes: likeData.likes,
            isLiked: likeData.isLiked,
            onLike: () {
              setState(() {
                ProductLikeManager.toggleLike(productId);
              });
            },
            comments: comments.length,
            onComments: () => _navigateToComments(context, productId),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Souliers':
        return Icons.work;
      case 'Sneakers':
        return Icons.directions_run;
      case 'Sandales':
        return Icons.beach_access;
      case 'Habits':
        return Icons.checkroom;
      case 'Sacs':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Home
        // Already on home
        break;
      case 1: // Catalog
        Navigator.pushNamed(context, AppConstants.catalogRoute);
        break;
      case 2: // Favorites
        _showFavorites(context);
        break;
      case 3: // Profile
        _showProfile(context);
        break;
    }
  }

  void _navigateToProductDetail(BuildContext context, String productId) {
    Navigator.pushNamed(
      context,
      AppConstants.productDetailRoute,
      arguments: productId,
    );
  }

  void _navigateToComments(BuildContext context, String productId) {
    Navigator.pushNamed(
      context,
      AppConstants.commentsRoute,
      arguments: productId,
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusL),
          topRight: Radius.circular(AppTheme.radiusL),
        ),
      ),
      builder: (context) => _buildMenuSheet(),
    );
  }

  Widget _buildMenuSheet() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.mediumGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          ListTile(
            leading: const Icon(
              Icons.admin_panel_settings,
              color: AppTheme.accentGold,
            ),
            title: const Text(
              'Admin',
              style: TextStyle(color: AppTheme.pureWhite),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.adminLoginRoute);
            },
          ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(context: context, delegate: ProductSearchDelegate());
  }

  void _showCart(BuildContext context) {
    // Navigation vers le panier
  }

  void _showFavorites(BuildContext context) {
    // Navigation vers les favoris
  }

  void _showProfile(BuildContext context) {
    // Navigation vers le profil
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: AppTheme.primaryBlack,
      child: Center(
        child: Text(
          'Résultats pour: $query',
          style: const TextStyle(color: AppTheme.pureWhite),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: AppTheme.primaryBlack,
      child: const Center(
        child: Text(
          'Rechercher des produits...',
          style: TextStyle(color: AppTheme.mediumGray),
        ),
      ),
    );
  }
}
