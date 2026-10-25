# Web Ofisi Mobile

[English](README.md) | **Türkçe**

Hazır web yazılımları (script) ve hosting paketleri satan bir Flutter e-ticaret uygulaması. 30 günlük stajım sırasında tek başıma geliştirdim.

Uygulama 158 web scriptini XML'den çekip listeliyor. Kullanıcı hesapları, favoriler, sepet, sipariş ve destek talepleri ise json-server ile taklit edilen bir REST API üzerinden çalışıyor.

<table>
  <tr>
    <td align="center"><img src="screenshots/01_auth_screen.png" width="180"><br>Giriş ekranı</td>
    <td align="center"><img src="screenshots/06_home_screen.png" width="180"><br>Ana sayfa</td>
    <td align="center"><img src="screenshots/07_product_list_screen.png" width="180"><br>Ürün listesi</td>
    <td align="center"><img src="screenshots/10_product_detail_screen.png" width="180"><br>Ürün detayı</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/12_hosting_screen.png" width="180"><br>Hosting paketleri</td>
    <td align="center"><img src="screenshots/18_support_screen.png" width="180"><br>Yeni talep formu</td>
    <td align="center"><img src="screenshots/23_cart_screen.png" width="180"><br>Sepet</td>
    <td align="center"><img src="screenshots/25_checkout_screen.png" width="180"><br>Sipariş ekranı</td>
  </tr>
</table>

## Kullanılan Teknolojiler

- Flutter ve Dart
- Provider (durum yönetimi)
- json-server (deneme amaçlı REST sunucusu, db.json)
- XML ayrıştırma (ürün kataloğu)
- SharedPreferences (oturum bilgisinin cihazda saklanması)

## Özellikler

### Hesap
- Kullanıcı giriş yapabiliyor ya da birkaç adımlık bir formla kayıt olabiliyor. Formlar doğrulanıyor ve kayıtlı bir e-postayla ikinci kez kayıt olunamıyor.
- Oturum token ile tutuluyor, uygulama kapatılıp açıldığında yeniden giriş yapmak gerekmiyor.
- Profil bilgileri görüntülenip güncellenebiliyor.

### Ürünler
- 158 web scripti XML'den yükleniyor.
- Ürünler arasında arama, kategoriye göre filtreleme ve sayfalama yapılabiliyor.
- Ürün detay sayfasında görsel galerisi ve demo butonları bulunuyor.
- Ana sayfada tanıtım kartları ve yana kaydırılan bir ürün şeridi yer alıyor.

### Sepet ve Sipariş
- Scriptler ve hosting paketleri aynı sepete eklenebiliyor.
- Hosting paketi eklerken açılan pencerede gerekli bilgiler girilmeden onay butonu aktif olmuyor.
- Sepette yalnızca ürün ID'leri bir Set içinde tutuluyor. Aynı butona tekrar basmak ürünü sepetten çıkarıyor.
- Ara toplam, yüzde 20 KDV ve genel toplam ayrı ayrı gösteriliyor.
- Sipariş tamamlandığında veritabanına kaydediliyor. Gerçek bir ödeme adımı yok, akış prototip düzeyinde.

### Favoriler
- Her kullanıcı kendi favorilerini ekleyip çıkarabiliyor, favoriler API üzerinden saklanıyor.

### Destek
- 11 sorudan oluşan, açılıp kapanabilen bir SSS bölümü var. Yanında YouTube eğitim videolarına ve indirilebilir dosyalara linkler bulunuyor.
- Destek talebi formunda kullanıcı bilgileri otomatik doluyor, departman, öncelik ve hizmet seçilebiliyor.
- Talebe kameradan ya da galeriden fotoğraf eklenebiliyor. Fotoğraf eklenmeden önce küçültülüyor (en fazla 1024 piksel genişlik, yüzde 80 kalite).
- Gönderilen talepler db.json dosyasına yazılıyor.

### Gezinme
- Alt menüde Ana Sayfa, Ürünler, Hosting, Destek ve Profil olmak üzere 5 sekme var.
- Sekmeler arasında geçiş yapıldığında ekranların durumu korunuyor (IndexedStack).
- Destek bölümü kendi içinde SSS, Yeni Talep ve Geçmiş Talepler sekmelerine ayrılıyor.

## Mimari

Uygulama verileri iki farklı kaynaktan alıyor. Ürün kataloğu XML'den geliyor. Kullanıcılar, siparişler, favoriler, destek talepleri ve diğer tablolar json-server üzerinde duruyor. Oturum bilgisi ve önbellek ise SharedPreferences ile cihazda saklanıyor.

Durum yönetiminde Provider kullanılıyor. ProductProvider, UserProvider, CartProvider ve FavoritesProvider tek bir MultiProvider altında toplanıyor. Hem sepet hem ürün verisine ihtiyaç duyan ekranlarda ikisi Consumer2 ile birlikte dinleniyor.

