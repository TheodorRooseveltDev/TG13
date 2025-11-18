import '../models/spot_model.dart';
import '../database/local_storage.dart';

/// Repository for managing fishing spot data (100% offline)
class SpotRepository {
  final LocalStorage _storage = LocalStorage.instance;

  /// Get all spots
  Future<List<SpotModel>> getAllSpots() async {
    return await _storage.getSpots();
  }

  /// Get spots sorted by name
  Future<List<SpotModel>> getSpotsByName() async {
    final spots = await getAllSpots();
    spots.sort((a, b) => a.name.compareTo(b.name));
    return spots;
  }

  /// Get spots filtered by water type
  Future<List<SpotModel>> getSpotsByWaterType(String waterType) async {
    final spots = await getAllSpots();
    return spots.where((s) => s.waterType == waterType).toList();
  }

  /// Get spots filtered by rating
  Future<List<SpotModel>> getSpotsByRating(int rating) async {
    final spots = await getAllSpots();
    return spots.where((s) => s.rating >= rating).toList();
  }

  /// Get spots sorted by rating (highest first)
  Future<List<SpotModel>> getSpotsByHighestRating() async {
    final spots = await getAllSpots();
    spots.sort((a, b) => b.rating.compareTo(a.rating));
    return spots;
  }

  /// Get recently visited spots
  Future<List<SpotModel>> getRecentlyVisitedSpots() async {
    final spots = await getAllSpots();
    final visited = spots.where((s) => s.lastVisited != null).toList();
    visited.sort((a, b) => b.lastVisited!.compareTo(a.lastVisited!));
    return visited;
  }

  /// Get spot by ID
  Future<SpotModel?> getSpotById(String id) async {
    final spots = await getAllSpots();
    try {
      return spots.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new spot
  Future<void> addSpot(SpotModel spot) async {
    await _storage.addSpot(spot);
  }

  /// Update existing spot
  Future<void> updateSpot(SpotModel spot) async {
    await _storage.updateSpot(spot);
  }

  /// Delete spot
  Future<void> deleteSpot(String id) async {
    await _storage.deleteSpot(id);
  }

  /// Mark spot as visited
  Future<void> markAsVisited(String id) async {
    final spot = await getSpotById(id);
    if (spot != null) {
      final updated = spot.copyWith(lastVisited: DateTime.now());
      await updateSpot(updated);
    }
  }

  /// Get total spot count
  Future<int> getTotalCount() async {
    final spots = await getAllSpots();
    return spots.length;
  }

  /// Get unique water types
  Future<List<String>> getUniqueWaterTypes() async {
    final spots = await getAllSpots();
    final types = spots.map((s) => s.waterType).toSet().toList();
    types.sort();
    return types;
  }

  /// Get spots count by water type
  Future<Map<String, int>> getSpotCountByWaterType() async {
    final spots = await getAllSpots();
    final Map<String, int> counts = {};
    
    for (var spot in spots) {
      counts[spot.waterType] = (counts[spot.waterType] ?? 0) + 1;
    }
    
    return counts;
  }

  /// Search spots
  Future<List<SpotModel>> searchSpots(String query) async {
    final spots = await getAllSpots();
    final lowerQuery = query.toLowerCase();
    
    return spots.where((s) {
      return s.name.toLowerCase().contains(lowerQuery) ||
             s.waterType.toLowerCase().contains(lowerQuery) ||
             s.depthNotes.toLowerCase().contains(lowerQuery) ||
             s.accessNotes.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get favorite spots (rating 4+)
  Future<List<SpotModel>> getFavoriteSpots() async {
    return await getSpotsByRating(4);
  }
}
