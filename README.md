# PGYS - Personel ve Görev Yönetim Sistemi

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Desktop-lightgrey?style=for-the-badge)
![Status](https://img.shields.io/badge/Sürüm-1.0.0--Stabil-success?style=for-the-badge)

Kurumsal birimlerin, şube müdürlüklerinin ve operasyonel ekiplerin personel, görev, izin ve raporlama süreçlerini güvenli, kesintisiz ve yerel ağ (LAN) üzerinden eşzamanlı olarak yönetebilmeleri için geliştirilmiş masaüstü odaklı kurumsal yönetim sistemidir.

---

## 📌 Projenin Amacı ve Kapsamı

**PGYS**, kamu veya özel sektör operasyonel birimlerindeki personellerin:
- Sicil ve özlük bilgilerinin eksiksiz kayıt altına alınması,
- Günlük görev planlamalarının ve personel atamalarının yapılması,
- İzin, mazeret ve sağlık raporlarının çakışma kontrolleriyle takip edilmesi,
- Resmi izin dilekçesi (Word/DOCX), personel karnesi ve kurumsal raporların (PDF & Excel) tek tıkla üretilmesi,
- İnternet bağlantısına ihtiyaç duymadan, yerel ağ (LAN) üzerinde istemci-sunucu mimarisiyle güvenli çalışabilmesini
amaçlamaktadır.

---

## 🚀 Öne Çıkan Özellikler ve Modüller

### 1. 📊 Genel Bakış (Dashboard)
- **Bugünkü Kadro Durumu:** Faal çalışanlar, izindekiler, rapordakiler ve görevdeki personellerin anlık dökümü.
- **Son Hareketler & Uyarılar:** Süresi yaklaşan ya da geciken görevler, son personel ve izin hareketleri.
- **Hızlı Aksiyonlar:** Tek tıkla yeni görev, izin veya personel ekleme kısayolları.

### 2. 👥 Personel Yönetimi
- **Detaylı Özlük Kartı:** Sicil no, T.C. kimlik, ad-soyad, rütbe/unvan, büro/kısım, çalışma düzeni ve iletişim bilgileri.
- **Kıdem ve Hak Ediş:** İşe/mesleğe başlama tarihi üzerinden otomatik çalışma yılı ve izin hakkı hesaplaması.
- **Tarihçe & Hareket Takibi:** Görev yeri değişikliği, terfi, izin ve sistem loglarının kronolojik kaydı.
- **Toplu İşlemler:** Çoklu personel seçimi, toplu görev atama ve seçili personelleri Excel formatında dışa aktarma.

### 3. 📝 Görev ve Operasyon Yönetimi
- **Görev Atama:** Başlangıç/bitiş tarihleri, öncelik derecesi, kategori ve açıklamalarla görev tanımlama.
- **Çoklu Personel Entegrasyonu:** Bir göreve birden fazla personeli eş zamanlı atayabilme ve takip edebilme.
- **Durum Takibi:** *Bekliyor*, *Devam Ediyor*, *Tamamlandı*, *İptal* durum filtreleri.

### 4. 🏖️ İzin ve Sağlık Raporları Takibi
- **İzin Türleri:** Yıllık izin, mazeret izni, evlilik/ölüm izni ve sağlık raporu desteği.
- **Çakışma Kontrolü (Overlap Guard):** Aynı personele mükerrer veya tarihleri çakışan izin verilmesini engelleyen doğrulama mekanizması.
- **Otomatik Dilekçe Üretimi (DOCX):** Seçilen izin kaydı için personelin iletişim, adres ve gün sayısını içeren resmi izin talep formunu anında Word formatında hazırlar.

### 5. 📈 Gelişmiş Raporlama ve Dışa Aktarma
- **Dönemsel Analitik:** 1 Eylül – 31 Ağustos kurumsal çalışma dönemlerine göre filtreleme.
- **Birim & Rütbe Dağılımı:** Kadro dağılımı, yıllık izin kullanım oranları ve görev tamamlama istatistikleri.
- **PDF & Excel Çıktıları:**
  - Genel izin ve görev listeleri (Excel).
  - Seçili personel için kapsamlı "Personel Karnesi & Faaliyet Özeti" (PDF).
  - Kurumsal dönemsel değerlendirme raporları.

### 6. 🔒 Güvenlik, Rol ve Yetkilendirme (RBAC)
- **Kullanıcı Rolleri:** Süper Admin, Yönetici, Operatör ve Salt Okunur roller.
- **Güvenli Kimlik Doğrulama:** Tuzlanmış hash (PBKDF2/SHA256) şifre saklama.
- **Güvenlik Politikaları:** İlk oturumda zorunlu şifre değiştirme kuralı ve arka arkaya 5 hatalı girişte geçici hesap kilitleme.
- **Yedekleme (Backup & Restore):** Veritabanının tek tuşla `.db` formatında yedeğinin alınması ve geri yüklenmesi.

### 7. 🌐 Yerel Ağ (LAN) Eşitleme
- Harici bir bulut servisine gerek duymadan, aynı ağdaki bir bilgisayarı ana sunucu (Host), diğerlerini istemci (Client) yaparak yerel ağ üzerinden güvenli veri senkronizasyonu.

---

## 🛠️ Teknoloji Yığını ve Mimari

- **Platform:** Flutter Desktop (Windows Odaklı, macOS/Linux/Web Uyumlu)
- **Dil:** Dart 3.12+
- **Durum Yönetimi (State Management):** Flutter Riverpod (v3)
- **Veritabanı (ORM):** Drift (SQLite tabanlı tür güvenli veritabanı)
- **Tasarım / UI:** Material 3, FlexColorScheme, Responsive Master-Detail Layout
- **Yönlendirme (Routing):** GoRouter
- **Bağımlılık Yönetimi (DI):** GetIt
- **Belge Üretimi & Dışa Aktarım:**
  - `docx_creator`: Resmi Word izin dilekçesi üretimi
  - `pdf`: Vektörel kurumsal rapor üretimi
  - `excel_plus`: Tablo dışa aktarımları

---

## 💻 Kurulum ve Çalıştırma

### Gereksinimler
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24.x veya üzeri önerilir)
- Visual Studio (C++ Desktop Development araçları yüklü olmalıdır - Windows masaüstü derlemesi için)
- Dart SDK (3.12+)

