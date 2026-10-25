# Web Ofisi Mobile

[English](README.md) | **Türkçe**

Hazır web yazılımları (scriptler) ve hosting paketleri satışı için, 30 günlük staj projesi olarak tek başına geliştirilmiş bir Flutter e-ticaret uygulaması. XML'den 158 web scripti listeler, kullanıcı hesapları, favoriler, sepet, sipariş ve destek taleplerini json-server ile simüle edilen bir REST API üzerinden yönetir.

<table>
  <tr>
    <td align="center"><img src="screenshots/01_auth_screen.png" width="180"><br>Giriş</td>
    <td align="center"><img src="screenshots/06_home_screen.png" width="180"><br>Ana sayfa</td>
    <td align="center"><img src="screenshots/07_product_list_screen.png" width="180"><br>Ürün listesi</td>
    <td align="center"><img src="screenshots/10_product_detail_screen.png" width="180"><br>Ürün detayı</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/12_hosting_screen.png" width="180"><br>Hosting paketleri</td>
    <td align="center"><img src="screenshots/18_support_screen.png" width="180"><br>Yeni destek talebi</td>
    <td align="center"><img src="screenshots/23_cart_screen.png" width="180"><br>Sepet</td>
    <td align="center"><img src="screenshots/25_checkout_screen.png" width="180"><br>Sipariş</td>
  </tr>
</table>

## Kullanılan Teknolojiler

- Flutter ve Dart
- State yönetimi için Provider
- Mock REST backend olarak json-server (db.json)
- Ürün kataloğu için XML parsing
- Oturum kalıcılığı için SharedPreferences

## Özellikler

### Hesaplar
- Form doğrulamalı giriş ve çok adımlı kayıt, aynı e-posta ile tekrar kayıt kontrolü
- Uygulama yeniden açıldığında korunan token tabanlı oturum
- Profil görüntüleme ve güncelleme

### Ürünler
- XML'den yüklenen 158 web scripti
- Arama, kategori filtreleme ve sayfalama
- Görsel galerili ve demo butonlu ürün detay sayfası
- Tanıtım kartları ve yatay ürün şeridi içeren ana sayfa

### Sepet ve Sipariş
- Scriptler ve hosting paketleri aynı sepette
- Hosting paketleri, gerekli bilgiler girilince butonu aktifleşen bir dialog ile sepete ekleniyor
- Sepet sadece ürün ID'lerini bir Set içinde tutuyor, ekle/çıkar toggle mantığıyla çalışıyor
- Ara toplam, yüzde 20 KDV ve genel toplam ayrı ayrı gösteriliyor
- Siparişi mock veritabanına yazan sipariş akışı (prototip, gerçek ödeme yok)

### Favoriler
- Mock API üzerinden kullanıcıya özel favori ekleme ve çıkarma

### Destek
- 11 açılır sorudan oluşan SSS, YouTube eğitim videosu linkleri ve indirme linkleri
- Kullanıcı bilgilerinin otomatik dolduğu, departman, öncelik ve hizmet seçimli destek talebi formu
- Kamera veya galeriden sıkıştırılmış fotoğraf ekleme (maksimum genişlik 1024, kalite 80)
- Talepler db.json dosyasına yazılıyor

### Navigasyon
- 5 sekmeli alt menü (Ana Sayfa, Ürünler, Hosting, Destek, Profil)
- IndexedStack ile sekme geçişlerinde durum korunuyor
- Destek bölümü SSS, Yeni Talep ve Geçmiş Talepler sekmelerine ayrılıyor

## Mimari

Uygulama iki farklı veri kaynağı kullanıyor.

- **XML** ürün kataloğu için
- **json-server** kullanıcılar, siparişler, favoriler, destek talepleri ve diğer tablolar için
- **SharedPreferences** oturum ve önbellek için

State yönetimi Provider ile, MultiProvider yapısı üzerinden yapılıyor (ProductProvider, UserProvider, CartProvider, FavoritesProvider). Hem sepet hem ürün verisine ihtiyaç duyan ekranlarda Consumer2 kullanılıyor.

`lib/models/tables` altındaki modeller gerçek backend veritabanının tablolarıyla birebir uyumlu (üyeler, scriptler, kategoriler, siparişler, krediler, destek, hosting siparişleri, indirim kuponları, banka hesapları, slider). REST endpoint'leri de aynı yapıyı izlediği için production API'ye geçiş, temelde `MockApiService` içindeki `baseUrl` değişikliğiyle yapılacak şekilde tasarlandı.

```dart
// Geliştirme (Android emülatör)
static const String baseUrl = 'http://10.0.2.2:3000';

// Production
static const String baseUrl = 'https://yourdomain.com/api';
```

### Proje Yapısı

```
lib/
├── main.dart        # Uygulama girişi ve Provider yapılandırması
├── models/          # Veri modelleri, tables/ backend şemasıyla uyumlu
├── providers/       # Sepet, ürün, favori ve kullanıcı state'i
├── screens/         # Ekranlar ve 5 ana sekme
├── services/        # MockApiService, AuthService, ProductService (XML), FaqService
└── widgets/         # Tekrar kullanılabilir arayüz bileşenleri
assets/data/         # Türkiye il/ilçe verileri ve SSS verisi
db.json              # json-server veritabanı
```

