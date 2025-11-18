import 'package:flutter/foundation.dart';
import '../data/models/trip_model.dart';
import '../data/repositories/trip_repository.dart';
import '../data/database/local_storage.dart';
import '../core/constants/app_constants.dart';

/// Provider for managing fishing trips (100% offline)
class TripProvider extends ChangeNotifier {
  final TripRepository _repository = TripRepository();
  final LocalStorage _storage = LocalStorage.instance;

  List<TripModel> _trips = [];
  bool _isLoading = false;
  String? _error;

  List<TripModel> get trips => _trips;
  List<TripModel> get upcomingTrips => _trips.where((t) => t.isFuture && !t.isCompleted).toList();
  List<TripModel> get pastTrips => _trips.where((t) => t.isPast).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasTrips => _trips.isNotEmpty;

  Future<void> loadTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _trips = await _repository.getAllTrips();
      _trips.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTrip(TripModel trip) async {
    try {
      await _repository.addTrip(trip);
      await _storage.addXP(AppConstants.xpCompleteTrip);
      await loadTrips();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    try {
      await _repository.updateTrip(trip);
      await loadTrips();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTrip(String id) async {
    try {
      await _repository.deleteTrip(id);
      await loadTrips();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsCompleted(String id) async {
    try {
      await _repository.markAsCompleted(id);
      await loadTrips();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  TripModel? get nextTrip {
    final upcoming = upcomingTrips;
    return upcoming.isEmpty ? null : upcoming.first;
  }
}
