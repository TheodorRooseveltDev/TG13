import 'package:flutter/foundation.dart';
import '../data/models/spot_model.dart';
import '../data/repositories/spot_repository.dart';
import '../data/database/local_storage.dart';
import '../core/constants/app_constants.dart';

/// Provider for managing fishing spots (100% offline)
class SpotProvider extends ChangeNotifier {
  final SpotRepository _repository = SpotRepository();
  final LocalStorage _storage = LocalStorage.instance;

  List<SpotModel> _spots = [];
  bool _isLoading = false;
  String? _error;

  List<SpotModel> get spots => _spots;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSpots => _spots.isNotEmpty;

  Future<void> loadSpots() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _spots = await _repository.getSpotsByName();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSpot(SpotModel spot) async {
    try {
      await _repository.addSpot(spot);
      await _storage.addXP(AppConstants.xpAddSpot);
      await loadSpots();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateSpot(SpotModel spot) async {
    try {
      await _repository.updateSpot(spot);
      await loadSpots();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteSpot(String id) async {
    try {
      await _repository.deleteSpot(id);
      await loadSpots();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<SpotModel> getSpotsByWaterType(String waterType) {
    return _spots.where((s) => s.waterType == waterType).toList();
  }

  List<SpotModel> searchSpots(String query) {
    final lowerQuery = query.toLowerCase();
    return _spots.where((s) {
      return s.name.toLowerCase().contains(lowerQuery) ||
             s.waterType.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
