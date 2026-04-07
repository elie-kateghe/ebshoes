import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class ContactScreen extends StatefulWidget {
  final String? productId;
  final String? productName;

  const ContactScreen({Key? key, this.productId, this.productName})
    : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _initializeMessage();
  }

  void _initializeMessage() {
    if (widget.productId != null && widget.productName != null) {
      _messageController.text =
          'Bonjour, je suis intéressé par le produit: ${widget.productName} (ID: ${widget.productId}). Je voudrais avoir plus d\'informations.';
    } else {
      _messageController.text = AppConstants.whatsappOrderMessage;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: CustomAppBar(
        title: 'Contact',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: AppTheme.spacingXL),

              // Contact Methods
              _buildContactMethods(),

              const SizedBox(height: AppTheme.spacingXL),

              // Contact Form
              _buildContactForm(),

              const SizedBox(height: AppTheme.spacingXL),

              // Quick Actions
              _buildQuickActions(),

              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contactez-nous',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(
          'Nous sommes là pour vous aider! Contactez-nous par WhatsApp ou remplissez le formulaire ci-dessous.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.mediumGray,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Méthodes de contact',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),

        // WhatsApp Button
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF25D366), const Color(0xFF128C7E)],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF25D366).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppTheme.spacingL),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.pureWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: const Icon(
                Icons.message,
                color: Color(0xFF25D366),
                size: 28,
              ),
            ),
            title: Text(
              'WhatsApp',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              AppConstants.whatsappContact,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.pureWhite.withOpacity(0.9),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.pureWhite,
            ),
            onTap: _launchWhatsApp,
          ),
        ),

        const SizedBox(height: AppTheme.spacingM),

        // Phone Button
        Container(
          decoration: BoxDecoration(
            color: AppTheme.darkGray,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppTheme.spacingL),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: const Icon(
                Icons.phone,
                color: AppTheme.accentGold,
                size: 28,
              ),
            ),
            title: Text(
              'Téléphone',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '+212 5XX XXX XXX',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.mediumGray,
            ),
            onTap: _launchPhone,
          ),
        ),

        const SizedBox(height: AppTheme.spacingM),

        // Email Button
        Container(
          decoration: BoxDecoration(
            color: AppTheme.darkGray,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppTheme.spacingL),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: const Icon(
                Icons.email,
                color: AppTheme.accentGold,
                size: 28,
              ),
            ),
            title: Text(
              'Email',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'contact@ebshoes.com',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.mediumGray,
            ),
            onTap: _launchEmail,
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ou envoyez-nous un message',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),

        Card(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                // Name Field
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppTheme.pureWhite),
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    hintText: 'Entrez votre nom',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Phone Field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppTheme.pureWhite),
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    hintText: 'Entrez votre numéro',
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.pureWhite),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Entrez votre email',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Message Field
                TextField(
                  controller: _messageController,
                  maxLines: 5,
                  style: const TextStyle(color: AppTheme.pureWhite),
                  decoration: InputDecoration(
                    labelText: 'Message',
                    hintText: 'Décrivez votre demande...',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(
                      Icons.message,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Send Button
                CustomButton(
                  text: _isSending ? 'Envoi...' : 'Envoyer le message',
                  onPressed: _sendMessage,
                  isLoading: _isSending,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.location_on,
                title: 'Magasin',
                subtitle: 'Nous trouver',
                onTap: _showLocation,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.schedule,
                title: 'Horaires',
                subtitle: '09:00 - 20:00',
                onTap: _showHours,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.spacingM),

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.local_shipping,
                title: 'Livraison',
                subtitle: 'Info livraison',
                onTap: _showDeliveryInfo,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.assignment_return,
                title: 'Retours',
                subtitle: 'Politique retour',
                onTap: _showReturnPolicy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(icon, color: AppTheme.accentGold, size: 24),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchWhatsApp() async {
    final message = Uri.encodeComponent(_messageController.text);
    final url = 'https://wa.me/${AppConstants.whatsappContact}?text=$message';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showErrorSnackBar('Impossible d\'ouvrir WhatsApp');
    }
  }

  void _launchPhone() async {
    final url = 'tel:+2125XXXXXXX';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showErrorSnackBar('Impossible d\'ouvrir l\'application téléphone');
    }
  }

  void _launchEmail() async {
    final url =
        'mailto:contact@ebshoes.com?subject=Contact EBShoes&body=${Uri.encodeComponent(_messageController.text)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showErrorSnackBar('Impossible d\'ouvrir l\'application email');
    }
  }

  void _sendMessage() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      _showErrorSnackBar('Veuillez remplir tous les champs obligatoires');
      return;
    }

    setState(() {
      _isSending = true;
    });

    // Simuler l'envoi du message
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Message envoyé avec succès! Nous vous contacterons bientôt.',
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );

    // Vider les champs
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _messageController.text = AppConstants.whatsappOrderMessage;
  }

  void _showLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notre Magasin'),
        content: const Text('123 Avenue Mohammed V, Casablanca, Maroc'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHours() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Horaires d\'ouverture'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lundi - Vendredi: 09:00 - 20:00'),
            Text('Samedi: 09:00 - 18:00'),
            Text('Dimanche: Fermé'),
          ],
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

  void _showDeliveryInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Information de livraison'),
        content: const Text(
          'Livraison gratuite pour toute commande supérieure à 500 MAD. Délai de 2-3 jours ouvrables.',
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

  void _showReturnPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Politique de retour'),
        content: const Text(
          'Retour possible sous 14 jours. Produit doit être en état neuf avec emballage d\'origine.',
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
