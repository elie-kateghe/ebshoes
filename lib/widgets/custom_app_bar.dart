import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double? elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.onBackPressed,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.pureWhite,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppTheme.primaryBlack,
      elevation: elevation ?? 0,
      leading:
          leading ??
          (automaticallyImplyLeading ? _buildLeading(context) : null),
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryBlack, AppTheme.darkGray.withOpacity(0.8)],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (onBackPressed != null) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: onBackPressed,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeAppBar extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;
  final int cartItemCount;

  const HomeAppBar({
    Key? key,
    this.onMenuTap,
    this.onSearchTap,
    this.onCartTap,
    this.cartItemCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.primaryBlack, AppTheme.darkGray.withOpacity(0.9)],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Menu button
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded),
              iconSize: 28,
            ),

            const Expanded(
              child: Text(
                'EBShoes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.pureWhite,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Search button
            IconButton(
              onPressed: onSearchTap,
              icon: const Icon(Icons.search_rounded),
              iconSize: 28,
            ),

            // Cart button with badge
            Stack(
              children: [
                IconButton(
                  onPressed: onCartTap,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  iconSize: 28,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartItemCount > 99 ? '99+' : '$cartItemCount',
                        style: const TextStyle(
                          color: AppTheme.primaryBlack,
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
      ),
    );
  }
}
