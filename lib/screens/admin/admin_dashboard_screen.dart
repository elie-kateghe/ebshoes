import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/bottom_navigation.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  // Statistiques simulées
  final Map<String, int> _stats = {
    'Produits': 156,
    'Commandes': 89,
    'Commentaires': 234,
    'Utilisateurs': 1247,
  };

  final List<SalesData> _salesData = [
    SalesData('Jan', 45000),
    SalesData('Fév', 52000),
    SalesData('Mar', 48000),
    SalesData('Avr', 61000),
    SalesData('Mai', 58000),
    SalesData('Jun', 67000),
  ];

  final List<ProductData> _topProducts = [
    ProductData('Sneaker Premium X', 45, 1250),
    ProductData('Basket Classic', 32, 950),
    ProductData('Running Pro', 28, 890),
    ProductData('Urban Style', 25, 750),
    ProductData('Casual Comfort', 22, 680),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: CustomAppBar(
        title: 'Tableau de Bord',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec date et actions
            _buildHeader(),

            const SizedBox(height: AppTheme.spacingL),

            // Statistiques principales
            _buildStatsGrid(),

            const SizedBox(height: AppTheme.spacingXL),

            // Graphique des ventes
            _buildSalesChart(),

            const SizedBox(height: AppTheme.spacingXL),

            // Produits populaires
            _buildTopProducts(),

            const SizedBox(height: AppTheme.spacingXL),

            // Actions rapides
            _buildQuickActions(),

            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, Admin!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              'Voici un aperçu de votre boutique',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: AppTheme.goldShadow,
          ),
          child: Text(
            'Exporter',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.primaryBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final entry = _stats.entries.elementAt(index);
        return _buildStatCard(entry.key, entry.value, _getStatIcon(entry.key));
      },
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.darkGray, AppTheme.primaryBlack],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Icon(icon, color: AppTheme.accentGold, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatIcon(String title) {
    switch (title) {
      case 'Produits':
        return Icons.inventory_2;
      case 'Commandes':
        return Icons.shopping_cart;
      case 'Commentaires':
        return Icons.comment;
      case 'Utilisateurs':
        return Icons.people;
      default:
        return Icons.analytics;
    }
  }

  Widget _buildSalesChart() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ventes des 6 derniers mois',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _salesData.asMap().entries.map((entry) {
                  final maxHeight = _salesData
                      .map((e) => e.sales)
                      .reduce((a, b) => a > b ? a : b);
                  final height = (entry.value.sales / maxHeight) * 150;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 30,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.accentGold, AppTheme.lightGold],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.value.month,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Produits les plus vendus',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _topProducts.length,
              itemBuilder: (context, index) {
                final product = _topProducts[index];
                return _buildProductItem(product, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductData product, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.darkGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? AppTheme.accentGold
                  : AppTheme.mediumGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: rank <= 3 ? AppTheme.primaryBlack : AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${product.sales} ventes',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '${product.price} MAD',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.accentGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: AppTheme.spacingM,
            mainAxisSpacing: AppTheme.spacingM,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildActionCard(
              _getActionTitle(index),
              _getActionIcon(index),
              _getActionRoute(index),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(AppTheme.radiusL),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.darkGray, AppTheme.primaryBlack],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.accentGold, size: 32),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getActionTitle(int index) {
    switch (index) {
      case 0:
        return 'Ajouter Produit';
      case 1:
        return 'Gérer Produits';
      case 2:
        return 'Commentaires';
      case 3:
        return 'Paramètres';
      default:
        return '';
    }
  }

  IconData _getActionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.add_circle;
      case 1:
        return Icons.inventory_2;
      case 2:
        return Icons.comment;
      case 3:
        return Icons.settings;
      default:
        return Icons.help;
    }
  }

  String _getActionRoute(int index) {
    switch (index) {
      case 0:
      case 1:
        return AppConstants.manageProductsRoute;
      case 2:
        return AppConstants.manageCommentsRoute;
      case 3:
        return '/settings';
      default:
        return '';
    }
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Dashboard
        // Already on dashboard
        break;
      case 1: // Products
        Navigator.pushNamed(context, AppConstants.manageProductsRoute);
        break;
      case 2: // Comments
        Navigator.pushNamed(context, AppConstants.manageCommentsRoute);
        break;
      case 3: // Settings
        // Navigate to settings
        break;
    }
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}

class ProductData {
  final String name;
  final int sales;
  final double price;

  ProductData(this.name, this.sales, this.price);
}
