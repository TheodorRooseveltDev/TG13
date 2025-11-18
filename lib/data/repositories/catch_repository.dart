import '../models/catch_model.dart';
import '../database/local_storage.dart';

/// Repository for managing catch data (100% offline)
class CatchRepository {
  final LocalStorage _storage = LocalStorage.instance;

  /// Get all catches
  Future<List<CatchModel>> getAllCatches() async {
    return await _storage.getCatches();
  }

  /// Get catches sorted by date (newest first)
  Future<List<CatchModel>> getCatchesByDate() async {
    final catches = await getAllCatches();
    catches.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return catches;
  }

  /// Get catches filtered by species
  Future<List<CatchModel>> getCatchesBySpecies(String species) async {
    final catches = await getAllCatches();
    return catches.where((c) => c.species == species).toList();
  }

  /// Get catches filtered by location
  Future<List<CatchModel>> getCatchesByLocation(String location) async {
    final catches = await getAllCatches();
    return catches.where((c) => c.location == location).toList();
  }

  /// Get catches sorted by weight (biggest first)
  Future<List<CatchModel>> getCatchesByWeight() async {
    final catches = await getAllCatches();
    catches.sort((a, b) => b.weight.compareTo(a.weight));
    return catches;
  }

  /// Get catches sorted by length (longest first)
  Future<List<CatchModel>> getCatchesByLength() async {
    final catches = await getAllCatches();
    catches.sort((a, b) => b.length.compareTo(a.length));
    return catches;
  }

  /// Get catches by rating
  Future<List<CatchModel>> getCatchesByRating(int rating) async {
    final catches = await getAllCatches();
    return catches.where((c) => c.rating == rating).toList();
  }

  /// Get last catch
  Future<CatchModel?> getLastCatch() async {
    final catches = await getCatchesByDate();
    return catches.isEmpty ? null : catches.first;
  }

  /// Get catch by ID
  Future<CatchModel?> getCatchById(String id) async {
    final catches = await getAllCatches();
    try {
      return catches.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new catch
  Future<void> addCatch(CatchModel catchModel) async {
    await _storage.addCatch(catchModel);
  }

  /// Update existing catch
  Future<void> updateCatch(CatchModel catchModel) async {
    await _storage.updateCatch(catchModel);
  }

  /// Delete catch
  Future<void> deleteCatch(String id) async {
    await _storage.deleteCatch(id);
  }

  /// Get total catch count
  Future<int> getTotalCount() async {
    final catches = await getAllCatches();
    return catches.length;
  }

  /// Get largest catch by weight
  Future<CatchModel?> getLargestByWeight() async {
    final catches = await getCatchesByWeight();
    return catches.isEmpty ? null : catches.first;
  }

  /// Get longest catch
  Future<CatchModel?> getLongestCatch() async {
    final catches = await getCatchesByLength();
    return catches.isEmpty ? null : catches.first;
  }

  /// Get all unique species caught
  Future<List<String>> getUniqueSpecies() async {
    final catches = await getAllCatches();
    final species = catches.map((c) => c.species).toSet().toList();
    species.sort();
    return species;
  }

  /// Get all unique locations
  Future<List<String>> getUniqueLocations() async {
    final catches = await getAllCatches();
    final locations = catches.map((c) => c.location).toSet().toList();
    locations.sort();
    return locations;
  }

  /// Get catches count by species
  Future<Map<String, int>> getCatchCountBySpecies() async {
    final catches = await getAllCatches();
    final Map<String, int> counts = {};
    
    for (var catch_ in catches) {
      counts[catch_.species] = (counts[catch_.species] ?? 0) + 1;
    }
    
    return counts;
  }

  /// Get average weight
  Future<double> getAverageWeight() async {
    final catches = await getAllCatches();
    if (catches.isEmpty) return 0.0;
    
    final total = catches.fold<double>(0.0, (sum, c) => sum + c.weight);
    return total / catches.length;
  }

  /// Get average length
  Future<double> getAverageLength() async {
    final catches = await getAllCatches();
    if (catches.isEmpty) return 0.0;
    
    final total = catches.fold<double>(0.0, (sum, c) => sum + c.length);
    return total / catches.length;
  }

  /// Search catches
  Future<List<CatchModel>> searchCatches(String query) async {
    final catches = await getAllCatches();
    final lowerQuery = query.toLowerCase();
    
    return catches.where((c) {
      return c.species.toLowerCase().contains(lowerQuery) ||
             c.location.toLowerCase().contains(lowerQuery) ||
             c.notes.toLowerCase().contains(lowerQuery) ||
             c.bait.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
