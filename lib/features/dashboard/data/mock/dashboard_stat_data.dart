import 'package:flutter/material.dart';
import '../../domain/models/dashboard_stat.dart';

const dashboardStats = [
  DashboardStat(
    icon: Icons.people_alt_outlined,
    title: "Toplam Personel",
    value: "248",
    subtitle: "+12 Bu Ay",
  ),
  DashboardStat(
    icon: Icons.assignment_outlined,

    title: "Aktif Görev",

    value: "34",

    subtitle: "3 Acil",
  ),

  DashboardStat(
    icon: Icons.event_available_outlined,

    title: "İzinli Personel",

    value: "12",

    subtitle: "Bugün",
  ),

  DashboardStat(
    icon: Icons.warning_amber_outlined,

    title: "Yaklaşan Görev",

    value: "6",

    subtitle: "Bu Hafta",
  ),
];
