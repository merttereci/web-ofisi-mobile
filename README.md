# Web Ofisi Mobile - Flutter E-Ticaret Uygulaması

Kurumsal web yazılımları satışı için geliştirilmiş Flutter e-ticaret uygulaması. 158 adet hazır web scripti listeleyen, kullanıcı kayıt/giriş sistemi olan, favoriler ve sepet özellikli modern mobil uygulama.

## Proje Açıklaması

Web Ofisi Mobile, kurumsal web yazılımları satışı için geliştirilmiş modern bir Flutter e-ticaret uygulamasıdir. **İki farklı veri kaynağı** kullanarak hybrid bir yaklaşım benimser: XML den 158 adet hazır web scripti çekerken(ürünler), kullanıcı verilerini JSON Mock Server üzerinden yönetir (gelecekte API üzerinden veritabanına bağlanarak).

## Dizin Yapısı
```
assets/
├──data/   
   ├── cities.json                 # Türkiye il/ilçe verileri
   └── faq_data.json               # Sık sorulan sorular verisi
├──launcher/
   └── icon.png
├──logo/
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
│   ├── cart_provider.dart             # Sepet state yönetimi (minimal ID-based)
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
│   ├── scrollable_register_screen.dart # Multi-step kayıt ekranı
│   ├── cart_screen.dart               # Sepet ekranı (modal)
│   ├── favorites_screen.dart          
│   ├── home_screen.dart               # Ana sayfa ekranı (AppBarlı: sepet ve favori)
│   ├── main_screen.dart               # Ana ekran (5-tab navigation)
│   ├── product_detail_screen.dart     
│   ├── product_list_screen.dart       # Ürün listesi ekranı (AppBarlı: sepet ve favori)
│   ├── hosting_screen.dart            
│   ├── support_screen.dart            
│   └── profile_screen.dart            
├── services/                          
│   ├── auth_service.dart              # Mock API entegrasyonu ile kimlik doğrulama
│   ├── mock_api_service.dart          # JSON Mock Server HTTP servisi
│   ├── product_service.dart           # Ürün API servisi (XML parser)
│   └── faq_service.dart               # FAQ veri servisi
└── widgets/                           
    ├── cart_modal_widget.dart         # Reusable sepet modal widget
    ├── custom_bottom_navbar.dart      # 5-tab navigationlı özel bottomnavbar
    ├── flash_card_widget.dart         # Flash kartlar; promosyonlar, haberler, tanıtımlar, için
    ├── product_card_v2.dart           # Kompakt ürün kartı (ana sayfa)
    ├── product_details_widgets/       
    │   ├── product_demo_buttons.dart  
    │   ├── product_description_section.dart 
    │   ├── product_detail_row.dart   
    │   └── product_image_gallery.dart 
    ├── product_lists_widgets/         
    │   ├── category_selector_modal.dart 
    │   ├── compact_search_widget.dart # Kompakt arama + kategori widget
    │   ├── error_widget.dart          
    │   ├── loading_widget.dart        
    │   ├── pagination_widget.dart     
    │   └── product_card.dart          # Ana ürün kartı (ürünler sayfası)
db.json                                # JSON Mock Server veritabanı
```

## Mevcut Özellikler

#### Çalışan Ana Özellikler
- **Mock veritabanı** kullanıcı kimlik doğrulama sistemi (HTTP persistence)
- XML'den 158 ürünün çekilmesi, arama ve kategori filtreleme 
- Sayfalama ile optimize edilmiş ürün listesi yönetimi 
- Minimal sepet sistemi (ID-based , KDV hesaplaması) 
- 5-tab responsive tasarım ve state preservation 
- Reusable widget'lar ile tutarlı UI deneyimi
- Hosting paketlerinin listelenmesi ve carta ekleme
- Ürünlerin favori ikonuna tıklayarak favorileme
- JSON Mock Server entegrasyonu ve gerçek HTTP authentication sistemi, favoriler mantığı, uilar da tamamlandı
- Hosting paketlerinin listelenmesi ve carta ekleme
- Ürünlerin favori ikonuna tıklayarak favorileme