### Adım Adım Kurulum

1. **Projeyi Klonlayın veya İndirin:**
   ```powershell
   git clone https://github.com/abdullahakyemez/personel-gorev-yonetim-sistemi.git
   cd PGYS_Kopya
   ```

2. **Bağımlılıkları Yükleyin:**
   ```powershell
   flutter pub get
   ```

3. **Veritabanı Kod Üretimini Çalıştırın (Gerekirse):**
   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Statik Analiz ve Testleri Doğrulayın:**
   ```powershell
   dart analyze
   flutter test
   ```

5. **Windows Üzerinde Çalıştırın:**
   ```powershell
   flutter run -d windows
   ```

---

## 📂 Proje Dizin Yapısı

```text
lib/
├── app/                  # Uygulama başlangıcı, router ve tema yapılandırması
├── core/                 # Ortak çekirdek katmanı
│   ├── database/         # Drift veritabanı tabloları, migration ve yedekleme
│   ├── di/               # Service Locator (GetIt)
│   ├── export/           # PDF, Excel ve DOCX dışa aktarma servisleri
│   ├── network/          # LAN sunucu ve istemci senkronizasyon altyapısı
│   ├── theme/            # Renk paleti, tipografi, boşluk ve stiller
│   ├── utils/            # Tarih, şifre ve formatlayıcı yardımcı sınıflar
│   └── widgets/          # Ortak UI bileşenleri (Dialog, Kart, Tablo vb.)
├── features/             # İş modülleri (Feature-First Mimari)
│   ├── auth/             # Kullanıcı oturumu, şifre ve yetkilendirme
│   ├── dashboard/        # Ana sayfa paneli ve özet istatistikler
│   ├── leave/            # İzin, rapor takibi ve dilekçe üretimi
│   ├── personnel/        # Personel özlük, geçmiş ve filtreleme
│   ├── reports/          # Dönemsel raporlar, filtreleme ve analiz
│   ├── settings/         # Sistem ayarları, LAN yapılandırması ve yedekleme
│   └── task/             # Görev yönetimi ve personel atamaları
└── shell/                # Masaüstü kenar çubuğu (Sidebar) ve üst çubuk (Topbar)
```

---

## 🚦 Proje Aşaması ve Sürüm Durumu

| Sürüm | Durum | Açıklama |
| :--- | :--- | :--- |
| **v1.0.0-Stable** | **Üretime Hazır (Aktif)** | Tüm temel modüller (Personel, Görev, İzin, Rapor, LAN Senkronizasyonu, DOCX/PDF/Excel Dışa Aktarma) tamamlanmış, gereksiz ve atıl kodlar temizlenmiş, test edilmiş stabil sürümdür. |

---

## 📄 Lisans ve Kullanım

Bu proje kurumsal kullanım ve personel-görev takibi amacıyla geliştirilmiştir. Tüm hakları saklıdır.
