import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_spacing.dart';

class UsageGuideSection extends StatelessWidget {
  const UsageGuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Giriş Kartı
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF14272F),
                      const Color(0xFF1E3740),
                    ]
                  : [
                      const Color(0xFF0F2027),
                      const Color(0xFF223E47),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personel ve Görev Yönetim Sistemi (PGYS)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Emniyet Genel Müdürlüğü birimlerinin personel, nöbet, görevlendirme, izin ve rapor süreçlerinin mevzuata tam uyumlu, güvenli ve merkezi idaresi için tasarlanmıştır.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Bölüm 1: Personel Modülü
        _buildGuideTile(
          context,
          icon: Icons.badge_outlined,
          iconColor: const Color(0xFF1E5F74),
          title: '1. Personel Yönetimi & Sicil Takibi',
          content:
              '• Sicil no, unvan, rütbe, şube, büro, silah-teçhizat zimmeti ve iletişim bilgileri eksiksiz kayıt altına alınır.\n'
              '• Kıdem süresi memuriyete başlama tarihi üzerinden otomatik hesaplanır ve izin hakediş sayaçlarına yansıtılır.\n'
              '• Üst filtre çubuğundan ad-soyad, sicil, rütbe ve büro bazlı anlık çoklu filtreleme yapılabilir.\n'
              '• Çoklu personel seçilerek tek tıkla toplu görev atanabilir ve seçilen personeller biçimlendirilmiş Excel formatında dışa aktarılabilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 2: Görev Modülü
        _buildGuideTile(
          context,
          icon: Icons.event_note_outlined,
          iconColor: const Color(0xFF00875A),
          title: '2. Görevlendirme & Nöbet Planlaması',
          content:
              '• Günlük ve dönemsel görevler (Nöbet, Devriye, Tedbir, Müsabaka, Sınav vb.) oluşturulur ve personele atanır.\n'
              '• Bir göreve birden fazla personel tek seferde bağlanabilir; çakışan görev ve izin durumları sistem tarafından denetlenir.\n'
              '• Görev tablosunda anlık durum takibi (Planlandı, Devam Ediyor, Tamamlandı, İptal) yapılır.\n'
              '• "Excel Aktar" butonu ile kurumsal standartta nöbet ve görev çizelgesi Excel (.xlsx) formatında kaydedilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 3: İzin & Rapor Modülü
        _buildGuideTile(
          context,
          icon: Icons.beach_access_outlined,
          iconColor: const Color(0xFFD97706),
          title: '3. İzin & Sağlık Raporları Takibi (Mevzuat Uyumlu)',
          content:
              '• 657 Sayılı DMK ve EGM İzin Yönergesi gereğince; 1-10 yıl kıdeme 24 gün, 10 yıl ve üzerine 34 gün yıllık izin tanımlanır.\n'
              '• Devreden İzin Kuralı: Yalnızca bir önceki takvim yılına ait kullanılmayan izinler cari yıla devreder. Daha eski yıllar iptal olur.\n'
              '• Çakışma Kalkanı: Aynı personele mükerrer veya tarihleri çakışan izin girişi engellenir.\n'
              '• Resmi İzin Dilekçesi (Word / .docx): Tablodan seçilen izin için "Belge Oluştur" butonu ile resmi izin talep formu Word olarak üretilir. Asil Büro Amiri veya Vekil (Büro Amir V.) onay makamı ve vekil personel seçilebilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 4: Raporlar ve Çıktılar
        _buildGuideTile(
          context,
          icon: Icons.assessment_outlined,
          iconColor: const Color(0xFF0288D1),
          title: '4. Dönemsel Raporlama & Vektörel PDF Çıktıları',
          content:
              '• 1 Eylül – 31 Ağustos kurumsal çalışma dönemlerine veya istenen özel tarih aralığına göre raporlama yapılır.\n'
              '• Seçili personel için özlük dökümü, görev dağılımları ve izin geçmişini kapsayan resmi "Personel Karnesi & Faaliyet Raporu" (PDF) tek tıkla üretilir.\n'
              '• Genel görev ve izin listeleri detaylı istatistiklerle Excel (.xlsx) ortamına aktarılabilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 5: Çoklu Bilgisayar (LAN) & Ortak Veritabanı
        _buildGuideTile(
          context,
          icon: Icons.lan_outlined,
          iconColor: const Color(0xFF3F51B5),
          title: '5. Merkezi Sunucu (Host) & Çoklu İstemci (Client) Mimarisi',
          content:
              '• Sunucu Modu (Ana Bilgisayar): Yerel IP ve port (varsayılan 8085) üzerinden ağdaki diğer bilgisayarlara hizmet verir.\n'
              '• Windows Güvenlik Duvarı: Sunucu bilgisayarda TCP 8085 portuna gelen bağlantı izni verilmelidir.\n'
              '• İstemci Modu (Diğer Bilgisayarlar): Sunucunun yerel IP adresi, port ve güvenlik jetonu girilerek merkezi veritabanına bağlanılır.\n'
              '• Çift Yönlü Senkronizasyon: İstemcilerin yaptığı tüm işlemler anında ana sunucuya işlenir ve tüm bilgisayarlarda güncellenir.\n'
              '• Çevrimdışı Çalışma: Ağ kesilse dahi istemciler yerel önbellek ile kesintisiz çalışır; bağlantı geldiğinde otomatik eşitlenir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 6: Rol, Güvenlik & Yedekleme
        _buildGuideTile(
          context,
          icon: Icons.admin_panel_settings_outlined,
          iconColor: const Color(0xFF8E24AA),
          title: '6. Yetki Rolleri, Şifre Güvenliği & Yedekleme',
          content:
              '• 6 Kademeli Yetkilendirme (RBAC): Büro Amiri (Süper Admin), Yönetici, Operatör, Grup Amiri, Ekip Görevlisi ve Salt Okunur rolleri mevcuttur.\n'
              '• İlk Giriş Kalkanı: Yeni tanımlanan tüm kullanıcılar ilk oturumda güvenli yeni şifre belirlemeye zorlanır.\n'
              '• Hesap Kitleme: Arka arkaya 5 hatalı şifre denemesinde hesap 60 saniye süreyle otomatik olarak kilitlenir.\n'
              '• Otomatik Yedekleme: Ayarlar üzerinden 12, 24 veya 168 saatlik döngülerle otomatik SQLite veritabanı yedeği alınır ve harici konumlara aktarılabilir.',
        ),
      ],
    );
  }

  Widget _buildGuideTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F2027),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: isDark
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.85)
                  : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
