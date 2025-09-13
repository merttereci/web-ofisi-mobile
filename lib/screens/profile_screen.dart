import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profilim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
        automaticallyImplyLeading: false, // geri butonu gizleme
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ayarlar özelliği yakında eklenecek'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            icon: Icon(Icons.settings_outlined, color: Colors.grey[600]),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isLoggedIn) {
            return const Center(
              child: Text('Kullanıcı bilgisi bulunamadı'),
            );
          }

          final user = userProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // kullanıcı profil kartı
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[600],
                        child: Text(
                          userProvider.userInitials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // kullanıcı adı
                      Text(
                        userProvider.userFullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // email
                      Text(
                        user.email ?? 'E-posta bulunamadı',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // telefon
                      if (user.telefon != null)
                        Text(
                          user.telefon!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _buildMenuSection([
                  _MenuItemData(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Siparişlerim',
                    subtitle: 'Geçmiş siparişlerinizi görün',
                    onTap: () => _showComingSoon(context, 'Siparişlerim'),
                  ),
                  _MenuItemData(
                    icon: Icons.favorite_outline,
                    title: 'Favorilerim',
                    subtitle: 'Beğendiğiniz ürünler',
                    onTap: () => _showComingSoon(context, 'Favorilerim'),
                  ),
                  _MenuItemData(
                    icon: Icons.location_on_outlined,
                    title: 'Adreslerim',
                    subtitle: 'Teslimat adreslerinizi yönetin',
                    onTap: () => _showComingSoon(context, 'Adreslerim'),
                  ),
                ]),

                const SizedBox(height: 20),

                _buildMenuSection([
                  _MenuItemData(
                    icon: Icons.edit_outlined,
                    title: 'Profili Düzenle',
                    subtitle: 'Kişisel bilgilerinizi güncelleyin',
                    onTap: () => _showComingSoon(context, 'Profil Düzenleme'),
                  ),
                  _MenuItemData(
                    icon: Icons.security_outlined,
                    title: 'Güvenlik',
                    subtitle: 'Şifre ve güvenlik ayarları',
                    onTap: () => _showComingSoon(context, 'Güvenlik Ayarları'),
                  ),
                  _MenuItemData(
                    icon: Icons.help_outline,
                    title: 'Yardım',
                    subtitle: 'Sıkça sorulan sorular',
                    onTap: () => _showComingSoon(context, 'Yardım'),
                  ),
                ]),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showLogoutDialog(context, userProvider),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red[600]),
                            const SizedBox(width: 16),
                            Text(
                              'Çıkış Yap',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red[600],
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.red[400]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuItemData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) => _buildMenuItem(item)).toList(),
      ),
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(item.icon, color: Colors.grey[600]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature özelliği yakında eklenecek'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text(
            'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await userProvider.logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Başarıyla çıkış yapıldı'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
