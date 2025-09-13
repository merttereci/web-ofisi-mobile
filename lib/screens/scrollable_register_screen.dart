import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/register_form_data.dart';
import '../models/tables/uyeler.dart';
import '../providers/user_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ScrollableRegisterScreen extends StatefulWidget {
  const ScrollableRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ScrollableRegisterScreen> createState() =>
      _ScrollableRegisterScreenState();
}

class _ScrollableRegisterScreenState extends State<ScrollableRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final RegisterFormData _formData = RegisterFormData();

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _firmaAdiController = TextEditingController();
  final TextEditingController _vergiNoController = TextEditingController();
  final TextEditingController _vergiDairesiController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // il ilçe data  asset jsondan
  Map<String, List<String>> _ilIlceData = {};

  String? _selectedIl;
  String? _selectedIlce;

  @override
  void initState() {
    super.initState();
    _loadCitiesData();
  }

  Future<void> _loadCitiesData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/cities.json');
      final List<dynamic> data = json.decode(response);

      final Map<String, List<String>> citiesMap = {};

      for (var city in data) {
        String cityName = city['text'];
        List<String> districts = [];

        for (var district in city['districts']) {
          districts.add(district['text']);
        }

        citiesMap[cityName] = districts;
      }

      setState(() {
        _ilIlceData = citiesMap;
      });
    } catch (e) {
      print('Şehir verileri yüklenemedi: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _adController.dispose();
    _soyadController.dispose();
    _adresController.dispose();
    _tcController.dispose();
    _firmaAdiController.dispose();
    _vergiNoController.dispose();
    _vergiDairesiController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  void _onIlChanged(String? il) {
    setState(() {
      _selectedIl = il;
      _selectedIlce = null; // İl değiştiğinde ilçeyi sıfırla
      _formData.il = il ?? '';
      _formData.ilce = '';
    });
  }

  void _onIlceChanged(String? ilce) {
    setState(() {
      _selectedIlce = ilce;
      _formData.ilce = ilce ?? '';
    });
  }

  void _updateFormData() {
    _formData.ad = _adController.text;
    _formData.soyad = _soyadController.text;
    _formData.adres = _adresController.text;
    _formData.tc = _tcController.text;
    _formData.firmaadi = _firmaAdiController.text;
    _formData.vergino = _vergiNoController.text;
    _formData.vergidairesi = _vergiDairesiController.text;
    _formData.email = _emailController.text;
    _formData.telefon = _telefonController.text;
    _formData.sifre = _sifreController.text;
    _formData.sifreTekrar = _sifreTekrarController.text;
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _kayitOl() async {
    if (_formKey.currentState!.validate()) {
      _updateFormData();

      if (_formData.sifre != _formData.sifreTekrar) {
        _showSnackBar('Şifreler eşleşmiyor.');
        return;
      }

      if (!_formData.sozlesmeKabul) {
        _showSnackBar('Hizmet sözleşmesini kabul etmelisiniz.');
        return;
      }

      final userData = _formData.toTabloUyelerData();
      final newUser = TabloUyeler(
        id: 0, // Mock API tarafından atanacak zaten
        ad: userData['ad'],
        soyad: userData['soyad'],
        email: userData['email'],
        telefon: userData['telefon'],
        sifre: userData['sifre'],
        il: userData['il'],
        ilce: userData['ilce'],
        adres: userData['adres'],
        tc: userData['tc'],
        firmaadi: userData['firmaadi'],
        vergino: userData['vergino'],
        vergidairesi: userData['vergidairesi'],
        kampanya_eposta: userData['kampanya_eposta'],
        kampanya_sms: userData['kampanya_sms'],
        vatandas: userData['vatandas'],
        statu: 0,
        durum: 1,
      );

      final userProvider = context.read<UserProvider>();
      final result = await userProvider.register(newUser);

      if (result['success']) {
        _showSnackBar(
          'Kayıt başarılı! Hoş geldiniz ${userProvider.userFullName}!',
          isError: false,
        );
        Navigator.of(context).pop();
      } else {
        _showSnackBar(result['message'] ?? 'Kayıt işlemi başarısız.');
      }
    } else {
      _scrollToTop();
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.red[400] : Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Hesap Oluştur',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountTypeSection(),
              const SizedBox(height: 32),
              _buildPersonalInfoSection(),
              const SizedBox(height: 32),
              _buildBillingInfoSection(),
              const SizedBox(height: 32),
              _buildMembershipInfoSection(),
              const SizedBox(height: 32),
              _buildContractsSection(),
              const SizedBox(height: 40),
              _buildRegisterButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeSection() {
    return _buildSection(
      title: 'Hesap Tipi',
      icon: Icons.account_circle_outlined,
      child: Row(
        children: [
          Expanded(
            child: _buildAccountTypeCard(
              title: 'Bireysel',
              icon: Icons.person_outline,
              isSelected: !_formData.isCompany,
              onTap: () => setState(() => _formData.isCompany = false),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildAccountTypeCard(
              title: 'Kurumsal',
              icon: Icons.business_outlined,
              isSelected: _formData.isCompany,
              onTap: () => setState(() => _formData.isCompany = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF667eea).withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF667eea) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF667eea) : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF667eea) : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF667eea) : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF667eea),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Kişisel Bilgiler',
      icon: Icons.person_outline,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: _adController,
                  label: 'Ad',
                  icon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Ad zorunludur' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: _soyadController,
                  label: 'Soyad',
                  icon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Soyad zorunludur' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingInfoSection() {
    return _buildSection(
      title: 'Fatura Bilgileri',
      icon: Icons.receipt_outlined,
      child: Column(
        children: [
          _buildDropdownField(
            label: 'İl',
            icon: Icons.location_on_outlined,
            value: _selectedIl,
            items: _ilIlceData.keys.toList(),
            onChanged: _onIlChanged,
            validator: (value) => value == null ? 'İl seçiniz' : null,
          ),
          const SizedBox(height: 20),
          _buildDropdownField(
            label: 'İlçe',
            icon: Icons.location_city_outlined,
            value: _selectedIlce,
            items: _selectedIl != null ? _ilIlceData[_selectedIl!] ?? [] : [],
            onChanged: _onIlceChanged,
            enabled: _selectedIl != null,
            validator: (value) => value == null ? 'İlçe seçiniz' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _adresController,
            label: 'Adres',
            icon: Icons.home_outlined,
            maxLines: 3,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Adres zorunludur' : null,
          ),
          const SizedBox(height: 20),
          if (!_formData.isCompany) ...[
            _buildModernTextField(
              controller: _tcController,
              label: 'TC Kimlik No',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
              maxLength: 11,
              enabled: _formData.tcVatandasi,
              validator: _formData.tcVatandasi
                  ? (value) {
                      if (value?.isEmpty ?? true)
                        return 'TC Kimlik No zorunludur';
                      if (value!.length != 11)
                        return 'TC Kimlik No 11 haneli olmalıdır';
                      return null;
                    }
                  : null,
              helperText: 'Fatura kesilebilmek için zorunludur',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: !_formData.tcVatandasi,
                  onChanged: (value) {
                    setState(() {
                      _formData.tcVatandasi = !(value ?? false);
                      if (!_formData.tcVatandasi) {
                        _tcController.clear();
                      }
                    });
                  },
                  activeColor: const Color(0xFF667eea),
                ),
                const Text('TC vatandaşı değilim'),
              ],
            ),
          ],
          if (_formData.isCompany) ...[
            _buildModernTextField(
              controller: _firmaAdiController,
              label: 'Firma Adı / Ünvanı',
              icon: Icons.business_outlined,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Firma adı zorunludur' : null,
            ),
            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _vergiNoController,
              label: 'Vergi No',
              icon: Icons.receipt_long_outlined,
              keyboardType: TextInputType.number,
              maxLength: 10,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Vergi no zorunludur' : null,
              helperText: 'Fatura kesilebilmek için zorunludur',
            ),
            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _vergiDairesiController,
              label: 'Vergi Dairesi',
              icon: Icons.account_balance_outlined,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Vergi dairesi zorunludur' : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMembershipInfoSection() {
    return _buildSection(
      title: 'Üyelik Bilgileri',
      icon: Icons.account_box_outlined,
      child: Column(
        children: [
          _buildModernTextField(
            controller: _emailController,
            label: 'E-posta',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'E-posta zorunludur';
              if (!value!.contains('@')) return 'Geçerli bir e-posta girin';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _telefonController,
            label: 'GSM No',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            prefixText: '+90 ',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Telefon numarası zorunludur' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _sifreController,
            label: 'Şifre Oluştur',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Şifre zorunludur';
              if (value!.length < 6) return 'Şifre en az 6 karakter olmalıdır';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _sifreTekrarController,
            label: 'Şifre Tekrar',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () {
              setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Şifre tekrarı zorunludur';
              if (value != _sifreController.text) return 'Şifreler eşleşmiyor';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContractsSection() {
    return _buildSection(
      title: 'Sözleşmeler',
      icon: Icons.gavel_outlined,
      child: Column(
        children: [
          _buildCheckboxTile(
            title: 'Hizmet Sözleşmesi ve Gizlilik Sözleşmesini kabul ediyorum',
            subtitle: 'Bu alan zorunludur',
            value: _formData.sozlesmeKabul,
            onChanged: (value) =>
                setState(() => _formData.sozlesmeKabul = value ?? false),
            isRequired: true,
            onTitleTap: () {
              _showSnackBar('Sözleşme metni gösterimi henüz aktif değil.',
                  isError: false);
            },
          ),
          _buildCheckboxTile(
            title: 'Kampanya, tanıtım ve duyuruları e-posta olarak gönder',
            value: _formData.emailKampanya,
            onChanged: (value) =>
                setState(() => _formData.emailKampanya = value ?? false),
            highlighted: true,
          ),
          _buildCheckboxTile(
            title: 'Kampanya, tanıtım ve duyuruları SMS olarak gönder',
            value: _formData.smsKampanya,
            onChanged: (value) =>
                setState(() => _formData.smsKampanya = value ?? false),
            highlighted: true,
          ),
          _buildCheckboxTile(
            title: 'Push bildirimlerini aç',
            subtitle: 'Uygulama bildirimleri',
            value: _formData.pushBildirim,
            onChanged: (value) =>
                setState(() => _formData.pushBildirim = value ?? false),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isRequired = false,
    bool highlighted = false,
    VoidCallback? onTitleTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFFFF3CD) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRequired && !value
              ? Colors.red[300]!
              : highlighted
                  ? const Color(0xFFFFE066)
                  : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF667eea),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTitleTap,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: onTitleTap != null
                          ? const Color(0xFF667eea)
                          : Colors.grey[800],
                      decoration:
                          onTitleTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isRequired && !value
                          ? Colors.red[600]
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: userProvider.isLoading ? null : _kayitOl,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: userProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF667eea),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
    bool enabled = true,
    String? helperText,
    String? prefixText,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines,
        enabled: enabled,
        textCapitalization: textCapitalization,
        style: TextStyle(
          fontSize: 16,
          color: enabled ? const Color(0xFF2D3748) : Colors.grey[500],
        ),
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixText: prefixText,
          prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          filled: true,
          fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: '', // maxLength counterını gizle
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          filled: true,
          fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }
}
