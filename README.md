# PGYS - Personel ve Görev Yönetim Sistemi

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20x64%20%7C%20Desktop-lightgrey?style=for-the-badge)
![Status](https://img.shields.io/badge/Sürüm-1.0.0--Stabil-success?style=for-the-badge)

Kurumsal birimlerin, şube müdürlüklerinin ve büro amirliklerinin personel özlük, nöbet/görev planlama, izin/rapor takibi, resmi belge üretimi (Word & PDF) ve dönemsel istatistiki raporlama süreçlerini **tam kapalı devre (intranet)**, yüksek güvenlikli ve yerel ağ (LAN) üzerinden eşzamanlı olarak yönetebilmeleri için geliştirilmiş masaüstü kurumsal yönetim sistemidir.

---

## 📌 Projenin Amacı ve Kapsamı

**PGYS**, operasyonel birimlerdeki personellerin:
- Sicil, rütbe, unvan, büro, zimmet ve özlük bilgilerinin eksiksiz kayıt altına alınmasını,
- Günlük ve dönemsel görevlendirmelerin (nöbet, operasyon, tedbir vb.) çoklu personel seçimiyle planlanmasını,
- 657 sayılı DMK ve kurum mevzuatına uygun izin (yıllık, mazeret, sağlık raporu vb.) hesaplamalarını ve çakışma kontrollerini,
- **Resmi İzin Talep Dilekçesinin (Word / .docx)** ve kapsamlı **Personel Karnesi / Faaliyet Özetinin (PDF)** tek tıkla üretilmesini,
- Harici bir bulut sunucuya ihtiyaç duymadan, **Merkezi Sunucu - İstemci (Host - Client)** mimarisiyle aynı yerel ağdaki birden fazla bilgisayarda ortak veritabanıyla çalışmasını
sağlar.

---

## 🚀 Öne Çıkan Özellikler ve Modüller

### 1. 📊 Genel Bakış (Dashboard)
- **Bugünkü Kadro Durumu:** Görevde, istirahatli, izinli ve rapordaki personellerin anlık dökümü.
- **Son Hareketler & Uyarılar:** Süresi yaklaşan görevler ve son personel hareketleri.
- **Dinamik Duyarlı Izgara:** Çözünürlüğe göre otomatik uyumlanan (2, 4 veya 8 sütunlu) istatistik kartları.

### 2. 👥 Personel Yönetimi & Özlük Kartı
- **Kapsamlı Özlük:** Sicil No, T.C. Kimlik, Ad-Soyad, Rütbe, Şube, Büro, Çalışma Düzeni, Kan Grubu, İletişim ve Yakın Bilgileri.
- **Kıdem ve Hak Ediş:** Memuriyete başlama tarihi üzerinden otomatik kıdem yılı ve yıllık izin hakkı (1-10 yıl arası 24 gün, 10 yıl üzeri 34 gün) hesaplaması.
- **Gelişmiş Filtre Çubuğu:** İsim, sicil, rütbe ve büro bazlı anlık filtreleme.
- **Toplu İşlemler:** Çoklu personel seçimi, toplu görev atama ve seçili personelleri biçimlendirilmiş Excel formatında dışa aktarma.
- **Tarihçe & Kronoloji:** Görev yeri değişikliği, terfi ve izin loglarının tarihsel kaydı.

### 3. 📝 Görev ve Operasyon Yönetimi
- **Esnek Görev Planlama:** Başlangıç-bitiş tarihleri, kategori (Nöbet, Devriye, Tedbir, Müsabaka, Sınav vb.) ve öncelik derecesi.
- **Çoklu Personel Entegrasyonu:** Bir göreve tek seferde birden fazla personel atayabilme ve çakışma uyarısı.
- **Durum Takibi:** *Planlandı*, *Devam Ediyor*, *Tamamlandı*, *İptal* filtreleri ve Excel nöbet çizelgesi çıktısı.

### 4. 🏖️ İzin ve Sağlık Raporları Takibi
- **Mevzuata Tam Uyum:** Yıllık izin, mazeret, mazeret (evlilik/doğum/ölüm) ve sağlık raporu desteği.
- **Çakışma Kalkanı (Overlap Guard):** Aynı personele mükerrer veya tarihleri çakışan izin verilmesini engelleyen doğrulama mekanizması.
- **Devreden İzin Kuralı:** Yalnızca bir önceki takvim yılına ait kullanılmayan izinler cari yıla devreder; daha eski yıllar otomatik düşürülür.
- **Resmi İzin Dilekçesi Motoru (Word / .docx):**
  - Seçilen personel ve izin kaydı için resmi izin talep formunu Word formatında üretir.
  - Asil Büro Amiri veya Büro Amir Vekili (Vekaleten İmza) onay makamı seçimi yapılabilir.
  - Vekil personelin adı ve unvanı otomatik doldurulur.

### 5. 📈 Gelişmiş Raporlama ve Analitik
- **Dönemsel Filtreleme:** Kurumsal 1 Eylül – 31 Ağustos çalışma dönemleri ve özel tarih aralığı.
- **Birim & Rütbe Analizi:** Büro bazlı kadro dağılımı, izin kullanım oranları ve görev tamamlama performansı.
- **Vektörel PDF & Excel Çıktıları:**
  - Genel İzin ve Görev Çizelgeleri (Excel).
  - Seçili Personel için resmi **"Personel Karnesi ve Faaliyet Raporu" (PDF)**.

### 6. 🔒 Güvenlik, Rol ve Yetkilendirme (RBAC)
- **Kullanıcı Rolleri:** Büro Amiri (Süper Admin), Yönetici, Operatör, Grup Amiri, Ekip Görevlisi ve Salt Okunur.
- **Parola Koruması:** PBKDF2-HMAC-SHA256 ve tuzlanmış (salted) karma mimarisi.
- **İlk Giriş Kalkanı:** Sistemde ilk kez oturum açan kullanıcı zorunlu yeni şifre belirleme ekranına yönlendirilir; şifre yenilenmeden sisteme erişilemez.
- **Kaba Kuvvet (Brute-Force) Koruması:** 5 ardışık hatalı şifre denemesinde hesap 60 saniye süreyle otomatik kilitlenir.
- **Yedekleme & Geri Yükleme:** Tek tıkla yerel `.db / .sqlite` yedeği alma, otomatik zamanlanmış yedekleme ve sistem geri yükleme.

---

## 🌐 MERKEZİ SUNUCU & ÇOKLU BİLGİSAYAR (LAN) KULLANIM KILAVUZU

PGYS, aynı yerel ağa (ofis/büro ağı) bağlı birden fazla bilgisayarda **ortak veritabanı** ile çalışabilir. İnternet bağlantısı veya harici bir bulut servisi gerektirmez.

```
                  ┌─────────────────────────────────────────┐
                  │      ANA BİLGİSAYAR (SUNUCU / HOST)     │
                  │   Yerel IP: 192.168.1.100  |  Port: 8085│
                  │        Merkezi SQLite Veritabanı        │
                  └────────────────────┬────────────────────┘
                                       │ Yerel Ağ (LAN / Wi-Fi)
             ┌─────────────────────────┼─────────────────────────┐
             │                         │                         │
┌────────────▼────────────┐┌───────────▼───────────┐┌───────────▼───────────┐
│     İSTEMCİ PC 1        ││     İSTEMCİ PC 2       ││     İSTEMCİ PC 3       │
│  (Client - Memur Masası)││(Client - Grup Amiri)   ││  (Client - Nöbetçi)   │
└─────────────────────────┘└────────────────────────┘└────────────────────────┘
```

### 1. Adım: Ana Bilgisayarın (Sunucu / Host) Yapılandırılması

1. **Sabit Yerel IP Atayın:**
   - Ana bilgisayarınızın ağ ayarlarından yerel IP adresini sabitleyin (Örnek: `192.168.1.100`).
   - Mevcut IP adresinizi öğrenmek için PowerShell'de `ipconfig` komutunu çalıştırabilirsiniz (IPv4 Address).
2. **Windows Güvenlik Duvarında Port Açın (TCP 8085):**
   - İstemci bilgisayarların sunucuya bağlanabilmesi için gelen bağlantı kuralı tanımlanmalıdır.
   - Yönetici yetkisiyle PowerShell'de şu komutu çalıştırabilirsiniz:
     ```powershell
     New-NetFirewallRule -DisplayName "PGYS LAN Sunucusu" -Direction Inbound -LocalPort 8085 -Protocol TCP -Action Allow
     ```
3. **PGYS'de Sunucu Modunu Başlatın:**
   - PGYS'yi açın ve **Ayarlar > Yerel Ağ (LAN) Yapılandırması** bölümüne gidin.
   - Çalışma Modu olarak **Sunucu Modu (Host)** seçeneğini işaretleyin.
   - Port alanını `8085` olarak bırakın veya belirlediğiniz portu girin.
   - Bir **Güvenlik Belirteci (Token)** oluşturun veya "Jeton Oluştur" butonuna basarak güvenli anahtar üretin.
   - **"Sunucuyu Başlat"** butonuna tıklayın. Durum rozeti yeşile dönerek *"Sunucu Aktif"* olacaktır.

---

### 2. Adım: İstemci Bilgisayarların (Client) Bağlanması

1. İstemci olarak çalışacak bilgisayara PGYS'yi kurun ve açın.
2. **Ayarlar > Yerel Ağ (LAN) Yapılandırması** bölümüne gidin.
3. Çalışma Modu olarak **İstemci Modu (Client)** seçeneğini seçin.
4. **Sunucu Bilgilerini Girin:**
   - **Sunucu IP Adresi:** Ana bilgisayarın yerel IP adresi (örn: `192.168.1.100`)
   - **Port:** `8085`
   - **Güvenlik Jetonu:** Ana bilgisayarda belirlenen jetonun aynısı.
5. **"Bağlantıyı Sına"** butonuna basarak iletişimi doğrulayın.
6. **"Eşitlemeyi Başlat"** butonuna tıklayın.

---

### 3. Adım: Senkronizasyon ve Veri Güvenliği

- **Çift Yönlü Eşitleme:** İstemci bilgisayarlardan girilen her yeni personel, görev veya izin kaydı ana sunucuya anında iletilir ve sunucudaki güncel durum istemcilere yansıtılır.
- **Çevrimdışı Dayanıklılık (Offline-First):** Ağ bağlantısı anlık olarak kesilirse istemciler kendi yerel önbellekleriyle çalışmaya devam eder; bağlantı yeniden sağlandığında otomatik senkronizasyon gerçekleşir.
- **Merkezi Yedekleme:** Ana bilgisayardaki veritabanı yedeklendiğinde tüm birimin verileri tek dosyada korunmuş olur.

---

## 💻 İlk Giriş Bilgileri (Sıfır Kurulum)

Temiz kurulum yapıldıktan sonra sisteme giriş için varsayılan yetkili hesabı:

- **Kullanıcı Adı (Sicil):** `admin`
- **Geçici İlk Şifre:** `admin123`

> [!IMPORTANT]
> **Güvenlik Uyarısı:** Kurulum sonrası ilk oturum açılışında sistem sizden **yeni ve güvenli bir parola** belirlemenizi zorunlu kılacaktır. Şifrenizi güncelledikten sonra Ayarlar menüsünden kurum ve yetkili amir bilgilerinizi tanımlayabilirsiniz.

---

## 🛠️ Teknoloji Yığını ve Mimari

- **Platform:** Flutter Desktop (Windows x64 Odaklı)
- **Dil:** Dart 3.12+
- **Durum Yönetimi:** Flutter Riverpod (v3)
- **Veritabanı (ORM):** Drift (SQLite tabanlı, ACID ve type-safe)
- **Tasarım & UI:** Material 3, FlexColorScheme, Responsive Master-Detail Layout
- **Yönlendirme:** GoRouter
- **Belge Üretimi:**
  - `docx_creator` & `archive`: Resmi Word izin talep dilekçesi motoru
  - `pdf`: Vektörel personel karnesi ve kurumsal rapor üretimi
  - `excel_plus`: Gelişmiş veri listeleme ve çizelge aktarımı

---

## 💻 Geliştirici Kurulum ve Çalıştırma

### Gereksinimler
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24+ önerilir)
- Visual Studio (C++ Desktop Development araçları yüklü olmalıdır)
- Dart SDK (3.12+)

```powershell
# 1. Depoyu klonlayın
git clone https://github.com/abdullahakyemez/personel-gorev-yonetim-sistemi.git
cd personel-gorev-yonetim-sistemi

# 2. Paketleri yükleyin
flutter pub get

# 3. Testleri ve analizi çalıştırın
dart analyze
flutter test

# 4. Windows üzerinde çalıştırın
flutter run -d windows
```

---

## 📦 Windows Dağıtım ve Yayınlama (Release Build)

Uygulamanın tek tıkla kurulabilir kurulum paketi Inno Setup ile üretilmektedir:
- **Uygulama Adı:** Personel ve Görev Yönetim Sistemi
- **Kısayol ve Exe Adı:** `PGYS.exe`
- **Kurulum Dosyası:** `dist/PGYS_Setup_v1.0.0.exe`

---

## 📄 Lisans ve Kullanım

Bu yazılım kurumsal personel ve operasyonel görev yönetimi amacıyla geliştirilmiştir. Tüm hakları saklıdır.
