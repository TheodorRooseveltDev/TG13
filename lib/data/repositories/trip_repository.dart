import '../models/trip_model.dart';
import '../database/local_storage.dart';

/// Repository for managing trip data (100% offline)
class TripRepository {
  final LocalStorage _storage = LocalStorage.instance;

  /// Get all trips
  Future<List<TripModel>> getAllTrips() async {
    return await _storage.getTrips();
  }

  /// Get upcoming trips (future dates)
  Future<List<TripModel>> getUpcomingTrips() async {
    final trips = await getAllTrips();
    final upcoming = trips.where((t) => t.isFuture && !t.isCompleted).toList();
    upcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return upcoming;
  }

  /// Get past trips
  Future<List<TripModel>> getPastTrips() async {
    final trips = await getAllTrips();
    final past = trips.where((t) => t.isPast).toList();
    past.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return past;
  }

  /// Get completed trips
  Future<List<TripModel>> getCompletedTrips() async {
    final trips = await getAllTrips();
    return trips.where((t) => t.isCompleted).toList();
  }

  /// Get next trip
  Future<TripModel?> getNextTrip() async {
    final upcoming = await getUpcomingTrips();
    return upcoming.isEmpty ? null : upcoming.first;
  }

  /// Get trip by ID
  Future<TripModel?> getTripById(String id) async {
    final trips = await getAllTrips();
    try {
      return trips.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new trip
  Future<void> addTrip(TripModel trip) async {
    await _storage.addTrip(trip);
  }

  /// Update existing trip
  Future<void> updateTrip(TripModel trip) async {
    await _storage.updateTrip(trip);
  }

  /// Delete trip
  Future<void> deleteTrip(String id) async {
    await _storage.deleteTrip(id);
  }

  /// Mark trip as completed
  Future<void> markAsCompleted(String id) async {
    final trip = await getTripById(id);
    if (trip != null) {
      final updated = trip.copyWith(isCompleted: true);
      await updateTrip(updated);
    }
  }

  /// Get total trip count
  Future<int> getTotalCount() async {
    final trips = await getAllTrips();
    return trips.length;
  }

  /// Get trips count by water type
  Future<Map<String, int>> getTripCountByWaterType() async {
    final trips = await getAllTrips();
    final Map<String, int> counts = {};
    
    for (var trip in trips) {
      counts[trip.waterType] = (counts[trip.waterType] ?? 0) + 1;
    }
    
    return counts;
  }

  /// Search trips
  Future<List<TripModel>> searchTrips(String query) async {
    final trips = await getAllTrips();
    final lowerQuery = query.toLowerCase();
    
    return trips.where((t) {
      return t.destination.toLowerCase().contains(lowerQuery) ||
             t.waterType.toLowerCase().contains(lowerQuery) ||
             t.targetSpecies.toLowerCase().contains(lowerQuery) ||
             t.notes.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
