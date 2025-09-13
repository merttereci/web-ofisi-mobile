import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = []; // Tüm ürünler (ham veri)
  List<Product> _filteredProducts =
      []; // Filtrelenmiş ürünler (arama/kategoriye göre)
  List<Product> _displayedProducts = []; // Sadece ekranda gösterilecek ürünler
  bool _isLoading = false;
  String _errorMessage = ''; // Hata varsa mesaj burada
  String _searchQuery = '';
  String? _selectedCategory; // Seçili kategori (yoksa null)

  static const int _itemsPerPage =
      16; // Her sayfada istediğimiz kadar gösterbilmek için sonradan ayarlanabilir tecrihe göre
  int _currentPage = 0;

  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get displayedProducts => _displayedProducts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  int get totalPages => (_filteredProducts.length / _itemsPerPage).ceil();
  int get itemsPerPage => _itemsPerPage;
  String? get selectedCategory => _selectedCategory;

  // Her ürünün kategori listesindeki tüm kategorileri toplayıp , kategoriler sekmesi oluşturmak için, ileride veritabanından alınabilir.
  List<String> get availableCategories {
    final Set<String> categories = {};
    for (var product in _allProducts) {
      categories.addAll(product.category);
    }
    return categories.toList()..sort(); // Alfabetik
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _updateDisplayedProducts() {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex =
        (startIndex + _itemsPerPage).clamp(0, _filteredProducts.length);
    _displayedProducts = _filteredProducts.sublist(startIndex, endIndex);
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _setError('');

    try {
      final loadedProducts = await ProductService.fetchProducts();
      _allProducts = loadedProducts;
      _applyFilters();
      _currentPage = 0;
      _updateDisplayedProducts();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    _currentPage = 0;
    _updateDisplayedProducts();
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    _currentPage = 0;
    _updateDisplayedProducts();
  }

  void _applyFilters() {
    List<Product> tempProducts = _allProducts;

    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        final categoryMatches = product.category
            .any((cat) => cat.toLowerCase().contains(_searchQuery));
        return product.name.toLowerCase().contains(_searchQuery) ||
            categoryMatches || // Kategori listesinde arama
            product.code.toLowerCase().contains(_searchQuery) ||
            product.coding.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (_selectedCategory != null && _selectedCategory != 'Tümü') {
      tempProducts = tempProducts.where((product) {
        return product.category.contains(_selectedCategory);
      }).toList();
    }

    _filteredProducts = tempProducts;
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
      _updateDisplayedProducts();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    _currentPage = 0;
    _updateDisplayedProducts();
  }
}
