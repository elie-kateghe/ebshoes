import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart' as home;
import 'screens/catalog_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/comments_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/manage_products_screen.dart';
import 'screens/admin/manage_comments_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EBShoes',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/splash') {
          return MaterialPageRoute(builder: (context) => const SplashScreen());
        }
        if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => const home.HomeScreen(),
          );
        }
        if (settings.name == '/catalog') {
          return MaterialPageRoute(builder: (context) => const CatalogScreen());
        }
        if (settings.name == '/product-detail') {
          final productId = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(productId: productId ?? ''),
          );
        }
        if (settings.name == '/comments') {
          final productId = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => CommentsScreen(productId: productId ?? ''),
          );
        }
        if (settings.name == '/contact') {
          final args = settings.arguments as Map<String, String>?;
          return MaterialPageRoute(
            builder: (context) => ContactScreen(
              productId: args?['productId'] ?? '',
              productName: args?['productName'] ?? '',
            ),
          );
        }
        if (settings.name == '/admin-login') {
          return MaterialPageRoute(
            builder: (context) => const AdminLoginScreen(),
          );
        }
        if (settings.name == '/admin-dashboard') {
          return MaterialPageRoute(
            builder: (context) => const AdminDashboardScreen(),
          );
        }
        if (settings.name == '/manage-products') {
          return MaterialPageRoute(
            builder: (context) => const ManageProductsScreen(),
          );
        }
        if (settings.name == '/manage-comments') {
          return MaterialPageRoute(
            builder: (context) => const ManageCommentsScreen(),
          );
        }
        return null;
      },
    );
  }
}
