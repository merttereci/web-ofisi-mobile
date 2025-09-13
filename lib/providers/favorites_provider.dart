import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/mock_api_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _favoriteIds = <int>{};
  bool _isLoading = false;
  String? _error;

  Set<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoriteCount => _favoriteIds.length;

  Future<void> loadFavorites(int userId) async {
    _setLoading(true);
    try {
      final favoriteScriptIds = await MockApiService.getUserFavorites(userId);
      _favoriteIds.clear();
      _favoriteIds.addAll(favoriteScriptIds);

      await _saveFavoritesToLocal();
      _clearError();
    } catch (e) {
      _setError('Favoriler yüklenirken hata: $e');
      await _loadFavoritesFromLocal();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleFavorite(int userId, int scriptId) async {
    final isCurrentlyFavorite = _favoriteIds.contains(scriptId);

    if (isCurrentlyFavorite) {
      _favoriteIds.remove(scriptId);
    } else {
      _favoriteIds.add(scriptId);
    }
    notifyListeners();

    try {
      if (isCurrentlyFavorite) {
        await MockApiService.removeFromFavorites(userId, scriptId);
      } else {
        await MockApiService.addToFavorites(userId, scriptId);
      }

      await _saveFavoritesToLocal();
      _clearError();
      return true;
    } catch (e) {
      if (isCurrentlyFavorite) {
        _favoriteIds.add(scriptId);
      } else {
        _favoriteIds.remove(scriptId);
      }
      notifyListeners();
      _setError('Favori güncellenirken hata: $e');
      return false;
    }
  }

  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }

  bool isFavorite(int scriptId) {
    return _favoriteIds.contains(scriptId);
  }

  Future<void> _saveFavoritesToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = _favoriteIds.toList();
      await prefs.setString('favorites', json.encode(favoritesList));
    } catch (e) {
      debugPrint('Favoriler local\'e kaydedilirken hata: $e');
    }
  }

  Future<void> _loadFavoritesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString('favorites');

      if (favoritesString != null) {
        final favoritesList = List<int>.from(json.decode(favoritesString));
        _favoriteIds.clear();
        _favoriteIds.addAll(favoritesList);
      }
    } catch (e) {
      debugPrint('Favoriler local\'den yüklenirken hata: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
