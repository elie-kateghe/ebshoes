class AppConstants {
  // Informations de l'application
  static const String appName = 'EBShoes';
  static const String appVersion = '1.0.0';
  
  // Messages et textes
  static const String welcomeMessage = 'Bienvenue chez EBShoes';
  static const String tagline = 'Style Premium, Qualité Exceptionnelle';
  
  // Catégories de produits
  static const List<String> categories = [
    'Souliers',
    'Sneakers', 
    'Sandales',
    'Habits',
    'Sacs',
  ];
  
  // Messages WhatsApp
  static const String whatsappOrderMessage = 'Bonjour, je veux commander ce produit';
  static const String whatsappContact = '+212600000000'; // À remplacer par le vrai numéro
  
  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  
  // URLs et endpoints (placeholder pour le futur backend)
  static const String baseUrl = 'https://api.ebshoes.com';
  static const String productsEndpoint = '$baseUrl/products';
  static const String commentsEndpoint = '$baseUrl/comments';
  
  // Limites et contraintes
  static const int maxCommentLength = 500;
  static const int maxProductNameLength = 100;
  static const double maxImageSizeMB = 5.0;
  
  // Clés de stockage local
  static const String userTokenKey = 'user_token';
  static const String adminTokenKey = 'admin_token';
  static const String themeKey = 'theme_preference';
  static const String languageKey = 'language_preference';
  
  // Routes de navigation
  static const String splashRoute = '/splash';
  static const String homeRoute = '/home';
  static const String catalogRoute = '/catalog';
  static const String productDetailRoute = '/product-detail';
  static const String commentsRoute = '/comments';
  static const String contactRoute = '/contact';
  static const String adminLoginRoute = '/admin-login';
  static const String adminDashboardRoute = '/admin-dashboard';
  static const String manageProductsRoute = '/manage-products';
  static const String manageCommentsRoute = '/manage-comments';
}
