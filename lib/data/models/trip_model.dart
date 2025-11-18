import 'package:uuid/uuid.dart';

/// Model representing a planned fishing trip
class TripModel {
  final String id;
  final String destination;
  final DateTime dateTime;
  final String waterType;
  final List<String> gearChecklist;
  final String targetSpecies;
  final String notes;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TripModel({
    required this.id,
    required this.destination,
    required this.dateTime,
    required this.waterType,
    required this.gearChecklist,
    required this.targetSpecies,
    required this.notes,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new trip with generated ID
  factory TripModel.create({
    required String destination,
    required DateTime dateTime,
    required String waterType,
    List<String> gearChecklist = const [],
    String targetSpecies = '',
    String notes = '',
    bool isCompleted = false,
  }) {
    final now = DateTime.now();
    return TripModel(
      id: const Uuid().v4(),
      destination: destination,
      dateTime: dateTime,
      waterType: waterType,
      gearChecklist: gearChecklist,
      targetSpecies: targetSpecies,
      notes: notes,
      isCompleted: isCompleted,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with modified fields
  TripModel copyWith({
    String? id,
    String? destination,
    DateTime? dateTime,
    String? waterType,
    List<String>? gearChecklist,
    String? targetSpecies,
    String? notes,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      dateTime: dateTime ?? this.dateTime,
      waterType: waterType ?? this.waterType,
      gearChecklist: gearChecklist ?? this.gearChecklist,
      targetSpecies: targetSpecies ?? this.targetSpecies,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON/Map for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'dateTime': dateTime.toIso8601String(),
      'waterType': waterType,
      'gearChecklist': gearChecklist.join(','), // Store as comma-separated string
      'targetSpecies': targetSpecies,
      'notes': notes,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON/Map from database
  factory TripModel.fromJson(Map<String, dynamic> json) {
    final gearChecklistString = json['gearChecklist'] as String? ?? '';
    final gearChecklist = gearChecklistString.isEmpty 
        ? <String>[] 
        : gearChecklistString.split(',');

    return TripModel(
      id: json['id'] as String,
      destination: json['destination'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      waterType: json['waterType'] as String,
      gearChecklist: gearChecklist,
      targetSpecies: json['targetSpecies'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      isCompleted: (json['isCompleted'] as int) == 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Check if trip is in the future
  bool get isFuture => dateTime.isAfter(DateTime.now());

  /// Check if trip is in the past
  bool get isPast => dateTime.isBefore(DateTime.now());

  /// Check if trip is today
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }

  @override
  String toString() {
    return 'TripModel(id: $id, destination: $destination, dateTime: $dateTime, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TripModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
