import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tables/uyeler.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  TabloUyeler? _currentUser;
  String? _authToken;
  bool _isLoading = false;

  TabloUyeler? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isLoggedIn => _currentUser != null && _authToken != null;
  bool get isLoading => _isLoading;

  // Kullanıcın baş harfleri Avatar için
  String get userInitials {
    if (_currentUser == null) return '';
    String initials = '';
    if (_currentUser!.ad != null && _currentUser!.ad!.isNotEmpty) {
      initials += _currentUser!.ad![0].toUpperCase();
    }
    if (_currentUser!.soyad != null && _currentUser!.soyad!.isNotEmpty) {
      initials += _currentUser!.soyad![0].toUpperCase();
    }
    return initials.isEmpty ? 'U' : initials;
  }

  String get userFullName {
    if (_currentUser == null) return 'Kullanıcı';
    String name = '';
    if (_currentUser!.ad != null) name += _currentUser!.ad!;
    if (_currentUser!.soyad != null) name += ' ${_currentUser!.soyad!}';
    return name.trim().isEmpty ? 'Kullanıcı' : name.trim();
  }

  UserProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setLoading(true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (token != null && userId != null) {
      _authToken = token;

      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        try {
          final userData =
              Map<String, dynamic>.from(Uri.splitQueryString(userJson));

          userData['id'] = int.tryParse(userData['id'] ?? '') ?? userId;
          userData['statu'] = int.tryParse(userData['statu'] ?? '0') ?? 0;
          userData['durum'] = int.tryParse(userData['durum'] ?? '1') ?? 1;

          _currentUser = TabloUyeler.fromJson(userData);

          print('Otomatik giriş yapıldı: ${_currentUser!.email}');
        } catch (e) {
          print('Kullanıcı verisi parse hatası: $e');
          await logout();
        }
      }
    }

    _setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);

    try {
      final result = await AuthService.login(email, password);

      if (result['success']) {
        _authToken = result['token'];
        _currentUser = result['user'];

        print('UserProvider: Login başarılı');
        print('Token: ${result['token']}');
        print(
            'User: ${result['user'].ad} ${result['user'].soyad} (ID: ${result['user'].id})');

        await _saveAuthData();

        notifyListeners();
        _setLoading(false);
        return true;
      }
    } catch (e) {
      print('Login hatası: $e');
    }

    _setLoading(false);
    return false;
  }

  Future<Map<String, dynamic>> register(TabloUyeler newUser) async {
    _setLoading(true);

    try {
      final result = await AuthService.register(newUser);

      if (result['success']) {
        _authToken = result['token'];
        _currentUser = result['user'];

        await _saveAuthData();
        notifyListeners();
      }

      _setLoading(false);
      return result;
    } catch (e) {
      print('Register hatası: $e');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Kayıt işlemi sırasında bir hata oluştu'
      };
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_data');

    // Statei temizle
    _authToken = null;
    _currentUser = null;

    notifyListeners();
    _setLoading(false);
  }

  Future<bool> updateProfile(TabloUyeler updatedUser) async {
    _setLoading(true);

    try {
      _currentUser = updatedUser;
      await _saveAuthData();

      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      print('Profil güncelleme hatası: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    if (_authToken != null) {
      await prefs.setString('auth_token', _authToken!);
    }

    if (_currentUser != null) {
      await prefs.setInt('user_id', _currentUser!.id);

      final userData = {
        'id': _currentUser!.id.toString(),
        'ad': _currentUser!.ad ?? '',
        'soyad': _currentUser!.soyad ?? '',
        'email': _currentUser!.email ?? '',
        'telefon': _currentUser!.telefon ?? '',
        'statu': (_currentUser!.statu ?? 0).toString(),
        'durum': (_currentUser!.durum ?? 1).toString(),
      };

      await prefs.setString('user_data',
          userData.entries.map((e) => '${e.key}=${e.value}').join('&'));
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