## Kurulum

Flutter SDK ve Node.js gerekli.

```bash
# Bağımlılıkları yükle
flutter pub get

# Mock backend'i 3000 portunda başlat
npx json-server db.json --port 3000

# Uygulamayı çalıştır
flutter run
```

Varsayılan `baseUrl` (10.0.2.2) Android emülatörden ana makineye erişim içindir. Farklı platform veya fiziksel cihaz için `lib/services/mock_api_service.dart` içinden değiştirilebilir.

## Bilinen Sınırlamalar

- Eklenen fotoğraflar henüz kaydedilmiyor. Talebe sadece yer tutucu bir metin yazılıyor.
- Geçmiş taleplerin listelenmesi ve talep durumunun güncellenmesi servis katmanında henüz yok.
- Ödeme entegrasyonu yok. Sipariş akışı, siparişi db.json dosyasına yazan bir simülasyon.
- Backend mock. Production PHP API'ye henüz bağlanılmadı.

## Olası Sonraki Adımlar

- Production API'ye geçiş
- Ödeme sistemi entegrasyonu
- Mevcut siparişler tablosuyla sipariş takibi
- Ürün karşılaştırma
- Progressive web app desteği

## Tüm Ekran Görüntüleri

<details>
<summary>Tümünü göster</summary>

<table>
  <tr>
    <td align="center"><img src="screenshots/02_register_screen.png" width="180"><br>Kayıt, adım 1</td>
    <td align="center"><img src="screenshots/03_register_screen.png" width="180"><br>Kayıt, adım 2</td>
    <td align="center"><img src="screenshots/04_register_screen.png" width="180"><br>Kayıt, adım 3</td>
    <td align="center"><img src="screenshots/05_home_screen.png" width="180"><br>Ana sayfa, boş</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/08_product_list_screen.png" width="180"><br>Kategori seçici</td>
    <td align="center"><img src="screenshots/09_product_list_screen.png" width="180"><br>Filtrelenmiş liste</td>
    <td align="center"><img src="screenshots/11_product_detail_screen.png" width="180"><br>Ürün detayı, butonlar</td>
    <td align="center"><img src="screenshots/13_hosting_screen.png" width="180"><br>Hosting paketleri</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/14_hosting_screen.png" width="180"><br>Sepete ekleme dialogu</td>
    <td align="center"><img src="screenshots/15_hosting_screen.png" width="180"><br>Dialog, buton aktif</td>
    <td align="center"><img src="screenshots/16_support_screen.png" width="180"><br>SSS</td>
    <td align="center"><img src="screenshots/17_support_screen.png" width="180"><br>SSS, açılmış</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/19_support_screen.png" width="180"><br>Yeni talep, devamı</td>
    <td align="center"><img src="screenshots/20_profile_screen.png" width="180"><br>Profil</td>
    <td align="center"><img src="screenshots/21_profile_screen.png" width="180"><br>Çıkış dialogu</td>
    <td align="center"><img src="screenshots/22_favorites_screen.png" width="180"><br>Favoriler</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/24_cart_screen.png" width="180"><br>Sepet, sadece scriptler</td>
    <td align="center"><img src="screenshots/26_checkout_screen.png" width="180"><br>Sipariş, devamı</td>
    <td align="center"><img src="screenshots/27_order_success_screen.png" width="180"><br>Sipariş başarılı</td>
    <td></td>
  </tr>
</table>

</details>

## Teknik Detaylar

<details>
<summary>Teknik detayları göster</summary>

### Tam Dizin Yapısı

