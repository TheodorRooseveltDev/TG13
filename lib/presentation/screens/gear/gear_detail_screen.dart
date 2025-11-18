import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/gear_model.dart';
import '../../../providers/gear_provider.dart';
import '../../widgets/boss_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

class GearDetailScreen extends StatelessWidget {
  final GearModel gear;

  const GearDetailScreen({
    super.key,
    required this.gear,
  });

  Future<void> _deleteGear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gear'),
        content: const Text('Are you sure you want to delete this gear item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final gearProvider = Provider.of<GearProvider>(context, listen: false);
      await gearProvider.deleteGear(gear.id);
      
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gear deleted',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App Bar with category icon
          _buildAppBar(context),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Category badge & condition
                FadeInDown(
                  child: _buildCategoryBadge(),
                ),
                const SizedBox(height: 16),

                // Main info card
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: _buildMainInfoCard(),
                ),
                const SizedBox(height: 16),

                // Purchase info (if available)
                if (gear.purchaseDate != null || (gear.price != null && gear.price! > 0))
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildPurchaseInfoCard(),
                  ),
                if (gear.purchaseDate != null || (gear.price != null && gear.price! > 0))
                  const SizedBox(height: 16),

                // Notes (if available)
                if (gear.notes.isNotEmpty)
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildNotesCard(),
                  ),
                if (gear.notes.isNotEmpty)
                  const SizedBox(height: 16),

                // Metadata
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildMetadataCard(),
                ),
                const SizedBox(height: 24),

                // Action buttons
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _buildActionButtons(context),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: _getCategoryColor(gear.category),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          gear.name,
          style: AppTextStyles.headline5.copyWith(color: Colors.white),
        ),
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getCategoryColor(gear.category),
                _getCategoryColor(gear.category).withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              _getCategoryIcon(gear.category),
              size: 100,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getCategoryColor(gear.category).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(gear.category),
                  color: _getCategoryColor(gear.category),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  gear.category,
                  style: AppTextStyles.bodyBoldMedium.copyWith(
                    color: _getCategoryColor(gear.category),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getConditionColor(gear.condition).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              gear.condition,
              style: AppTextStyles.bodyBoldMedium.copyWith(
                color: _getConditionColor(gear.condition),
              ),
            ),
          ),
          if (gear.usedOnLastCatch) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.deepNavy.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.deepNavy,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Recently Used',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.deepNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
          ),
          const SizedBox(height: 16),
          if (gear.brand.isNotEmpty) ...[
            _buildInfoRow(Icons.business, 'Brand', gear.brand),
            const SizedBox(height: 12),
          ],
          _buildInfoRow(Icons.category, 'Category', gear.category),
          const SizedBox(height: 12),
          _buildConditionBar(),
        ],
      ),
    );
  }

  Widget _buildPurchaseInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Purchase Info',
            style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
          ),
          const SizedBox(height: 16),
          if (gear.purchaseDate != null) ...[
            _buildInfoRow(
              Icons.calendar_today,
              'Purchase Date',
              DateFormat('MMM dd, yyyy').format(gear.purchaseDate!),
            ),
            if (gear.price != null && gear.price! > 0)
              const SizedBox(height: 12),
          ],
          if (gear.price != null && gear.price! > 0)
            _buildInfoRow(
              Icons.attach_money,
              'Price',
              '\$${gear.price!.toStringAsFixed(2)}',
            ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note, color: AppColors.deepNavy, size: 20),
              const SizedBox(width: 8),
              Text(
                'Notes',
                style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            gear.notes,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metadata',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _buildMetadataRow('ID', gear.id),
          const SizedBox(height: 8),
          _buildMetadataRow(
            'Added',
            DateFormat('MMM dd, yyyy • hh:mm a').format(gear.createdAt),
          ),
          const SizedBox(height: 8),
          _buildMetadataRow(
            'Updated',
            DateFormat('MMM dd, yyyy • hh:mm a').format(gear.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: BossButton(
              text: 'Edit',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/add-gear',
                  arguments: gear,
                );
              },
              iconPath: 'assets/action-icons/edit.png',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BossOutlineButton(
              text: 'Delete',
              onPressed: () => _deleteGear(context),
              iconPath: 'assets/action-icons/delete.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.deepNavy, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.deepNavy, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Condition',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            Text(
              '${gear.conditionPercentage}%',
              style: AppTextStyles.bodyBoldMedium.copyWith(
                color: _getConditionColor(gear.condition),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: gear.conditionPercentage / 100,
            backgroundColor: AppColors.backgroundLight,
            valueColor: AlwaysStoppedAnimation<Color>(_getConditionColor(gear.condition)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Rod':
        return Icons.straighten;
      case 'Reel':
        return Icons.album;
      case 'Lure':
        return Icons.opacity;
      case 'Line':
        return Icons.linear_scale;
      case 'Tackle':
        return Icons.hardware;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Rod':
        return const Color(0xFF795548); // Brown
      case 'Reel':
        return const Color(0xFF607D8B); // Blue Grey
      case 'Lure':
        return AppColors.sunsetOrange;
      case 'Line':
        return AppColors.deepNavy;
      case 'Tackle':
        return const Color(0xFF9C27B0); // Purple
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'poor':
        return AppColors.error;
      case 'fair':
        return AppColors.warning;
      case 'good':
        return AppColors.success;
      case 'excellent':
        return AppColors.deepNavy;
      default:
        return AppColors.textSecondary;
    }
  }
}