### Kapsamlı Destek Sistemi**
- **FAQ Sistemi**: 11 adet detaylı sık sorulan soru
- **ExpansionTile Interface**: Accordion-style açılabilir sorular
- **YouTube Entegrasyonu**: Video tutorial linkleri
- **Download Linkleri**: Ek dosya ve araç indirmeleri
- **Destek Talebi Formu**: Kullanıcı bilgileri otomatik doldurma
- **Multi-field Form**: Departman, öncelik, hizmet seçimi
- **Image Upload**: Kamera/galeri ile fotoğraf ekleme
- **Form Validation**: Comprehensive input kontrolü
- **Complete Form Submission**: MockApiService entegrasyonu ile db.json'a veri yazma

### Gelişmiş Navigation Sistemi**
- **5-Tab Bottom Navigation**: Ana Sayfa, Ürünler, Hosting, Destek, Profil
- **3-Tab Destek Sistemi**: S.S.S, Yeni Talep, Geçmiş Talepler
- **State Preservation**: Tab değişimlerinde veri korunması
- **Responsive Design**: Tüm ekran boyutlarında optimize edilmiş


### Gerçek Backend Deneyimi**
- **Gerçek HTTP Authentication**: MockApiService ile login/register
- **Database-like operations**: CRUD işlemleri JSON Mock Server üzerinde
- **Real-time data persistence**: Değişiklikler db.json dosyasına yazılır
- **Session management**: Token-based authentication
- **Type-safe data handling**: String ID'lerin integer'a dönüştürülmesi

### Enhanced User Management**
- **Production-ready login flow**: Email/password validation
- **Real user registration**: Form validation ve duplicate email kontrolü
- **Profile management**: Kullanıcı bilgilerini güncelleyebilme
- **Session persistence**: App restart'ta otomatik login


### Temel Akış

- Uygulama açılır: AuthWrapper kullanıcı giriş kontrolü yapar
- Ana sayfa: Flash kartlar + XML'den ilk 6 ürün horizontal scroll
- Ürünler sayfası: Tüm ürünler, arama, kategori filtreleme, sayfalama
- Favoriler: Login gerekli, Mock API ile gerçek HTTP CRUD
- Sepet: Sayfa olarak açılır, KDV hesaplama, ürün toggle
- Destek: FAQ browsing + destek talebi oluşturma + ticket tracking

### **Favoriler Sistemi Altyapısı 
Mock API Server'da favorites tablosu mevcut ve MockApiService'te endpoint'ler hazır:
- Database schema: user_id, script_id, created_at
- CRUD operations: add, remove, list favorites
- Real-time data synchronization
- UI done

### Sepet Sistemi ve E-ticaret
Sepet sistemi Set<int> veri yapısı ile sadece ürün ID'lerini saklayarak memory kullanımını optimize ediyor. Her ürün için toggle mantığı (ekle/çıkar) kullanılıyor. Yüzde 20 KDV hesaplaması otomatik olarak yapılıyor ve fiyat detayları (ara toplam, KDV, genel toplam) ayrı ayrı gösteriliyor. CartModalWidget ile tüm uygulamada tutarlı sepet deneyimi sunuluyor.


### **Provider Bağımlılıkları ve State Yönetimi**
MultiProvider yapısı ile ProductProvider (158 ürün + filtreleme), UserProvider (Mock API auth + profile) ve CartProvider (minimal sepet) merkezi olarak yönetiliyor. FavoritesProvider: Mock API, real-time sync ve Consumer2 pattern'i ile CartProvider ve ProductProvider'ın birlikte kullanıldığı ekranlarda optimize edilmiş rendering sağlanıyor.

### Veri Modelleri ve Optimizasyon**
- **Product.dart**: XML parsing ile 158 ürünü yönetiyor
- **TabloUyeler ve diğer tablo modelleri**: JSON Mock Server ile uyumlu
- **MockApiService**: HTTP istekleri ile REST API simulation
- **AuthService**: Production-ready authentication patterns

### **Uzun Vadeli İyileştirmeler**
- **Real API transition**: JSON Mock Server'dan production API'ye geçiş (sadece URL değişikliği gerekli)
- Ödeme sistemi entegrasyonu
- **Sipariş takip sistemi**: Mock API'deki orders tablosunu kullanarak
- **Ürün karşılaştırma özelliği**: MockApiService ile comparison endpoint'leri
- Advanced analytics ve user behavior tracking
- **Progressive web app desteği**: Mevcut HTTP infrastructure ile uyumlu

