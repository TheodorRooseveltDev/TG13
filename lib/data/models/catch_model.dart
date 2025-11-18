import 'package:uuid/uuid.dart';

/// Model representing a fish catch
class CatchModel {
  final String id;
  final String species;
  final double weight; // in pounds
  final double length; // in inches
  final DateTime dateTime;
  final String location;
  final String weather;
  final String bait;
  final String technique;
  final String? photoPath;
  final String notes;
  final int rating; // 1-5 stars
  final DateTime createdAt;
  final DateTime updatedAt;

  CatchModel({
    required this.id,
    required this.species,
    required this.weight,
    required this.length,
    required this.dateTime,
    required this.location,
    required this.weather,
    required this.bait,
    required this.technique,
    this.photoPath,
    required this.notes,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new catch with generated ID
  factory CatchModel.create({
    required String species,
    required double weight,
    required double length,
    required DateTime dateTime,
    required String location,
    required String weather,
    required String bait,
    required String technique,
    String? photoPath,
    String notes = '',
    int rating = 3,
  }) {
    final now = DateTime.now();
    return CatchModel(
      id: const Uuid().v4(),
      species: species,
      weight: weight,
      length: length,
      dateTime: dateTime,
      location: location,
      weather: weather,
      bait: bait,
      technique: technique,
      photoPath: photoPath,
      notes: notes,
      rating: rating,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with modified fields
  CatchModel copyWith({
    String? id,
    String? species,
    double? weight,
    double? length,
    DateTime? dateTime,
    String? location,
    String? weather,
    String? bait,
    String? technique,
    String? photoPath,
    String? notes,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CatchModel(
      id: id ?? this.id,
      species: species ?? this.species,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      weather: weather ?? this.weather,
      bait: bait ?? this.bait,
      technique: technique ?? this.technique,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON/Map for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species': species,
      'weight': weight,
      'length': length,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'weather': weather,
      'bait': bait,
      'technique': technique,
      'photoPath': photoPath,
      'notes': notes,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON/Map from database
  factory CatchModel.fromJson(Map<String, dynamic> json) {
    return CatchModel(
      id: json['id'] as String,
      species: json['species'] as String,
      weight: (json['weight'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String,
      weather: json['weather'] as String,
      bait: json['bait'] as String,
      technique: json['technique'] as String,
      photoPath: json['photoPath'] as String?,
      notes: json['notes'] as String? ?? '',
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'CatchModel(id: $id, species: $species, weight: $weight lbs, length: $length in, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CatchModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