`lib/models/tables` altındaki modeller, gerçek veritabanındaki tabloların birebir karşılığı (üyeler, scriptler, kategoriler, siparişler, krediler, destek, hosting siparişleri, indirim kuponları, banka hesapları, slider). REST uç noktaları da aynı yapıyı izlediği için gerçek API'ye geçişte esas olarak `MockApiService` içindeki `baseUrl` değerini değiştirmek yetecek şekilde tasarlandı.

```dart
// Geliştirme ortamı (Android emülatör)
static const String baseUrl = 'http://10.0.2.2:3000';

// Canlı ortam
static const String baseUrl = 'https://yourdomain.com/api';
```

### Proje Yapısı

```
lib/
├── main.dart        # Uygulamanın giriş noktası ve Provider kurulumu
├── models/          # Veri modelleri, tables/ klasörü veritabanı şemasının karşılığı
├── providers/       # Sepet, ürün, favori ve kullanıcı durumları
├── screens/         # Ekranlar ve 5 ana sekme
├── services/        # MockApiService, AuthService, ProductService (XML), FaqService
└── widgets/         # Tekrar kullanılan arayüz bileşenleri
assets/data/         # Türkiye il ve ilçe verileri, SSS verisi
db.json              # json-server veritabanı
```

## Kurulum

Bilgisayarda Flutter SDK ve Node.js kurulu olmalı.

```bash
# Bağımlılıkları yükle
flutter pub get

# Deneme sunucusunu 3000 portunda başlat
npx json-server db.json --port 3000

# Uygulamayı çalıştır
flutter run
```

`baseUrl` varsayılan olarak 10.0.2.2 adresine ayarlı. Bu adres, Android emülatörün içinden bilgisayardaki sunucuya ulaşmayı sağlıyor. Başka bir platformda ya da gerçek bir cihazda çalıştırmak için `lib/services/mock_api_service.dart` dosyasındaki adresin değiştirilmesi gerekiyor.

## Bilinen Eksikler

- Destek talebine eklenen fotoğraf henüz kaydedilmiyor, talebe yalnızca fotoğraf eklendiğini belirten bir metin yazılıyor.
- Geçmiş talepleri listeleme ve talep durumunu güncelleme işlemleri servis katmanında henüz yazılmadı.
- Ödeme entegrasyonu yok. Sipariş akışı, siparişi db.json dosyasına kaydeden bir simülasyon.
- Sunucu tarafı şimdilik deneme amaçlı, gerçek PHP API'ye bağlantı yapılmadı.

## Sonraki Adımlar

- Gerçek API'ye geçiş
- Ödeme sistemi entegrasyonu
- Mevcut sipariş tablosu üzerinden sipariş takibi
- Ürün karşılaştırma
- Progressive Web App desteği

## Tüm Ekran Görüntüleri

<details>
<summary>Tümünü göster</summary>

<table>
  <tr>
    <td align="center"><img src="screenshots/02_register_screen.png" width="180"><br>Kayıt, 1. adım</td>
    <td align="center"><img src="screenshots/03_register_screen.png" width="180"><br>Kayıt, 2. adım</td>
    <td align="center"><img src="screenshots/04_register_screen.png" width="180"><br>Kayıt, 3. adım</td>
    <td align="center"><img src="screenshots/05_home_screen.png" width="180"><br>Boş ana sayfa</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/08_product_list_screen.png" width="180"><br>Kategori seçimi</td>
    <td align="center"><img src="screenshots/09_product_list_screen.png" width="180"><br>Filtrelenmiş ürünler</td>
    <td align="center"><img src="screenshots/11_product_detail_screen.png" width="180"><br>Detay sayfası butonları</td>
    <td align="center"><img src="screenshots/13_hosting_screen.png" width="180"><br>Hosting paketleri (2)</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/14_hosting_screen.png" width="180"><br>Sepete ekleme penceresi</td>
    <td align="center"><img src="screenshots/15_hosting_screen.png" width="180"><br>Bilgiler girilmiş pencere</td>
    <td align="center"><img src="screenshots/16_support_screen.png" width="180"><br>Sıkça sorulan sorular</td>
    <td align="center"><img src="screenshots/17_support_screen.png" width="180"><br>Açılmış bir soru</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/19_support_screen.png" width="180"><br>Yeni talep formu (2)</td>
    <td align="center"><img src="screenshots/20_profile_screen.png" width="180"><br>Profil</td>
    <td align="center"><img src="screenshots/21_profile_screen.png" width="180"><br>Çıkış onayı</td>
    <td align="center"><img src="screenshots/22_favorites_screen.png" width="180"><br>Favoriler</td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/24_cart_screen.png" width="180"><br>Yalnızca script içeren sepet</td>
    <td align="center"><img src="screenshots/26_checkout_screen.png" width="180"><br>Sipariş ekranı (2)</td>
    <td align="center"><img src="screenshots/27_order_success_screen.png" width="180"><br>Sipariş tamamlandı</td>
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
│   ├── cities.json                 # Türkiye il ve ilçe verileri
│   └── faq_data.json               # Sıkça sorulan sorular
├── launcher/
│   └── icon.png
└── logo/
    └── logo.png
