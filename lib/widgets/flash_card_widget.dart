import 'package:flutter/material.dart';

class FlashCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final IconData icon;

  const FlashCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // İçeriği dikeyde yayar
          crossAxisAlignment:
              CrossAxisAlignment.start, // Tüm içeriği sola hizalar
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // İkon ve metni dikeyde ortalar
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3, // Başlık 2 satıra yayılabilsin diye
                    overflow: TextOverflow.ellipsis, // Fazla metni kesme
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
