import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_button.dart';
import '../helpers/responsive_helper.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Tous';
  String _sortBy = 'Nom';
  double _priceRange = 5000;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.categories.length + 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche et filtres
            _buildHeader(),

            // Filtres avancés
            _buildFiltersSection(),

            // Tabs catégories
            _buildCategoryTabs(),

            // Products Grid/List
            Expanded(child: _buildProductsContent()),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.mediumGray.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // App Bar
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.pureWhite,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  'Catalogue',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _showSearchDialog,
                icon: const Icon(Icons.search, color: AppTheme.pureWhite),
              ),
              IconButton(
                onPressed: _showFilterDialog,
                icon: const Icon(Icons.tune, color: AppTheme.pureWhite),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryBlack,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher des produits...',
                hintStyle: TextStyle(
                  color: AppTheme.mediumGray.withOpacity(0.7),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.mediumGray,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
              ),
              style: const TextStyle(color: AppTheme.pureWhite),
              onChanged: (value) {
                // Implémenter la recherche
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          // Tri
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
              ),
              decoration: BoxDecoration(
                color: AppTheme.darkGray,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(color: AppTheme.mediumGray.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _sortBy,
                  items:
                      [
                        'Nom',
                        'Prix croissant',
                        'Prix décroissant',
                        'Nouveauté',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: AppTheme.pureWhite),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortBy = newValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.accentGold,
                  ),
                  isExpanded: true,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacingM),

          // Toggle Grid/List
          Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGray,
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => setState(() => _isGridView = true),
                  icon: Icon(
                    Icons.grid_view,
                    color: _isGridView
                        ? AppTheme.accentGold
                        : AppTheme.mediumGray,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _isGridView = false),
                  icon: Icon(
                    Icons.list,
                    color: !_isGridView
                        ? AppTheme.accentGold
                        : AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.categories.length + 1,
        itemBuilder: (context, index) {
          final category = index == 0
              ? 'Tous'
              : AppConstants.categories[index - 1];
          final isSelected = _selectedCategory == category;

          return Container(
            margin: const EdgeInsets.only(right: AppTheme.spacingM),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: AppTheme.darkGray,
              selectedColor: AppTheme.accentGold.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.accentGold : AppTheme.mediumGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.accentGold
                    : AppTheme.mediumGray.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsContent() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        childAspectRatio: ResponsiveHelper.getChildAspectRatio(context),
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
      ),
      itemCount: 20, // Nombre de produits
      itemBuilder: (context, index) {
        return ProductCard(
          id: 'catalog_product_$index',
          name: 'Produit Premium ${index + 1}',
          price: '${(index + 1) * 250} MAD',
          imageUrl: 'assets/img0${(index % 4) + 1}.jpg',
          category:
              AppConstants.categories[index % AppConstants.categories.length],
          onTap: () => _navigateToProductDetail('catalog_product_$index'),
          isNew: index < 3,
          discount: index % 3 == 0 ? 15 : null,
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          child: _buildProductListItem(index),
        );
      },
    );
  }

  Widget _buildProductListItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.softShadow,
      ),
      child: InkWell(
        onTap: () => _navigateToProductDetail('catalog_product_$index'),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  color: AppTheme.primaryBlack,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: CachedNetworkImage(
                    imageUrl: 'assets/img0${(index % 4) + 1}.jpg',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.primaryBlack,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.accentGold,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.primaryBlack,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppTheme.spacingM),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (index < 3)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: AppTheme.pureWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (index % 3 == 0) ...[
                          if (index < 3) const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorRed,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '-15%',
                              style: TextStyle(
                                color: AppTheme.pureWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    Text(
                      'Produit Premium ${index + 1}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.pureWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    Text(
                      AppConstants.categories[index %
                          AppConstants.categories.length],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentGold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(index + 1) * 250} MAD',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 20,
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetail(String productId) {
    Navigator.pushNamed(
      context,
      AppConstants.productDetailRoute,
      arguments: productId,
    );
  }

  void _showSearchDialog() {
    showSearch(context: context, delegate: ProductSearchDelegate());
  }

  void _showFilterDialog() {
    showDialog(context: context, builder: (context) => _buildFilterDialog());
  }

  Widget _buildFilterDialog() {
    return AlertDialog(
      backgroundColor: AppTheme.darkGray,
      title: Text(
        'Filtres avancés',
        style: TextStyle(color: AppTheme.pureWhite),
      ),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prix
              Text(
                'Prix maximum: ${_priceRange.toInt()} MAD',
                style: TextStyle(color: AppTheme.pureWhite),
              ),
              Slider(
                value: _priceRange,
                max: 5000,
                divisions: 10,
                activeColor: AppTheme.accentGold,
                inactiveColor: AppTheme.mediumGray.withOpacity(0.3),
                onChanged: (value) {
                  setDialogState(() {
                    _priceRange = value;
                  });
                },
              ),

              const SizedBox(height: AppTheme.spacingL),

              // Tailles
              Text(
                'Tailles disponibles',
                style: TextStyle(color: AppTheme.pureWhite),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Wrap(
                spacing: AppTheme.spacingS,
                runSpacing: AppTheme.spacingS,
                children: ['38', '39', '40', '41', '42', '43', '44', '45'].map((
                  size,
                ) {
                  return FilterChip(
                    label: Text(size),
                    selected: false,
                    onSelected: (selected) {},
                    backgroundColor: AppTheme.primaryBlack,
                    selectedColor: AppTheme.accentGold.withOpacity(0.2),
                    labelStyle: TextStyle(color: AppTheme.mediumGray),
                    side: BorderSide(
                      color: AppTheme.mediumGray.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler', style: TextStyle(color: AppTheme.mediumGray)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGold,
            foregroundColor: AppTheme.primaryBlack,
          ),
          child: Text('Appliquer'),
        ),
      ],
    );
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
