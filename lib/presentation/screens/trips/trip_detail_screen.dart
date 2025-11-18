import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/gear_model.dart';
import '../../../providers/trip_provider.dart';
import '../../../providers/gear_provider.dart';
import '../../widgets/boss_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

class TripDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailScreen({
    super.key,
    required this.trip,
  });

  Future<void> _toggleCompleteStatus(BuildContext context) async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    final updatedTrip = trip.copyWith(
      isCompleted: !trip.isCompleted,
    );
    
    await tripProvider.updateTrip(updatedTrip);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            trip.isCompleted ? 'Trip marked as planned' : 'Trip completed! Great fishing!',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteTrip(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text('Are you sure you want to delete this trip?'),
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
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      await tripProvider.deleteTrip(trip.id);
      
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Trip deleted',
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
    final bool isUpcoming = !trip.isCompleted && trip.dateTime.isAfter(DateTime.now());
    final bool isPast = trip.dateTime.isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App Bar
          _buildAppBar(context, isUpcoming),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Status badges
                FadeInDown(
                  child: _buildStatusBadges(isUpcoming, isPast),
                ),
                const SizedBox(height: 16),

                // Main info card
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: _buildMainInfoCard(),
                ),
                const SizedBox(height: 16),

                // Gear checklist
                if (trip.gearChecklist.isNotEmpty)
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildGearChecklistCard(context),
                  ),
                if (trip.gearChecklist.isNotEmpty)
                  const SizedBox(height: 16),

                // Notes (if available)
                if (trip.notes.isNotEmpty)
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildNotesCard(),
                  ),
                if (trip.notes.isNotEmpty)
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
                  child: _buildActionButtons(context, isUpcoming),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isUpcoming) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: isUpcoming ? AppColors.deepNavy : AppColors.deepNavy,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          trip.destination,
          style: AppTextStyles.headline5.copyWith(color: Colors.white),
        ),
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isUpcoming
                  ? [AppColors.deepNavy, AppColors.deepNavy.withOpacity(0.7)]
                  : [AppColors.deepNavy, AppColors.deepNavy.withOpacity(0.7)],
            ),
          ),
          child: Center(
            child: Icon(
              isUpcoming ? Icons.explore : Icons.check_circle,
              size: 100,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadges(bool isUpcoming, bool isPast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (trip.isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Completed',
                    style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            )
          else if (isUpcoming)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.deepNavy.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upcoming, color: AppColors.deepNavy, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Upcoming',
                    style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.deepNavy),
                  ),
                ],
              ),
            )
          else if (isPast)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Past',
                    style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getWaterTypeColor(trip.waterType).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(_getWaterTypeIcon(trip.waterType), 
                     color: _getWaterTypeColor(trip.waterType), 
                     size: 20),
                const SizedBox(width: 8),
                Text(
                  trip.waterType,
                  style: AppTextStyles.bodyBoldMedium.copyWith(
                    color: _getWaterTypeColor(trip.waterType),
                  ),
                ),
              ],
            ),
          ),
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
            'Trip Details',
            style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.calendar_today,
            'Date & Time',
            DateFormat('EEEE, MMM dd, yyyy • hh:mm a').format(trip.dateTime),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.water,
            'Water Type',
            trip.waterType,
          ),
          if (trip.targetSpecies.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.phishing,
              'Target Species',
              trip.targetSpecies,
            ),
          ],
          const SizedBox(height: 16),
          _buildCountdown(),
        ],
      ),
    );
  }

  Widget _buildGearChecklistCard(BuildContext context) {
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
              const Icon(Icons.checklist, color: AppColors.deepNavy, size: 24),
              const SizedBox(width: 12),
              Text(
                'Gear Checklist',
                style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<GearProvider>(
            builder: (context, gearProvider, child) {
              return Column(
                children: trip.gearChecklist.map((gearId) {
                  final gear = gearProvider.gear.firstWhere(
                    (g) => g.id == gearId,
                    orElse: () => GearModel.create(name: 'Unknown', category: 'Other'),
                  );
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            gear.name,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        Text(
                          gear.category,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
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
            trip.notes,
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
          _buildMetadataRow('ID', trip.id),
          const SizedBox(height: 8),
          _buildMetadataRow(
            'Created',
            DateFormat('MMM dd, yyyy • hh:mm a').format(trip.createdAt),
          ),
          const SizedBox(height: 8),
          _buildMetadataRow(
            'Updated',
            DateFormat('MMM dd, yyyy • hh:mm a').format(trip.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isUpcoming) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Mark as complete/incomplete button
          BossButton(
            text: trip.isCompleted ? 'Mark as Planned' : 'Mark as Completed',
            onPressed: () => _toggleCompleteStatus(context),
            icon: trip.isCompleted ? Icons.undo : Icons.check_circle,
          ),
          const SizedBox(height: 12),
          
          // Edit and Delete buttons
          Row(
            children: [
              Expanded(
                child: BossOutlineButton(
                  text: 'Edit',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/add-trip',
                      arguments: trip,
                    );
                  },
                  iconPath: 'assets/action-icons/edit.png',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BossOutlineButton(
                  text: 'Delete',
                  onPressed: () => _deleteTrip(context),
                  iconPath: 'assets/action-icons/delete.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildCountdown() {
    if (trip.isCompleted) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              'Trip Completed',
              style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.success),
            ),
          ],
        ),
      );
    }

    final now = DateTime.now();
    final difference = trip.dateTime.difference(now);

    if (difference.isNegative) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              'This trip has passed',
              style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.deepNavy.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.schedule, color: AppColors.deepNavy),
          const SizedBox(width: 8),
          Text(
            days > 0 ? '$days days, $hours hours away' : '$hours hours away',
            style: AppTextStyles.bodyBoldMedium.copyWith(color: AppColors.deepNavy),
          ),
        ],
      ),
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

  IconData _getWaterTypeIcon(String waterType) {
    switch (waterType.toLowerCase()) {
      case 'lake':
        return Icons.water;
      case 'river':
        return Icons.water_drop;
      case 'ocean':
        return Icons.waves;
      case 'pond':
        return Icons.water;
      case 'stream':
        return Icons.water_drop;
      default:
        return Icons.water;
    }
  }

  Color _getWaterTypeColor(String waterType) {
    switch (waterType.toLowerCase()) {
      case 'lake':
        return const Color(0xFF2196F3);
      case 'river':
        return const Color(0xFF00BCD4);
      case 'ocean':
        return const Color(0xFF3F51B5);
      case 'pond':
        return const Color(0xFF009688);
      case 'stream':
        return const Color(0xFF00ACC1);
      default:
        return AppColors.deepNavy;
    }
  }
}