```
assets/
├── data/
│   ├── cities.json                 # Türkiye il/ilçe verileri
│   └── faq_data.json               # Sık sorulan sorular verisi
├── launcher/
│   └── icon.png
└── logo/
    └── logo.png
lib/
├── main.dart                          # Ana uygulama dosyası ve Provider yapılandırması
├── models/                            # Veri modelleri
│   ├── tables/                        # Veritabanı tablo modelleri
│   │   ├── banka_hesaplari.dart
│   │   ├── destek_cevaplar.dart
│   │   ├── destek.dart
│   │   ├── hosting_siparisler.dart
│   │   ├── indirim_kuponlari.dart
│   │   ├── kategoriler.dart
│   │   ├── krediler.dart
│   │   ├── scriptler.dart
│   │   ├── siparisler.dart
│   │   ├── slider.dart
│   │   └── uyeler.dart
│   ├── product.dart                   # Ana ürün modeli (XML verisi)
│   ├── hosting_cart_item.dart
│   ├── register_form_data.dart
│   ├── faq_item.dart
│   └── support_ticket_form_data.dart
├── providers/
│   ├── cart_provider.dart             # Sepet state yönetimi (minimal, ID tabanlı)
│   ├── product_provider.dart
│   ├── favorites_provider.dart
│   └── user_provider.dart
├── screens/
│   ├── tabs/
│   │   ├── home_tab.dart
│   │   ├── products_tab.dart
│   │   ├── hosting_tab.dart
│   │   ├── support_tab.dart
│   │   └── profile_tab.dart
│   ├── auth_screen.dart                # Giriş ekranı
│   ├── scrollable_register_screen.dart # Çok adımlı kayıt ekranı
│   ├── cart_screen.dart                # Sepet ekranı (modal)
│   ├── favorites_screen.dart
│   ├── home_screen.dart                # Ana sayfa (AppBar'lı, sepet ve favori)
│   ├── main_screen.dart                # Ana ekran (5 sekmeli navigasyon)
│   ├── product_detail_screen.dart
│   ├── product_list_screen.dart        # Ürün listesi (AppBar'lı, sepet ve favori)
│   ├── hosting_screen.dart
│   ├── support_screen.dart
│   └── profile_screen.dart
├── services/
│   ├── auth_service.dart              # Mock API ile kimlik doğrulama
│   ├── mock_api_service.dart          # json-server HTTP servisi
│   ├── product_service.dart           # Ürün servisi (XML parser)
│   └── faq_service.dart               # SSS veri servisi
└── widgets/
    ├── cart_modal_widget.dart         # Tekrar kullanılabilir sepet modalı
    ├── custom_bottom_navbar.dart      # 5 sekmeli özel alt menü
    ├── flash_card_widget.dart         # Promosyon, haber ve tanıtım kartları
    ├── product_card_v2.dart           # Kompakt ürün kartı (ana sayfa)
    ├── product_details_widgets/
    │   ├── product_demo_buttons.dart
    │   ├── product_description_section.dart
    │   ├── product_detail_row.dart
    │   └── product_image_gallery.dart
    └── product_lists_widgets/
        ├── category_selector_modal.dart
        ├── compact_search_widget.dart # Kompakt arama ve kategori widget'ı
        ├── error_widget.dart
        ├── loading_widget.dart
        ├── pagination_widget.dart
        └── product_card.dart          # Ana ürün kartı (ürünler sayfası)
db.json                                # json-server veritabanı
```

### Servis Katmanı

**MockApiService** (`lib/services/mock_api_service.dart`) json-server ile tüm HTTP iletişimini yönetiyor.

Destek
- `createSupportTicket(ticketData)` yeni destek talebi oluşturur
- `getUserTickets(userId)` kullanıcının taleplerini listeler (planlandı)
- `updateTicketStatus(ticketId, status)` talep durumunu günceller (planlandı)

Kullanıcı
- `loginUser(email, password)`
- `registerUser(userData)`
- `updateUser(userId, userData)`

Script
- `getAllScripts()`
- `getScriptById(scriptId)`
- `getAllCategories()`

Favoriler
- `getUserFavorites(userId)`
- `addToFavorites(userId, scriptId)`
- `removeFromFavorites(userId, scriptId)`

**FaqService** (`lib/services/faq_service.dart`) SSS verisini asset'ten yüklüyor (`loadFaqItems()`) ve içinde arama yapıyor (`searchFaqItems()`), hata yönetimi ve tip güvenli parsing ile.

**AuthService** (`lib/services/auth_service.dart`) ilk sürümde SharedPreferences ve asset JSON dosyasıyla çalışıyordu, sonra MockApiService üzerinden HTTP isteklerine geçirildi. API'den gelen string ID'leri integer'a çeviriyor ve istek hatalarını yönetiyor.

Giriş akışı

```
userData = await MockApiService.loginUser(email, password)
→ TabloUyeler.fromJson(userData)
→ Token oluşturma
→ SharedPreferences ile kalıcı saklama
```

### db.json Yapısı

Gerçek veritabanı şemasına uygun olarak tasarlandı.

```
{
  "uyeler": [...],              // TabloUyeler
  "scriptler": [...],           // TabloScriptler
  "kategoriler": [...],         // TabloKategoriler
  "siparisler": [...],          // TabloSiparisler
  "favorites": [...],           // user_id, script_id, created_at
  "krediler": [...],            // TabloKrediler
  "destek": [...],              // TabloDestek
  "destek_cevaplar": [...],     // TabloDestekCevaplar
  "hosting_siparisler": [...],  // TabloHostingSiparisler
  "indirim_kuponlari": [...],   // TabloIndirimKuponlari
  "banka_hesaplari": [...],     // TabloBankaHesaplari
  "slider": [...]               // TabloSlider
}
```

### REST Endpoint'leri (json-server tarafından otomatik oluşturulur)

```
GET    /uyeler              # Tüm kullanıcılar
POST   /uyeler              # Yeni kullanıcı
PUT    /uyeler/1            # Kullanıcı güncelle
DELETE /uyeler/1            # Kullanıcı sil

GET    /favorites?user_id=1 # Query parametreleri
POST   /favorites           # Favori ekle
DELETE /favorites/1         # Favori sil
```

</details>
