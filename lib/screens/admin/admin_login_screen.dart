import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_button.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _logoController;
  late AnimationController _formController;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _formAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: AppTheme.slowAnimationDuration,
      vsync: this,
    );

    _formController = AnimationController(
      duration: AppTheme.defaultAnimationDuration,
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _formAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
        );
  }

  void _startAnimations() async {
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _formController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _logoController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlack,
              AppTheme.darkGray,
              AppTheme.primaryBlack,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXL),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingXL),

                  // Logo with animation
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.accentGold, AppTheme.lightGold],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentGold.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            size: 60,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Title
                  Text(
                    'Admin EBShoes',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingS),

                  Text(
                    'Connectez-vous pour gérer votre boutique',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.mediumGray),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppTheme.spacingXXL),

                  // Login Form
                  SlideTransition(
                    position: _formAnimation,
                    child: Card(
                      elevation: 20,
                      shadowColor: Colors.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingXL),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusXXL,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.darkGray.withOpacity(0.9),
                              AppTheme.primaryBlack.withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email Field
                            Text(
                              'Email Administrateur',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppTheme.accentGold,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: AppTheme.pureWhite),
                              decoration: InputDecoration(
                                hintText: 'admin@ebshoes.com',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: AppTheme.accentGold,
                                ),
                                filled: true,
                                fillColor: AppTheme.primaryBlack.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: AppTheme.spacingL),

                            // Password Field
                            Text(
                              'Mot de passe',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppTheme.accentGold,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: AppTheme.pureWhite),
                              decoration: InputDecoration(
                                hintText: 'Entrez votre mot de passe',
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: AppTheme.accentGold,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                                filled: true,
                                fillColor: AppTheme.primaryBlack.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: AppTheme.spacingL),

                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: AppTheme.accentGold,
                                      checkColor: AppTheme.primaryBlack,
                                    ),
                                    Text(
                                      'Se souvenir',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: AppTheme.pureWhite),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: _forgotPassword,
                                  child: Text(
                                    'Mot de passe oublié?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppTheme.accentGold),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppTheme.spacingXL),

                            // Login Button
                            CustomButton(
                              text: _isLoading
                                  ? 'Connexion...'
                                  : 'Se connecter',
                              onPressed: _login,
                              isLoading: _isLoading,
                              width: double.infinity,
                            ),

                            const SizedBox(height: AppTheme.spacingL),

                            // Back to App Button
                            CustomButton(
                              text: 'Retour à l\'application',
                              onPressed: () => Navigator.pop(context),
                              isOutlined: true,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Security Notice
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(
                        color: AppTheme.accentGold.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: AppTheme.accentGold,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Expanded(
                          child: Text(
                            'Cette zone est réservée aux administrateurs. Toute tentative d\'accès non autorisé sera enregistrée.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.lightGray),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showErrorSnackBar('Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simuler la connexion
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Simulation de validation (à remplacer par une vraie authentification)
    if (_emailController.text == 'admin@ebshoes.com' &&
        _passwordController.text == 'admin123') {
      _showSuccessSnackBar('Connexion réussie!');

      // Naviguer vers le dashboard admin
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppConstants.adminDashboardRoute,
        );
      }
    } else {
      _showErrorSnackBar('Email ou mot de passe incorrect');
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mot de passe oublié'),
        content: const Text(
          'Veuillez contacter l\'administrateur système pour réinitialiser votre mot de passe.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );
  }
}
