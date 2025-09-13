import 'dart:convert';
import 'package:http/http.dart' as http;

class MockApiService {
  // Android emulator için 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Gerçekte burası değişecek
  // mesela ,  static const String baseUrl = 'https://yourdomain.com/api'; gibi

  // ====== USER OPERATIONS ======

  // Kullanıcı girişi
  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    try {
      // JSON Server query format: ?field=value&field2=value2
      final response = await http.get(
        Uri.parse('$baseUrl/uyeler?email=$email&sifre=$password'),
      );

      print('Login request URL: $baseUrl/uyeler?email=$email&sifre=$password');
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        print('Found users: ${users.length}');
        if (users.isNotEmpty) {
          return users.first as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Login exception: $e');
      throw Exception('Login failed: $e');
    }
  }

  // Kullanıcı kaydı
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    try {
      userData['created_at'] = DateTime.now().toIso8601String();
      userData['updated_at'] = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse('$baseUrl/uyeler'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Kullanıcı profili güncelle
  static Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    try {
      userData['updated_at'] = DateTime.now().toIso8601String();

      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Update failed');
      }
    } catch (e) {
      throw Exception('Update error: $e');
    }
  }

  // ====== FAVORITES OPERATIONS ======

  // Kullanıcının favorilerini getir (scriptler tablosuna göre)
  static Future<List<int>> getUserFavorites(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> favorites = jsonDecode(response.body);
        return favorites.map((fav) => fav['script_id'] as int).toList();
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Favorites error: $e');
    }
  }

  // Favori ekle (script_id ile)
  static Future<void> addToFavorites(int userId, int scriptId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'script_id': scriptId,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add favorite');
      }
    } catch (e) {
      throw Exception('Add favorite error: $e');
    }
  }

  // Favori sil
  static Future<void> removeFromFavorites(int userId, int scriptId) async {
    try {
      // Önce favori ID'sini bul
      final response = await http.get(
        Uri.parse('$baseUrl/favorites?user_id=$userId&script_id=$scriptId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> favorites = jsonDecode(response.body);
        if (favorites.isNotEmpty) {
          int favoriteId = favorites.first['id'];

          final deleteResponse = await http.delete(
            Uri.parse('$baseUrl/favorites/$favoriteId'),
          );

          if (deleteResponse.statusCode != 200) {
            throw Exception('Failed to remove favorite');
          }
        }
      }
    } catch (e) {
      throw Exception('Remove favorite error: $e');
    }
  }

  // ====== SCRIPTLER OPERATIONS ======

  // Tüm scriptleri getir
  static Future<List<Map<String, dynamic>>> getAllScripts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/scriptler'));

      if (response.statusCode == 200) {
        List<dynamic> scripts = jsonDecode(response.body);
        return scripts.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load scripts');
      }
    } catch (e) {
      throw Exception('Scripts error: $e');
    }
  }

  // Script detayını getir
  static Future<Map<String, dynamic>?> getScriptById(int scriptId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/scriptler/$scriptId'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Script detail error: $e');
    }
  }

  // ====== KATEGORILER OPERATIONS ======

  // Tüm kategorileri getir
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kategoriler'));

      if (response.statusCode == 200) {
        List<dynamic> categories = jsonDecode(response.body);
        return categories.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Categories error: $e');
    }
  }

  // ====== ORDER OPERATIONS ======

  // Sipariş oluştur
  static Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> orderData) async {
    try {
      orderData['created_at'] = DateTime.now().toIso8601String();
      orderData['updated_at'] = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse('$baseUrl/siparisler'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Order creation error: $e');
    }
  }

  // Kullanıcının siparişlerini getir
  static Future<List<Map<String, dynamic>>> getUserOrders(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/siparisler?uyeid=$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body);
        return orders.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Orders error: $e');
    }
  }

  // Sipariş durumunu güncelle
  static Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/siparisler/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      throw Exception('Update order error: $e');
    }
  }

// ====== HOSTING ORDERS OPERATIONS ======

// Hosting siparişi oluştur
  static Future<Map<String, dynamic>> createHostingOrder(
      Map<String, dynamic> hostingOrderData) async {
    try {
      hostingOrderData['created_at'] = DateTime.now().toIso8601String();
      hostingOrderData['updated_at'] = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse('$baseUrl/hosting_siparisler'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(hostingOrderData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create hosting order');
      }
    } catch (e) {
      throw Exception('Hosting order creation error: $e');
    }
  }

// Kullanıcının hosting siparişlerini getir
  static Future<List<Map<String, dynamic>>> getUserHostingOrders(
      int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hosting_siparisler?uyeid=$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body);
        return orders.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load hosting orders');
      }
    } catch (e) {
      throw Exception('Hosting orders error: $e');
    }
  }

// Hosting sipariş durumunu güncelle
  static Future<void> updateHostingOrderStatus(int orderId, int status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/hosting_siparisler/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'durum': status, // hosting_siparisler tablosunda "durum" field'ı
          'updated_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update hosting order status');
      }
    } catch (e) {
      throw Exception('Update hosting order error: $e');
    }
  }

// Hosting sipariş detayını getir
  static Future<Map<String, dynamic>?> getHostingOrderById(int orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hosting_siparisler/$orderId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Hosting order detail error: $e');
    }
  }
  // ====== SUPPORT OPERATIONS ======

  // Destek talebi oluştur
  static Future<Map<String, dynamic>> createSupportTicket(
      Map<String, dynamic> ticketData) async {
    try {
      ticketData['created_at'] = DateTime.now().toIso8601String();
      ticketData['updated_at'] = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse('$baseUrl/destek'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ticketData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create support ticket');
      }
    } catch (e) {
      throw Exception('  ticket error: $e');
    }
  }
}
