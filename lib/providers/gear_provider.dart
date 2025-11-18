import 'package:flutter/foundation.dart';
import '../data/models/gear_model.dart';
import '../data/repositories/gear_repository.dart';
import '../data/database/local_storage.dart';
import '../core/constants/app_constants.dart';

/// Provider for managing fishing gear (100% offline)
class GearProvider extends ChangeNotifier {
  final GearRepository _repository = GearRepository();
  final LocalStorage _storage = LocalStorage.instance;

  List<GearModel> _gear = [];
  bool _isLoading = false;
  String? _error;

  List<GearModel> get gear => _gear;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasGear => _gear.isNotEmpty;

  Future<void> loadGear() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _gear = await _repository.getAllGear();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGear(GearModel gearItem) async {
    try {
      await _repository.addGear(gearItem);
      await _storage.addXP(AppConstants.xpUpdateGear);
      await loadGear();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateGear(GearModel gearItem) async {
    try {
      await _repository.updateGear(gearItem);
      await _storage.addXP(AppConstants.xpUpdateGear);
      await loadGear();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteGear(String id) async {
    try {
      await _repository.deleteGear(id);
      await loadGear();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<GearModel> getGearByCategory(String category) {
    return _gear.where((g) => g.category == category).toList();
  }

  List<GearModel> searchGear(String query) {
    final lowerQuery = query.toLowerCase();
    return _gear.where((g) {
      return g.name.toLowerCase().contains(lowerQuery) ||
             g.brand.toLowerCase().contains(lowerQuery) ||
             g.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
