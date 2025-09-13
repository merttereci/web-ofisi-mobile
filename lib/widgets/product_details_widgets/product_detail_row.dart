import 'package:flutter/material.dart';

class ProductDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool
      isBoldValue; // Değerin kalın yazılıp yazılmayacağını kontrol etmek için

  const ProductDetailRow({
    Key? key,
    required this.title,
    required this.value,
    this.isBoldValue = false, // Varsayılan olarak kalın değil
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
