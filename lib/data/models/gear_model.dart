import 'package:uuid/uuid.dart';

/// Model representing a piece of fishing gear
class GearModel {
  final String id;
  final String name;
  final String category; // Rods, Reels, Lines, etc.
  final String brand;
  final String condition; // Poor, Fair, Good, Excellent
  final String notes;
  final bool usedOnLastCatch;
  final DateTime? purchaseDate;
  final double? price;
  final DateTime createdAt;
  final DateTime updatedAt;

  GearModel({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.condition,
    required this.notes,
    this.usedOnLastCatch = false,
    this.purchaseDate,
    this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new gear item with generated ID
  factory GearModel.create({
    required String name,
    required String category,
    String brand = '',
    String condition = 'Good',
    String notes = '',
    bool usedOnLastCatch = false,
    DateTime? purchaseDate,
    double? price,
  }) {
    final now = DateTime.now();
    return GearModel(
      id: const Uuid().v4(),
      name: name,
      category: category,
      brand: brand,
      condition: condition,
      notes: notes,
      usedOnLastCatch: usedOnLastCatch,
      purchaseDate: purchaseDate,
      price: price,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with modified fields
  GearModel copyWith({
    String? id,
    String? name,
    String? category,
    String? brand,
    String? condition,
    String? notes,
    bool? usedOnLastCatch,
    DateTime? purchaseDate,
    double? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GearModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      usedOnLastCatch: usedOnLastCatch ?? this.usedOnLastCatch,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON/Map for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'brand': brand,
      'condition': condition,
      'notes': notes,
      'usedOnLastCatch': usedOnLastCatch ? 1 : 0,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON/Map from database
  factory GearModel.fromJson(Map<String, dynamic> json) {
    return GearModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String? ?? '',
      condition: json['condition'] as String,
      notes: json['notes'] as String? ?? '',
      usedOnLastCatch: (json['usedOnLastCatch'] as int?) == 1,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'] as String)
          : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Get condition as a percentage (0-100)
  int get conditionPercentage {
    switch (condition.toLowerCase()) {
      case 'poor':
        return 25;
      case 'fair':
        return 50;
      case 'good':
        return 75;
      case 'excellent':
        return 100;
      default:
        return 50;
    }
  }

  @override
  String toString() {
    return 'GearModel(id: $id, name: $name, category: $category, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GearModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
