import 'package:big_boss_fishing/core/constants/app_constants.dart';

/// Model representing an achievement/badge
class AchievementModel {
  final String id;
  final String name;
  final String description;
  final String badgeImage; // path to badge image
  final bool isUnlocked;
  final double progress; // 0.0 to 1.0
  final int xpReward;
  final DateTime? unlockedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.badgeImage,
    this.isUnlocked = false,
    this.progress = 0.0,
    required this.xpReward,
    this.unlockedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with modified fields
  AchievementModel copyWith({
    String? id,
    String? name,
    String? description,
    String? badgeImage,
    bool? isUnlocked,
    double? progress,
    int? xpReward,
    DateTime? unlockedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      badgeImage: badgeImage ?? this.badgeImage,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
      xpReward: xpReward ?? this.xpReward,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON/Map for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'badgeImage': badgeImage,
      'isUnlocked': isUnlocked ? 1 : 0,
      'progress': progress,
      'xpReward': xpReward,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON/Map from database
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      badgeImage: json['badgeImage'] as String,
      isUnlocked: (json['isUnlocked'] as int) == 1,
      progress: (json['progress'] as num).toDouble(),
      xpReward: json['xpReward'] as int,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Get progress as percentage (0-100)
  int get progressPercentage => (progress * 100).round();

  @override
  String toString() {
    return 'AchievementModel(id: $id, name: $name, isUnlocked: $isUnlocked, progress: ${progressPercentage}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AchievementModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
  
  /// Get all default achievements for initial setup
  static List<AchievementModel> getDefaultAchievements() {
    final now = DateTime.now();
    
    return [
      AchievementModel(
        id: 'first_catch',
        name: 'First Catch',
        description: 'Log your first catch',
        badgeImage: AppConstants.achievementBadges['first_catch']!,
        xpReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'ten_catches',
        name: 'Tenacious Fisher',
        description: 'Log 10 catches',
        badgeImage: AppConstants.achievementBadges['ten_catches']!,
        xpReward: 100,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'big_boss',
        name: 'Big Boss',
        description: 'Catch a trophy fish (20+ lbs or 30+ inches)',
        badgeImage: AppConstants.achievementBadges['big_boss']!,
        xpReward: 150,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'bait_master',
        name: 'Bait Master',
        description: 'Use 10 different types of bait',
        badgeImage: AppConstants.achievementBadges['bait_master']!,
        xpReward: 75,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'catch_streak',
        name: 'Catch Streak',
        description: 'Log catches 7 days in a row',
        badgeImage: AppConstants.achievementBadges['catch_streak']!,
        xpReward: 100,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'dawn_fisher',
        name: 'Dawn Fisher',
        description: 'Catch a fish in early morning (5-8 AM)',
        badgeImage: AppConstants.achievementBadges['dawn_fisher']!,
        xpReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'gear_guardian',
        name: 'Gear Guardian',
        description: 'Add 20 items to your gear inventory',
        badgeImage: AppConstants.achievementBadges['gear_guardian']!,
        xpReward: 75,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'lake_master',
        name: 'Lake Master',
        description: 'Discover 10 fishing spots',
        badgeImage: AppConstants.achievementBadges['lake_master']!,
        xpReward: 100,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'night_owl',
        name: 'Night Owl',
        description: 'Catch a fish at night (9 PM - 5 AM)',
        badgeImage: AppConstants.achievementBadges['night_owl']!,
        xpReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'perfect_cast',
        name: 'Perfect Cast',
        description: 'Give 10 catches a 5-star rating',
        badgeImage: AppConstants.achievementBadges['perfect_cast']!,
        xpReward: 75,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'spot_hunter',
        name: 'Spot Hunter',
        description: 'Visit 5 different fishing spots',
        badgeImage: AppConstants.achievementBadges['spot_hunter']!,
        xpReward: 75,
        createdAt: now,
        updatedAt: now,
      ),
      AchievementModel(
        id: 'trophy_hunter',
        name: 'Trophy Hunter',
        description: 'Catch 5 trophy fish',
        badgeImage: AppConstants.achievementBadges['trophy_hunter']!,
        xpReward: 200,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