## **PERFORMANS VE OPTİMİZASYON**

### **Yeni Network ve Storage Verimliliği**
- **HTTP connection pooling**: Efficient API requests
- **Real-time data synchronization**: JSON Mock Server ile
- **Type-safe data parsing**: Runtime type checking ve conversion
- **Production-ready architecture**: Mock'tan real API'ye seamless transition

### Memory ve Storage Verimliliği
Sepet sistemi ID-based storage ile her ürün için sadece 4-8 byte kullanıyor. ProductProvider single source of truth prensibi ile duplicate data'yı engelliyor. Lazy loading ve error handling ile robust image management sağlanıyor. **SharedPreferences ile enhanced session management** gerçekleştiriliyor.

### **Yeni Kullanıcı Deneyimi ve Responsive Design**
- **Real-time authentication feedback** ile instant user response
- **Network-aware error handling** ile robust user experience
- **Seamless session management** ile uninterrupted user journey
- Gerçek zamanlı sepet badge güncellemeleri ile instant feedback (değişiklik yok)
- IndexedStack ile smooth tab navigation ve state preservation (değişiklik yok)

## MİMARİ YAPI**

### **Hybrid Data Architecture**
- **XML**: Ürün bilgileri (product.dart modeli ile 158 script)
- **JSON Mock Server**: Kullanıcı, sipariş, favoriler ve tüm işlem verileri
- **SharedPreferences**: Oturum persistance ve cache

### State Management
MVVM mimarisi kullanılarak Provider pattern ile reactive state yönetimi gerçekleştiriliyor. **UserProvider artık gerçek HTTP istekleri** yaparak Mock API Server ile entegre çalışmaktadır. Örnek: CartProvider minimal veri saklama prensibi ile sadece ürün ID'lerini saklayarak memory optimizasyonu yapıyor. Tüm veriler SharedPreferences ile kalıcı olarak saklanıyor.

### JSON Mock Server Entegrasyonu**
Production-ready bir backend deneyimi sağlamak için **json-server** kullanılmaktadır. Bu yaklaşım:
- Gerçek HTTP istekleri (GET, POST, PUT, DELETE)
- RESTful API deneyimi
- Gerçek zamanlı veri güncellemeleri
- Production API'ye kolay geçiş imkanı sağlar



## ** SERVİS KATMANI**

### **MockApiService (lib/services/mock_api_service.dart)**
JSON Mock Server ile iletişimi sağlayan kapsamlı HTTP servisi:

**Destek İşlemleri:**
- `createSupportTicket(ticketData)` - Yeni destek talebi (calısıyo)
- `getUserTickets(userId)` - Kullanıcının talepleri (yapılacak)
- `updateTicketStatus(ticketId, status)` - Talep durumu güncelleme (yapılacak)

**Kullanıcı İşlemleri:**
- `loginUser(email, password)` - Kullanıcı girişi
- `registerUser(userData)` - Yeni kullanıcı kaydı
- `updateUser(userId, userData)` - Kullanıcı profili güncelleme

**Script İşlemleri:**
- `getAllScripts()` - Tüm scriptleri getir
- `getScriptById(scriptId)` - Script detayları
- `getAllCategories()` - Kategorileri getir

**Favoriler İşlemleri:**
- `getUserFavorites(userId)` - Kullanıcının favorileri
- `addToFavorites(userId, scriptId)` - Favori ekle
- `removeFromFavorites(userId, scriptId)` - Favori sil

### **FaqService (lib/services/faq_service.dart)**
Asset tabanlı FAQ veri yönetimi:
- `loadFaqItems()` - FAQ verilerini asset'ten yükleme
- `searchFaqItems()` - FAQ arama fonksiyonu
- Error handling ve type-safe data parsing


### **AuthService (lib/services/auth_service.dart)**
**BÜYÜK DEĞİŞİKLİK:** Asset-based mock veriler yerine Mock API Server kullanımı

**Önceki versiyon:** SharedPreferences ve asset JSON dosyası
**Güncel versiyon:** HTTP istekleri ve gerçek API davranışı

**Yeni özellikler:**
- MockApiService entegrasyonu
- Type-safe ID handling (string ID'leri integer'a dönüştürme)
- Comprehensive error handling
- Production-ready authentication flow

