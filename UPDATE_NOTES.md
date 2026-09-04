# PGYS – Dışa Aktarma ve Belge Güncellemesi

Bu sürüm `lib(10).zip` ve gönderilen `Document 1.pdf` izin belgesi taslağı temel alınarak hazırlanmıştır.

## Personeller
- Seçim yapılmadığında toolbar'a **Excel Aktar** eklendi.
- Normal Excel aktarımı tüm personel listesini genel bilgilerle aktarır.
- Personel seçildiğinde **Görev Ata** ve **Excel** etkinleşir.
- Görev Ata mevcut görev formunu açar ve seçili personelleri otomatik işaretler.
- Seçili Excel aktarımı sadece işaretlenen personelleri aktarır.

## İzinler
- Yeni İzin/Düzenle paneline **İzin Belgesi** butonu eklendi.
- Seçili personel, izin türü, başlangıç tarihi, gün sayısı, adres, telefon ve tarih bilgileriyle DOCX oluşturulur.
- Windows kayıt iletişim kutusundan dosya adı ve kayıt yeri seçilebilir.
- İzin filtre toolbar'ı ortak 72 px slot yüksekliği ile hizalandı.

## Raporlar
- **2. İzin ve Rapor Raporları** bölümündeki **Toplam Gün** kartı kaldırıldı.
- Genel izin/rapor raporu için **PDF Aktar** ve **Excel Aktar** eklendi.
- Seçili personel detay raporuna **PDF Aktar** ve **Excel Aktar** eklendi.
- Çıktılar seçilen tarih aralığına göre hazırlanır ve 1 Eylül–31 Ağustos çalışma dönemlerine ayrılır.
- Seçili personel çıktılarında personel genel bilgileri, görevler, izinler ve raporlar bulunur.

## Paketler
- excel_plus
- file_selector
- pdf
- docx_creator

## Not
Gönderilen izin belgesi eki PDF olduğu için, oluşturulan Word belgesi PDF'deki düzen ve metin yapısı yeniden oluşturularak üretilir. Düzenlenebilir asıl `.docx` şablonu ayrıca verilirse, bir sonraki adımda doğrudan o Word şablonu üzerinden placeholder değiştirme yapılabilir.

## Kurulum
Proje kökünde:

```powershell
flutter pub get
flutter analyze
```
