import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isTextButton;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isTextButton = false,
    this.icon,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button;

    if (isTextButton) {
      button = TextButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(),
      );
    } else if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(),
      );
    }

    return SizedBox(width: width, height: height ?? 50, child: button);
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined || isTextButton
                ? AppTheme.accentGold
                : AppTheme.primaryBlack,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(text)],
      );
    }

    return Text(text);
  }
}

class WhatsAppButton extends StatelessWidget {
  final String message;
  final String phoneNumber;
  final String? text;

  const WhatsAppButton({
    Key? key,
    required this.message,
    required this.phoneNumber,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.goldShadow,
      ),
      child: CustomButton(
        text: text ?? 'Commander via WhatsApp',
        onPressed: () => _launchWhatsApp(),
        icon: Icons.message,
        width: double.infinity,
      ),
    );
  }

  void _launchWhatsApp() async {
    // Note: Vous devrez ajouter url_launcher pour ouvrir le lien
    // final uri = Uri.parse(
    //   'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    // );
    // await launchUrl(uri);
  }
}