**Login akışı:**
```dart
userData = await MockApiService.loginUser(email, password)
→ TabloUyeler.fromJson(userData)
→ Token generation
→ SharedPreferences persistence
```

## **JSON Mock Server Konfigürasyonu**

### **db.json Yapısı**
Gerçek veritabanı şemasına uygun olarak tasarlanmış:

```json
{
  "uyeler": [...],           // TabloUyeler modeline uygun
  "scriptler": [...],        // TabloScriptler modeline uygun  
  "kategoriler": [...],      // TabloKategoriler modeline uygun
  "siparisler": [...],       // TabloSiparisler modeline uygun
  "favorites": [...],        // user_id, script_id, created_at
  "krediler": [...],         // TabloKrediler modeline uygun
  "destek": [...],           // TabloDestek modeline uygun
  "destek_cevaplar": [...],  // TabloDestekCevaplar modeline uygun
  "hosting_siparisler": [...], // TabloHostingSiparisler modeline uygun
  "indirim_kuponlari": [...], // TabloIndirimKuponlari modeline uygun
  "banka_hesaplari": [...],  // TabloBankaHesaplari modeline uygun
  "slider": [...]            // TabloSlider modeline uygun
}
```



### **Otomatik REST Endpoints**
```
GET    /uyeler              # Tüm kullanıcılar
POST   /uyeler              # Yeni kullanıcı
PUT    /uyeler/1            # Kullanıcı güncelle
DELETE /uyeler/1            # Kullanıcı sil

GET    /favorites?user_id=1 # Query parameters
POST   /favorites           # Favori ekle
DELETE /favorites/1         # Favori sil
```


## **PRODUCTION GEÇİŞ STRATEJISI**

### **Mock'tan Real API'ye Geçiş**
Mevcut JSON Mock Server yapısı, production PHP API'ye geçiş için optimum hazırlık sağlamaktadır:

1. **URL değişikliği**: MockApiService'te sadece baseUrl güncellenmesi yeterli
2. **HTTP method compatibility**: Aynı REST endpoint'ler kullanılabilir
3. **Data model compatibility**: Tablo modelleri gerçek veritabanı ile uyumlu
4. **Authentication flow**: Token-based system production-ready

```dart
// Development
static const String baseUrl = 'http://10.0.2.2:3000';

// Production
static const String baseUrl = 'https://yourdomain.com/api';
```

Kod değişikliği **minimum** düzeyde kalacaktır.

**Son Güncelleme:** Sipariş verme simülasyonu tamamlandı, dbye siparişler yazılabiliyor"
**Toplam Dosya Sayısı:** 40+ dart dosyası + assets + mock server configuration  
**Ana Özellikler:** **Real HTTP authentication**, **comprehensive support system**, ürün browsing, optimized cart system, responsive UI, **production-ready backend simulation**  
**Mimari:** **Clean Architecture + HTTP Services**, Provider pattern, Widget-based modular design, **Mock-to-Production transition ready**

### **Uzun Vadeli İyileştirmeler**
- Real API transition: JSON Mock Server'dan production API'ye geçiş
- Ödeme sistemi entegrasyonu
- Sipariş takip sistemi: Mock API'deki orders tablosunu kullanarak
- Ürün karşılaştırma özelliği: MockApiService ile comparison endpoint'leri
- Advanced analytics ve user behavior tracking
- Progressive web app desteği: Mevcut HTTP infrastructure ile uyumlu

Image Upload Mevcut Durumu:
Çalışan Kısımlar:

 + Kamera/galeri seçimi modal'ı
 + Image picker fonksiyonu
 + Seçilen resmin thumbnail preview'ı
 + Resmi form'dan kaldırma
 + Image compression (maxWidth: 1024, quality: 80)

Çalışmayan/Eksik Kısımlar:

 - Resmin gerçek verisi veritabanına kaydedilmiyor
 - Sadece "Fotoğraf eklendi" text'i yazılıyor
 - Base64 encoding yapılmıyor
 - File storage/retrieval sistemi yok
---


Nerede Kaldık?

imageda base64 denenicek (düşük öncelik)
support ticket gönderildikten sonra form temizlenip sayfa başına scroll edilsin
geçmiş sonraya
support ticketta kullanıcı idye göre sipariş seçebilme seçeneği
i

...