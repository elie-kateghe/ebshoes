import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;
              
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: AppTheme.defaultAnimationDuration,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppTheme.accentGold.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: isSelected 
                                ? AppTheme.accentGold 
                                : AppTheme.mediumGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: AppTheme.defaultAnimationDuration,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected 
                                ? AppTheme.accentGold 
                                : AppTheme.mediumGray,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.label,
  });
}

// Navigation prédéfinie pour l'application
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  static const List<BottomNavItem> publicItems = [
    BottomNavItem(icon: Icons.home_rounded, label: 'Accueil'),
    BottomNavItem(icon: Icons.category_rounded, label: 'Catalogue'),
    BottomNavItem(icon: Icons.favorite_border_rounded, label: 'Favoris'),
    BottomNavItem(icon: Icons.person_outline_rounded, label: 'Profil'),
  ];

  static const List<BottomNavItem> adminItems = [
    BottomNavItem(icon: Icons.dashboard_rounded, label: 'Tableau'),
    BottomNavItem(icon: Icons.inventory_2_rounded, label: 'Produits'),
    BottomNavItem(icon: Icons.comment_rounded, label: 'Commentaires'),
    BottomNavItem(icon: Icons.settings_rounded, label: 'Paramètres'),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
      items: publicItems, // Changez à adminItems pour la section admin
    );
  }
}
