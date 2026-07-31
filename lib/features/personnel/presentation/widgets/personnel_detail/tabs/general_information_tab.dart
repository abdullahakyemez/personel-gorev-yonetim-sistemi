import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_info_tile.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_information_section.dart';

class GeneralInformationTab extends StatelessWidget {
  final Personnel person;

  const GeneralInformationTab({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PersonnelInformationSection(
                  title: "Kimlik Bilgileri",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.badge_outlined,
                      title: "Sicil",
                      value: person.registryNumber,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.person_outlined,
                      title: "Ad Soyad",
                      value: person.fullName,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.workspace_premium_outlined,
                      title: "Rütbe",
                      value: person.rank,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.favorite_outline,
                      title: "Durum",
                      value: person.onDuty ? "Görevde" : "Görevde değil",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PersonnelInformationSection(
                  title: "Kurum Bilgileri",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.account_tree_outlined,
                      title: "Şube",
                      value: person.department,
                    ),

                    PersonnelInfoTile(
                      icon: Icons.business_outlined,
                      title: "Büro",
                      value: person.branch,
                    ),

                    PersonnelInfoTile(
                      icon: Icons.calendar_today_outlined,
                      title: "Göreve Başlama",
                      value: "belirtilmedi",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //const SizedBox(height: 20),
        //const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PersonnelInformationSection(
                  title: "İletişim Bilgileri",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.phone,
                      title: "Telefon",
                      value: person.phone,
                    ),
                    PersonnelInfoTile(
                      icon: Icons.mail_outlined,
                      title: "Email",
                      value: "Belirtilmemiş",
                    ),
                    PersonnelInfoTile(
                      icon: Icons.location_on_outlined,
                      title: "Adres",
                      value: "belirtilmedi",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PersonnelInformationSection(
                  title: "Ek Bilgiler",
                  children: [
                    PersonnelInfoTile(
                      icon: Icons.info,
                      title: "Bilgiler",
                      value: "belirtilmedi",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
