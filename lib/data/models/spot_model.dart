import 'package:uuid/uuid.dart';

/// Model representing a fishing spot
class SpotModel {
  final String id;
  final String name;
  final String waterType; // lake, river, ocean, etc.
  final String bestTime; // morning, noon, evening, night
  final String depthNotes;
  final List<String> commonFish; // fish species commonly found here
  final String accessNotes;
  final String? photoPath;
  final int rating; // 1-5 stars
  final DateTime? lastVisited;
  final DateTime createdAt;
  final DateTime updatedAt;

  SpotModel({
    required this.id,
    required this.name,
    required this.waterType,
    required this.bestTime,
    required this.depthNotes,
    required this.commonFish,
    required this.accessNotes,
    this.photoPath,
    required this.rating,
    this.lastVisited,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new spot with generated ID
  factory SpotModel.create({
    required String name,
    required String waterType,
    required String bestTime,
    String depthNotes = '',
    List<String> commonFish = const [],
    String accessNotes = '',
    String? photoPath,
    int rating = 3,
    DateTime? lastVisited,
  }) {
    final now = DateTime.now();
    return SpotModel(
      id: const Uuid().v4(),
      name: name,
      waterType: waterType,
      bestTime: bestTime,
      depthNotes: depthNotes,
      commonFish: commonFish,
      accessNotes: accessNotes,
      photoPath: photoPath,
      rating: rating,
      lastVisited: lastVisited,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with modified fields
  SpotModel copyWith({
    String? id,
    String? name,
    String? waterType,
    String? bestTime,
    String? depthNotes,
    List<String>? commonFish,
    String? accessNotes,
    String? photoPath,
    int? rating,
    DateTime? lastVisited,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpotModel(
      id: id ?? this.id,
      name: name ?? this.name,
      waterType: waterType ?? this.waterType,
      bestTime: bestTime ?? this.bestTime,
      depthNotes: depthNotes ?? this.depthNotes,
      commonFish: commonFish ?? this.commonFish,
      accessNotes: accessNotes ?? this.accessNotes,
      photoPath: photoPath ?? this.photoPath,
      rating: rating ?? this.rating,
      lastVisited: lastVisited ?? this.lastVisited,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON/Map for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'waterType': waterType,
      'bestTime': bestTime,
      'depthNotes': depthNotes,
      'commonFish': commonFish.join(','), // Store as comma-separated string
      'accessNotes': accessNotes,
      'photoPath': photoPath,
      'rating': rating,
      'lastVisited': lastVisited?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON/Map from database
  factory SpotModel.fromJson(Map<String, dynamic> json) {
    final commonFishString = json['commonFish'] as String? ?? '';
    final commonFish = commonFishString.isEmpty 
        ? <String>[] 
        : commonFishString.split(',');

    return SpotModel(
      id: json['id'] as String,
      name: json['name'] as String,
      waterType: json['waterType'] as String,
      bestTime: json['bestTime'] as String,
      depthNotes: json['depthNotes'] as String? ?? '',
      commonFish: commonFish,
      accessNotes: json['accessNotes'] as String? ?? '',
      photoPath: json['photoPath'] as String?,
      rating: json['rating'] as int,
      lastVisited: json['lastVisited'] != null 
          ? DateTime.parse(json['lastVisited'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'SpotModel(id: $id, name: $name, waterType: $waterType, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpotModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
