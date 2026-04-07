import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final double rating;
  final DateTime date;
  final List<String> images;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.rating,
    required this.date,
    this.images = const [],
  });
}

class CommentsScreen extends StatefulWidget {
  final String productId;

  const CommentsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _userRating = 0;
  bool _isSubmittingComment = false;
  
  final List<Comment> _comments = [
    Comment(
      id: '1',
      userName: 'Karim Alaoui',
      userAvatar: 'K',
      content: 'Excellent produit! Très confortable et de bonne qualité. Je recommande vivement.',
      rating: 5,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Comment(
      id: '2',
      userName: 'Fatima Zahra',
      userAvatar: 'F',
      content: 'Beau design mais la taille est un peu petite. Je conseille de prendre une pointure au-dessus.',
      rating: 4,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Comment(
      id: '3',
      userName: 'Youssef Ben',
      userAvatar: 'Y',
      content: 'Produit conforme à la description. Livraison rapide et emballage soigné.',
      rating: 5,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Comment(
      id: '4',
      userName: 'Amina El',
      userAvatar: 'A',
      content: 'Bon rapport qualité-prix. Le produit est exactement comme sur les photos.',
      rating: 4,
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: CustomAppBar(
        title: 'Avis Clients',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Rating Summary
          _buildRatingSummary(),
          
          // Comments List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _buildCommentCard(_comments[index]);
              },
            ),
          ),
          
          // Add Comment Section
          _buildAddCommentSection(),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    final averageRating = _calculateAverageRating();
    
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.darkGray,
            AppTheme.primaryBlack,
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: AppTheme.accentGold.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.accentGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < averageRating.floor() ? Icons.star : Icons.star_border,
                        color: AppTheme.accentGold,
                        size: 20,
                      );
                    }),
                  ),
                  Text(
                    '${_comments.length} avis',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: List.generate(5, (index) {
                  final starCount = 5 - index;
                  final count = _comments.where((c) => c.rating == starCount).length;
                  final percentage = _comments.isEmpty ? 0.0 : (count / _comments.length) * 100;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$starCount',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          color: AppTheme.accentGold,
                          size: 12,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 100,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.mediumGray.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          count.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentGold,
                        AppTheme.lightGold,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      comment.userAvatar,
                      style: const TextStyle(
                        color: AppTheme.primaryBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.pureWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < comment.rating ? Icons.star : Icons.star_border,
                                color: AppTheme.accentGold,
                                size: 14,
                              );
                            }),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            _formatDate(comment.date),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Comment Content
            Text(
              comment.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.pureWhite,
                height: 1.4,
              ),
            ),
            
            // Comment Images (if any)
            if (comment.images.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingM),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: comment.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: AppTheme.spacingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        color: AppTheme.darkGray,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        child: Image.network(
                          comment.images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              color: AppTheme.mediumGray,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            
            // Actions
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_outlined, size: 16),
                  label: const Text('Utile'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.mediumGray,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.flag_outlined, size: 16),
                  label: const Text('Signaler'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.mediumGray,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCommentSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusL),
          topRight: Radius.circular(AppTheme.radiusL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Laisser un avis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Rating Selection
          Row(
            children: [
              Text(
                'Note:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _userRating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _userRating ? Icons.star : Icons.star_border,
                      color: AppTheme.accentGold,
                      size: 24,
                    ),
                  );
                }),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Comment Input
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: AppConstants.maxCommentLength,
            style: const TextStyle(color: AppTheme.pureWhite),
            decoration: InputDecoration(
              hintText: 'Partagez votre expérience avec ce produit...',
              hintStyle: TextStyle(
                color: AppTheme.mediumGray.withOpacity(0.7),
              ),
              filled: true,
              fillColor: AppTheme.primaryBlack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.mediumGray.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide(
                  color: AppTheme.mediumGray.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: const BorderSide(
                  color: AppTheme.accentGold,
                  width: 2,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Submit Button
          CustomButton(
            text: _isSubmittingComment ? 'Envoi...' : 'Envoyer l\'avis',
            onPressed: _userRating > 0 && _commentController.text.isNotEmpty
                ? _submitComment
                : null,
            isLoading: _isSubmittingComment,
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating() {
    if (_comments.isEmpty) return 0.0;
    final total = _comments.fold(0.0, (sum, comment) => sum + comment.rating);
    return total / _comments.length;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      return 'Il y a ${difference.inDays ~/ 7} semaines';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _submitComment() async {
    if (_userRating == 0 || _commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    // Simuler l'envoi du commentaire
    await Future.delayed(const Duration(seconds: 2));

    final newComment = Comment(
      id: DateTime.now().toString(),
      userName: 'Utilisateur',
      userAvatar: 'U',
      content: _commentController.text.trim(),
      rating: _userRating,
      date: DateTime.now(),
    );

    setState(() {
      _comments.insert(0, newComment);
      _isSubmittingComment = false;
      _userRating = 0;
      _commentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Avis envoyé avec succès!'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );
  }
}
