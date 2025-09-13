import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDemoButtons extends StatelessWidget {
  final String demoUrl;
  final String adminDemoUrl;

  const ProductDemoButtons({
    Key? key,
    required this.demoUrl,
    required this.adminDemoUrl,
  }) : super(key: key);

  Future<void> _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link bulunamadı.')),
      );
      return;
    }

    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link açılamadı: $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    if (demoUrl.isNotEmpty) {
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(context, demoUrl),
            icon: const Icon(Icons.open_in_new, size: 20),
            label: const Text('Demo Site', style: TextStyle(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              elevation: 3,
            ),
          ),
        ),
      );
    }

    if (adminDemoUrl.isNotEmpty) {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(context, adminDemoUrl),
            icon: const Icon(Icons.admin_panel_settings, size: 20),
            label:
                const Text('Admin Demo Site', style: TextStyle(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              elevation: 3,
            ),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
