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
              '• Sicil no, unvan, rütbe, büro/kısım, silah-teçhizat zimmeti ve iletişim bilgileri kayıt altına alınır.\n'
              '• Kıdem süresi, personelin memuriyete başlama tarihi baz alınarak sistem tarafından otomatik hesaplanır.\n'
              '• Personel listesinde rütbe ve büro bazlı çoklu arama/filtreleme yapılabilir.\n'
              '• Sağ detay panelinden personelin özlük dökümü, aktif görevleri, izin hak ediş sayaçları ve geçmiş hareketleri incelenebilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 2: Görev Modülü
        _buildGuideTile(
          context,
          icon: Icons.event_note_outlined,
          iconColor: const Color(0xFF00875A),
          title: '2. Görevlendirme & Nöbet Planlaması',
          content:
              '• Günlük ve dönemsel görevler (Tedbir, Müsabaka, Sınav, İl Dışı vb.) oluşturulur ve personele atanır.\n'
              '• Görev tablosunda anlık durum takibi (Planlandı, Devam Ediyor, Tamamlandı, İptal) yapılır.\n'
              '• Personel atamalarında çakışan görev ve izin durumları sistem tarafından kontrol edilir.\n'
              '• "Excel Aktar" butonu kullanılarak kurumsal standartta nöbet ve görev çizelgesi Excel (.xlsx) formatında dışa aktarılır.',
        ),
        const SizedBox(height: 12),

        // Bölüm 3: İzin & Rapor Modülü
        _buildGuideTile(
          context,
          icon: Icons.beach_access_outlined,
          iconColor: const Color(0xFFD97706),
          title: '3. İzin & Rapor Takibi (Mevzuat Uyumlu)',
          content:
              '• 657 Sayılı DMK ve EGM İzin Yönergesi gereğince; 1-10 yıl kıdeme sahip personele 24 gün, 10 yıl ve üzeri personele 34 gün yıllık izin otomatik tanımlanır.\n'
              '• Devreden İzin Kuralı: Yalnızca bir önceki takvim yılına ait kullanılmayan izinler cari yıla devreder. Daha eski yıllara ait izinler mevzuat gereği iptal olur.\n'
              '• Tablodaki "Belge" butonu ile resmi izin talep formu / dilekçesi doğrudan yazdırılabilir veya PDF olarak kaydedilebilir.\n'
              '• Tüm izin ve rapor kayıtları Excel ortamına eksiksiz aktarılabilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 4: Çoklu Bilgisayar (LAN) & Güvenlik
        _buildGuideTile(
          context,
          icon: Icons.lan_outlined,
          iconColor: const Color(0xFF3F51B5),
          title: '4. Yerel Ağ (LAN) Mimarisi & Veritabanı Güvenliği',
          content:
              '• Sunucu Modu: Ana bilgisayarda etkinleştirildiğinde yerel ağ üzerinden port 8080 ile diğer bilgisayarlara hizmet verir.\n'
              '• İstemci Modu: Ağdaki diğer personeller, ana bilgisayarın IP adresini girerek gerçek zamanlı merkezi veritabanına bağlanır.\n'
              '• Veriler yerel SQLite veritabanında saklanır; buluta bağımlı olmaksızın tam kapalı devre (intranet) çalışır.\n'
              '• "Veritabanı Yedekleme" bölümünden düzenli aralıklarla yedek (.sqlite) alınması ve harici diske kopyalanması tavsiye edilir.',
        ),
        const SizedBox(height: 12),

        // Bölüm 5: Rol ve Yetkilendirme
        _buildGuideTile(
          context,
          icon: Icons.admin_panel_settings_outlined,
          iconColor: const Color(0xFF8E24AA),
          title: '5. Yetki Rolleri & Güvenlik',
          content:
              '• Büro Amiri (Admin): Tam yetkili. Personel, görev ve izin ekleme/düzenleme/silme, sistem ve LAN ayarlarını yönetme yetkisine sahiptir.\n'
              '• Görevli Memur: Personel, görev ve izin girişlerini yapabilir; silme ve kritik ayar değişiklikleri kısıtlanmıştır.\n'
              '• Salt Okunur: Yalnızca listeleri ve istatistikleri görüntüleyebilir; değişiklik yapamaz.',
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