lib/
├── main.dart                          # Giriş noktası ve Provider kurulumu
├── models/                            # Veri modelleri
│   ├── tables/                        # Veritabanı tablolarının modelleri
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
│   ├── product.dart                   # XML'den gelen ürünlerin modeli
│   ├── hosting_cart_item.dart
│   ├── register_form_data.dart
│   ├── faq_item.dart
│   └── support_ticket_form_data.dart
├── providers/
│   ├── cart_provider.dart             # Sepet durumu, yalnızca ürün ID'leri tutuluyor
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
│   ├── scrollable_register_screen.dart # Birkaç adımlı kayıt ekranı
│   ├── cart_screen.dart                # Sepet ekranı
│   ├── favorites_screen.dart
│   ├── home_screen.dart                # Ana sayfa, üst barda sepet ve favoriler
│   ├── main_screen.dart                # 5 sekmeli ana iskelet
│   ├── product_detail_screen.dart
│   ├── product_list_screen.dart        # Ürün listesi, üst barda sepet ve favoriler
│   ├── hosting_screen.dart
│   ├── support_screen.dart
│   └── profile_screen.dart
├── services/
│   ├── auth_service.dart              # Giriş ve kayıt işlemleri
│   ├── mock_api_service.dart          # json-server ile HTTP iletişimi
│   ├── product_service.dart           # XML'den ürünleri okuyan servis
│   └── faq_service.dart               # SSS verisini okuyan servis
└── widgets/
    ├── cart_modal_widget.dart         # Her ekrandan açılabilen sepet penceresi
    ├── custom_bottom_navbar.dart      # 5 sekmeli alt menü
    ├── flash_card_widget.dart         # Kampanya, haber ve tanıtım kartları
    ├── product_card_v2.dart           # Ana sayfadaki küçük ürün kartı
    ├── product_details_widgets/
    │   ├── product_demo_buttons.dart
    │   ├── product_description_section.dart
    │   ├── product_detail_row.dart
    │   └── product_image_gallery.dart
    └── product_lists_widgets/
        ├── category_selector_modal.dart
        ├── compact_search_widget.dart # Arama kutusu ve kategori seçimi
        ├── error_widget.dart
        ├── loading_widget.dart
        ├── pagination_widget.dart
        └── product_card.dart          # Ürünler sayfasındaki ürün kartı
db.json                                # json-server veritabanı
```

### Servis Katmanı

**MockApiService** (`lib/services/mock_api_service.dart`) json-server'a giden tüm HTTP isteklerini üstleniyor.

Destek işlemleri
- `createSupportTicket(ticketData)` yeni bir destek talebi oluşturuyor
- `getUserTickets(userId)` kullanıcının taleplerini getirecek (henüz yazılmadı)
- `updateTicketStatus(ticketId, status)` talebin durumunu güncelleyecek (henüz yazılmadı)

Kullanıcı işlemleri
- `loginUser(email, password)`
- `registerUser(userData)`
- `updateUser(userId, userData)`

Script işlemleri
- `getAllScripts()`
- `getScriptById(scriptId)`
- `getAllCategories()`

Favori işlemleri
- `getUserFavorites(userId)`
- `addToFavorites(userId, scriptId)`
- `removeFromFavorites(userId, scriptId)`

**FaqService** (`lib/services/faq_service.dart`) SSS verisini asset dosyasından okuyor (`loadFaqItems()`) ve sorular arasında arama yapmayı sağlıyor (`searchFaqItems()`). Okuma sırasındaki hatalar yakalanıyor ve veri tip güvenli şekilde ayrıştırılıyor.

**AuthService** (`lib/services/auth_service.dart`) ilk sürümde SharedPreferences ve asset içindeki bir JSON dosyasıyla çalışıyordu. Daha sonra MockApiService üzerinden HTTP istekleri yapacak şekilde yeniden yazıldı. API'den metin olarak gelen ID'leri sayıya çeviriyor ve istek hatalarını ele alıyor.

Giriş akışı

```
userData = await MockApiService.loginUser(email, password)
→ TabloUyeler.fromJson(userData)
→ Token oluşturulması
→ Oturumun SharedPreferences ile saklanması
```

### db.json Yapısı

Gerçek veritabanı şemasına göre hazırlandı.

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

### REST Uç Noktaları

json-server bu dosyadan uç noktaları otomatik olarak oluşturuyor. Birkaç örnek.

```
GET    /uyeler              # Tüm kullanıcılar
POST   /uyeler              # Yeni kullanıcı
PUT    /uyeler/1            # Kullanıcıyı güncelle
DELETE /uyeler/1            # Kullanıcıyı sil

GET    /favorites?user_id=1 # Bir kullanıcının favorileri
POST   /favorites           # Favori ekle
DELETE /favorites/1         # Favoriyi sil
```

</details>
