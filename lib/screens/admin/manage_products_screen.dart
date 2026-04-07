import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final int stock;
  bool isActive;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.stock,
    this.isActive = true,
    required this.createdAt,
  });
}

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _selectedCategory = 'Toutes';

  final List<String> _categories = [
    'Toutes',
    'Souliers',
    'Sneakers',
    'Sandales',
    'Habits',
    'Sacs',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler le chargement des produits
    await Future.delayed(const Duration(seconds: 1));

    final mockProducts = [
      Product(
        id: '1',
        name: 'Sneaker Premium X',
        category: 'Sneakers',
        price: 1250.0,
        description: 'Sneaker de haute qualité avec design moderne',
        imageUrl: 'assets/img01.jpg',
        stock: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Product(
        id: '2',
        name: 'Basket Classic',
        category: 'Souliers',
        price: 950.0,
        description: 'Basket classique pour tous les jours',
        imageUrl: 'assets/img02.jpg',
        stock: 32,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Product(
        id: '3',
        name: 'Running Pro',
        category: 'Sneakers',
        price: 890.0,
        description: 'Chaussures de running professionnelles',
        imageUrl: 'assets/img03.jpg',
        stock: 28,
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Product(
        id: '4',
        name: 'Urban Style',
        category: 'Sneakers',
        price: 750.0,
        description: 'Style urbain pour la ville',
        imageUrl: 'assets/img04.jpg',
        stock: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];

    setState(() {
      _products = mockProducts;
      _filteredProducts = mockProducts;
      _isLoading = false;
    });
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    final category = _selectedCategory;

    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesQuery =
            product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
        final matchesCategory =
            category == 'Toutes' || product.category == category;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: CustomAppBar(
        title: 'Gestion des Produits',
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _showAddProductDialog,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Ajouter un produit',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppTheme.pureWhite),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un produit...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.accentGold,
                    ),
                    filled: true,
                    fillColor: AppTheme.darkGray,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Category filter
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;

                      return Container(
                        margin: const EdgeInsets.only(right: AppTheme.spacingS),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                            _filterProducts();
                          },
                          backgroundColor: AppTheme.darkGray,
                          selectedColor: AppTheme.accentGold,
                          checkmarkColor: AppTheme.primaryBlack,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.pureWhite,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Products list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentGold,
                    ),
                  )
                : _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppTheme.mediumGray,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          'Aucun produit trouvé',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingL,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductCard(product);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.darkGray,
                    child: const Icon(Icons.image, color: AppTheme.mediumGray),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.darkGray,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppTheme.spacingM),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: product.isActive
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.isActive ? 'Actif' : 'Inactif',
                            style: const TextStyle(
                              color: AppTheme.pureWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    Text(
                      product.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentGold,
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toInt()} MAD',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Stock: ${product.stock}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: product.stock > 20
                                    ? AppTheme.successGreen
                                    : AppTheme.warningOrange,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.mediumGray),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _editProduct(product);
                      break;
                    case 'duplicate':
                      _duplicateProduct(product);
                      break;
                    case 'toggle':
                      _toggleProductStatus(product);
                      break;
                    case 'delete':
                      _deleteProduct(product);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppTheme.accentGold),
                        const SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: AppTheme.accentGold),
                        const SizedBox(width: 8),
                        Text('Dupliquer'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          product.isActive
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.accentGold,
                        ),
                        const SizedBox(width: 8),
                        Text(product.isActive ? 'Désactiver' : 'Activer'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppTheme.errorRed),
                        const SizedBox(width: 8),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text('Prix: ${product.price.toInt()} MAD'),
              Text('Catégorie: ${product.category}'),
              Text('Stock: ${product.stock}'),
              Text('Statut: ${product.isActive ? 'Actif' : 'Inactif'}'),
              const SizedBox(height: AppTheme.spacingM),
              Text(product.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un produit'),
        content: const Text('Formulaire d\'ajout de produit à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Produit ajouté avec succès');
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _editProduct(Product product) {
    _showSuccessSnackBar('Modification du produit: ${product.name}');
  }

  void _duplicateProduct(Product product) {
    _showSuccessSnackBar('Duplication du produit: ${product.name}');
  }

  void _toggleProductStatus(Product product) {
    setState(() {
      product.isActive = !product.isActive;
    });
    _showSuccessSnackBar('Statut du produit modifié');
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
                _filteredProducts.removeWhere((p) => p.id == product.id);
              });
              _showSuccessSnackBar('Produit supprimé avec succès');
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );
  }
}
