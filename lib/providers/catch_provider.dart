import 'package:flutter/foundation.dart';
import '../data/models/catch_model.dart';
import '../data/repositories/catch_repository.dart';
import '../data/database/local_storage.dart';
import '../core/constants/app_constants.dart';

/// Provider for managing catch state (100% offline)
class CatchProvider extends ChangeNotifier {
  final CatchRepository _repository = CatchRepository();
  final LocalStorage _storage = LocalStorage.instance;

  List<CatchModel> _catches = [];
  bool _isLoading = false;
  String? _error;

  List<CatchModel> get catches => _catches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCatches => _catches.isNotEmpty;

  /// Load all catches
  Future<void> loadCatches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _catches = await _repository.getCatchesByDate();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new catch
  Future<void> addCatch(CatchModel catch_) async {
    try {
      await _repository.addCatch(catch_);
      await _storage.addXP(AppConstants.xpAddCatch);
      await loadCatches();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update catch
  Future<void> updateCatch(CatchModel catch_) async {
    try {
      await _repository.updateCatch(catch_);
      await loadCatches();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete catch
  Future<void> deleteCatch(String id) async {
    try {
      await _repository.deleteCatch(id);
      await loadCatches();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Get last catch
  CatchModel? get lastCatch {
    return _catches.isEmpty ? null : _catches.first;
  }

  /// Get catches by species
  List<CatchModel> getCatchesBySpecies(String species) {
    return _catches.where((c) => c.species == species).toList();
  }

  /// Search catches
  List<CatchModel> searchCatches(String query) {
    final lowerQuery = query.toLowerCase();
    return _catches.where((c) {
      return c.species.toLowerCase().contains(lowerQuery) ||
             c.location.toLowerCase().contains(lowerQuery) ||
             c.notes.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
