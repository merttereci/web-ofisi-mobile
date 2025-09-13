import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class CompactSearchWidget extends StatefulWidget {
  final VoidCallback? onShowCategoryModal;

  const CompactSearchWidget({Key? key, this.onShowCategoryModal})
      : super(key: key);

  @override
  _CompactSearchWidgetState createState() => _CompactSearchWidgetState();
}

class _CompactSearchWidgetState extends State<CompactSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: Colors.grey[50],
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      provider.searchProducts(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Ürün ara...',
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 14),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey[600], size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  color: Colors.grey[600], size: 18),
                              onPressed: () {
                                _searchController.clear();
                                provider.clearSearch();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _showCategoryModal(context),
                  child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: provider.selectedCategory != null
                          ? const Color(0xFF667eea).withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: provider.selectedCategory != null
                            ? const Color(0xFF667eea)
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune,
                          size: 16,
                          color: provider.selectedCategory != null
                              ? const Color(0xFF667eea)
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            provider.selectedCategory ?? 'Kategori',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: provider.selectedCategory != null
                                  ? const Color(0xFF667eea)
                                  : Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: provider.selectedCategory != null
                              ? const Color(0xFF667eea)
                              : Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryModal(BuildContext context) {
    if (widget.onShowCategoryModal != null) {
      widget.onShowCategoryModal!();
    } else {
      // Fallback modal
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: const Text('Modal callback çalışmıyor'),
        ),
      );
    }
  }
}
