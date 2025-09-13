import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class CategorySelectorModal extends StatelessWidget {
  const CategorySelectorModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final List<String> allCategories = [
          'Tümü',
          ...provider.availableCategories
        ];

        return Container(
          height: MediaQuery.of(context).size.height * 0.6, // ekranın %60ı
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Kategori Seçin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final category = allCategories[index];
                    final isSelected = (category == 'Tümü' &&
                            provider.selectedCategory == null) ||
                        (category == provider.selectedCategory);

                    return ListTile(
                      title: Text(category),
                      trailing: isSelected
                          ? Icon(Icons.check, color: Colors.blue[600])
                          : null,
                      onTap: () {
                        final selectedCategory =
                            category == 'Tümü' ? null : category;
                        provider.selectCategory(selectedCategory);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
