import '../models/gear_model.dart';
import '../database/local_storage.dart';

/// Repository for managing gear data (100% offline)
class GearRepository {
  final LocalStorage _storage = LocalStorage.instance;

  /// Get all gear
  Future<List<GearModel>> getAllGear() async {
    return await _storage.getGear();
  }

  /// Get gear filtered by category
  Future<List<GearModel>> getGearByCategory(String category) async {
    final gear = await getAllGear();
    return gear.where((g) => g.category == category).toList();
  }

  /// Get gear sorted by condition (best first)
  Future<List<GearModel>> getGearByCondition() async {
    final gear = await getAllGear();
    gear.sort((a, b) => b.conditionPercentage.compareTo(a.conditionPercentage));
    return gear;
  }

  /// Get gear used on last catch
  Future<List<GearModel>> getRecentlyUsedGear() async {
    final gear = await getAllGear();
    return gear.where((g) => g.usedOnLastCatch).toList();
  }

  /// Get gear by ID
  Future<GearModel?> getGearById(String id) async {
    final gear = await getAllGear();
    try {
      return gear.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new gear
  Future<void> addGear(GearModel gearItem) async {
    await _storage.addGear(gearItem);
  }

  /// Update existing gear
  Future<void> updateGear(GearModel gearItem) async {
    await _storage.updateGear(gearItem);
  }

  /// Delete gear
  Future<void> deleteGear(String id) async {
    await _storage.deleteGear(id);
  }

  /// Mark gear as used on last catch
  Future<void> markAsUsed(String id) async {
    final gear = await getGearById(id);
    if (gear != null) {
      // First, unmark all other gear
      final allGear = await getAllGear();
      for (var item in allGear) {
        if (item.usedOnLastCatch) {
          final updated = item.copyWith(usedOnLastCatch: false);
          await updateGear(updated);
        }
      }
      
      // Then mark this gear as used
      final updated = gear.copyWith(usedOnLastCatch: true);
      await updateGear(updated);
    }
  }

  /// Get total gear count
  Future<int> getTotalCount() async {
    final gear = await getAllGear();
    return gear.length;
  }

  /// Get gear count by category
  Future<Map<String, int>> getGearCountByCategory() async {
    final gear = await getAllGear();
    final Map<String, int> counts = {};
    
    for (var item in gear) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }
    
    return counts;
  }

  /// Get all unique categories
  Future<List<String>> getUniqueCategories() async {
    final gear = await getAllGear();
    final categories = gear.map((g) => g.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Get all unique brands
  Future<List<String>> getUniqueBrands() async {
    final gear = await getAllGear();
    final brands = gear.map((g) => g.brand).where((b) => b.isNotEmpty).toSet().toList();
    brands.sort();
    return brands;
  }

  /// Search gear
  Future<List<GearModel>> searchGear(String query) async {
    final gear = await getAllGear();
    final lowerQuery = query.toLowerCase();
    
    return gear.where((g) {
      return g.name.toLowerCase().contains(lowerQuery) ||
             g.brand.toLowerCase().contains(lowerQuery) ||
             g.category.toLowerCase().contains(lowerQuery) ||
             g.notes.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get gear needing maintenance (Poor or Fair condition)
  Future<List<GearModel>> getGearNeedingMaintenance() async {
    final gear = await getAllGear();
    return gear.where((g) => 
      g.condition.toLowerCase() == 'poor' || 
      g.condition.toLowerCase() == 'fair'
    ).toList();
  }
}
