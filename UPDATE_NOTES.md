# PGYS – v1.0.0 Stabil Kurumsal Sürüm Notları

Personel ve Görev Yönetim Sistemi (PGYS), operasyonel birimlerin personel özlük, nöbet/görev planlama, izin/rapor takibi, resmi belge üretimi ve yerel ağ eşitleme ihtiyaçlarını karşılamak üzere stabilize edilerek yayınlanma aşamasına getirilmiştir.

---

## 🚀 Son Eklenen Özellikler ve İyileştirmeler

### 1. Personel Yönetimi
- **Yeni Nesil Filtreleme Çubuğu (`PersonnelFilterBar`):** İsim, sicil, rütbe ve büro bazlı anlık çoklu filtreleme; duyarlı (responsive) `Wrap` ve `Row` mekanizması ile sıfır taşma garantisi.
- **Toplu İşlemler Araç Çubuğu:** Çoklu personel seçimi, toplu görev atama ve seçili personelleri biçimlendirilmiş Excel formatında dışa aktarma.
- **Kıdem ve İzin Sayaçları:** 657 DMK ve EGM mevzuatına uygun 24 gün / 34 gün yıllık izin hakkı ve devreden izin takibi.

### 2. Görev ve Nöbet Modülü
- **Çoklu Personel Bağlama:** Bir göreve birden fazla personelin tek seferde atanabilmesi.
- **Çakışma Kontrolleri:** Görev atamalarında personelin izinli veya başka görevde olma durumunun denetlenmesi.
- **Excel Çizelgesi:** Nöbet ve görev dökümlerinin tek tıkla Excel (.xlsx) formatında dışa aktarımı.

### 3. İzin & Rapor ve Resmi Belge Motoru
- **Resmi İzin Dilekçesi (Word / .docx):**
  - Seçilen personel ve izin kaydı için resmi izin talep formunu Word formatında üretir (`docx_creator` & `archive`).
  - Asil Büro Amiri veya Büro Amir Vekili (Vekaleten İmza) onay makamı seçimi.
  - Vekil personelin adı ve unvanının otomatik doldurulması.
- **Çakışma Kalkanı (Overlap Guard):** Tarihleri çakışan veya mükerrer izin kayıtlarının engellenmesi.

### 4. Raporlama ve Vektörel Çıktılar
- **Dönemsel Analiz:** 1 Eylül – 31 Ağustos kurumsal çalışma dönemlerine ve serbest tarih aralığına göre raporlama.
- **Personel Karnesi (PDF):** Seçili personelin özlük kartı, görev dağılımları ve izin geçmişini kapsayan resmi vektörel PDF karnesi.
- **Kurumsal Excel Çıktıları:** İzin, görev ve personel genel çizelgeleri.

### 5. Yerel Ağ (LAN) Merkezi Sunucu & Ortak Veritabanı
- **Host-Client Mimarisi:** Ana bilgisayar (Sunucu Modu - Port 8085) ve çalışma istasyonları (İstemci Modu) arasında güvenli token doğrulamalı veri eşitleme.
- **Windows Güvenlik Duvarı Uyumluluğu:** TCP 8085 portu üzerinden yerel ağda kesintisiz iletişim.
- **Offline-First:** Ağ kesintilerinde yerel SQLite önbellek ile kesintisiz çalışma ve yeniden bağlanıldığında otomatik senkronizasyon.

### 6. Güvenlik ve Kurumsal Yönetim (RBAC)
- **İlk Giriş Parola Kalkanı:** Sistemde ilk kez açılan hesaplar (`admin` dahil) yeni güvenli şifre belirlemeye zorlanır.
- **Brute-Force Koruması:** 5 ardışık hatalı girişte 60 saniye hesap kilitleme.
- **Veritabanı Temizliği:** Tüm sahte/test personelleri yayın sürümünden arındırılmış, sıfır ilk kullanıcı veritabanı hazırlanmıştır.
- **Yedekleme & Geri Yükleme:** Tek tıkla manuel ve 12/24/168 saatlik otomatik SQLite yedeği alma.
