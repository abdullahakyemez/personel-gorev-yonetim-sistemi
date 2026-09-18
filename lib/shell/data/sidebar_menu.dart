import 'package:flutter/material.dart';
import '../models/sidebar_menu_item.dart';

const sidebarMenuItems = [
  SidebarMenuItem(
    title: "Ana Sayfa",
    icon: Icons.grid_view_rounded,
    route: '/',
  ),
  SidebarMenuItem(
    title: 'Personeller',
    icon: Icons.people_outline,
    route: '/personeller',
  ),
  SidebarMenuItem(
    title: 'Görevler',
    icon: Icons.event_note_outlined,
    route: '/gorevler',
  ),
  SidebarMenuItem(
    title: 'İzin & Rapor',
    icon: Icons.description_outlined,
    route: '/izinler',
  ),
  SidebarMenuItem(
    title: 'Raporlar',
    icon: Icons.bar_chart_outlined,
    route: '/raporlar',
  ),
  SidebarMenuItem(
    title: 'Kullanıcılar',
    icon: Icons.manage_accounts_outlined,
    route: '/kullanicilar',
  ),
  SidebarMenuItem(
    title: 'Ayarlar',
    icon: Icons.settings_outlined,
    route: '/ayarlar',
  ),
];
