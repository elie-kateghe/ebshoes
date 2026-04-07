import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class Comment {
  final String id;
  final String userName;
  final String productName;
  final String content;
  final double rating;
  final DateTime date;
  bool isApproved;
  final String userAvatar;

  Comment({
    required this.id,
    required this.userName,
    required this.productName,
    required this.content,
    required this.rating,
    required this.date,
    this.isApproved = true,
    required this.userAvatar,
  });
}

class ManageCommentsScreen extends StatefulWidget {
  const ManageCommentsScreen({Key? key}) : super(key: key);

  @override
  State<ManageCommentsScreen> createState() => _ManageCommentsScreenState();
}

class _ManageCommentsScreenState extends State<ManageCommentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Comment> _comments = [];
  List<Comment> _filteredComments = [];
  bool _isLoading = false;
  String _selectedFilter = 'Tous';

  final List<String> _filters = ['Tous', 'Approuvés', 'En attente', 'Rejetés'];

  @override
  void initState() {
    super.initState();
    _loadComments();
    _searchController.addListener(_filterComments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler le chargement des commentaires
    await Future.delayed(const Duration(seconds: 1));

    final mockComments = [
      Comment(
        id: '1',
        userName: 'Karim Alaoui',
        productName: 'Sneaker Premium X',
        content:
            'Excellent produit! Très confortable et de bonne qualité. Je recommande vivement.',
        rating: 5.0,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isApproved: true,
        userAvatar: 'K',
      ),
      Comment(
        id: '2',
        userName: 'Fatima Zahra',
        productName: 'Basket Classic',
        content:
            'Beau design mais la taille est un peu petite. Je conseille de prendre une pointure au-dessus.',
        rating: 4.0,
        date: DateTime.now().subtract(const Duration(hours: 5)),
        isApproved: true,
        userAvatar: 'F',
      ),
      Comment(
        id: '3',
        userName: 'Youssef Ben',
        productName: 'Running Pro',
        content:
            'Produit conforme à la description. Livraison rapide et emballage soigné.',
        rating: 5.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isApproved: false,
        userAvatar: 'Y',
      ),
      Comment(
        id: '4',
        userName: 'Amina El',
        productName: 'Urban Style',
        content:
            'Bon rapport qualité-prix. Le produit est exactement comme sur les photos.',
        rating: 4.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isApproved: true,
        userAvatar: 'A',
      ),
      Comment(
        id: '5',
        userName: 'Mohammed Ali',
        productName: 'Sneaker Premium X',
        content:
            'Très déçu par la qualité, les coutures commencent à se défaire après une semaine.',
        rating: 2.0,
        date: DateTime.now().subtract(const Duration(days: 3)),
        isApproved: false,
        userAvatar: 'M',
      ),
    ];

    setState(() {
      _comments = mockComments;
      _filteredComments = mockComments;
      _isLoading = false;
    });
  }

  void _filterComments() {
    final query = _searchController.text.toLowerCase();
    final filter = _selectedFilter;

    setState(() {
      _filteredComments = _comments.where((comment) {
        final matchesQuery =
            comment.userName.toLowerCase().contains(query) ||
            comment.productName.toLowerCase().contains(query) ||
            comment.content.toLowerCase().contains(query);

        bool matchesFilter;
        switch (filter) {
          case 'Approuvés':
            matchesFilter = comment.isApproved;
            break;
          case 'En attente':
            matchesFilter = !comment.isApproved && comment.rating >= 3.0;
            break;
          case 'Rejetés':
            matchesFilter = !comment.isApproved && comment.rating < 3.0;
            break;
          default:
            matchesFilter = true;
        }

        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final approvedCount = _comments.where((c) => c.isApproved).length;
    final pendingCount = _comments.where((c) => !c.isApproved).length;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: CustomAppBar(
        title: 'Gestion des Commentaires',
        automaticallyImplyLeading: false,
        actions: [
          Badge(
            label: Text('$pendingCount'),
            backgroundColor: AppTheme.warningOrange,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              tooltip: 'Commentaires en attente',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats cards
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    _comments.length.toString(),
                    Icons.comment,
                    AppTheme.accentGold,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildStatCard(
                    'Approuvés',
                    approvedCount.toString(),
                    Icons.check_circle,
                    AppTheme.successGreen,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildStatCard(
                    'En attente',
                    pendingCount.toString(),
                    Icons.pending,
                    AppTheme.warningOrange,
                  ),
                ),
              ],
            ),
          ),

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
                    hintText: 'Rechercher un commentaire...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.accentGold,
                    ),
                    filled: true,
                    fillColor: AppTheme.darkGray,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Filter chips
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;

                      return Container(
                        margin: const EdgeInsets.only(right: AppTheme.spacingS),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                            _filterComments();
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

          // Comments list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentGold,
                    ),
                  )
                : _filteredComments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 64,
                          color: AppTheme.mediumGray,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          'Aucun commentaire trouvé',
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
                    itemCount: _filteredComments.length,
                    itemBuilder: (context, index) {
                      final comment = _filteredComments[index];
                      return _buildCommentCard(comment);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.darkGray, AppTheme.primaryBlack],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    List<Widget> actionButtons = [
      IconButton(
        onPressed: () => _deleteComment(comment),
        icon: const Icon(Icons.delete, color: AppTheme.errorRed),
        tooltip: 'Supprimer',
        iconSize: 20,
      ),
    ];

    if (!comment.isApproved) {
      actionButtons.insert(
        0,
        IconButton(
          onPressed: () => _approveComment(comment),
          icon: const Icon(Icons.check, color: AppTheme.successGreen),
          tooltip: 'Approuver',
          iconSize: 20,
        ),
      );
      actionButtons.insert(
        1,
        IconButton(
          onPressed: () => _rejectComment(comment),
          icon: const Icon(Icons.close, color: AppTheme.errorRed),
          tooltip: 'Rejeter',
          iconSize: 20,
        ),
      );
    }

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
            // Header
            Row(
              children: [
                // User avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.accentGold, AppTheme.lightGold],
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

                // User info and rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.userName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < comment.rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppTheme.accentGold,
                                size: 16,
                              );
                            }),
                          ),
                        ],
                      ),
                      Text(
                        'Produit: ${comment.productName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: comment.isApproved
                        ? AppTheme.successGreen
                        : AppTheme.warningOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    comment.isApproved ? 'Approuvé' : 'En attente',
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Comment content
            Text(
              comment.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.pureWhite,
                height: 1.4,
              ),
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Date and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(comment.date),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
                ),
                Row(children: actionButtons),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _approveComment(Comment comment) {
    setState(() {
      comment.isApproved = true;
    });
    _showSuccessSnackBar('Commentaire approuvé avec succès');
  }

  void _rejectComment(Comment comment) {
    setState(() {
      comment.isApproved = false;
    });
    _showSuccessSnackBar('Commentaire rejeté');
  }

  void _deleteComment(Comment comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer ce commentaire de "${comment.userName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _comments.removeWhere((c) => c.id == comment.id);
                _filteredComments.removeWhere((c) => c.id == comment.id);
              });
              _showSuccessSnackBar('Commentaire supprimé avec succès');
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
