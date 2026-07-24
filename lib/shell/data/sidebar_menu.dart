import 'package:flutter/material.dart';
import '../models/sidebar_menu_item.dart';

const sidebarMenuItems = [
  SidebarMenuItem(
    title: "Dashboard",
    icon: Icons.dashboard_outlined,
    route: '/',
  ),
  SidebarMenuItem(
    title: 'Personeller',
    icon: Icons.people_outline,
    route: '/personeller',
  ),
  SidebarMenuItem(
    title: 'Görevler',
    icon: Icons.assignment_outlined,
    route: '/gorevler',
  ),
  SidebarMenuItem(
    title: 'İzinler',
    icon: Icons.event_available_outlined,
    route: '/izinler',
  ),
  SidebarMenuItem(
    title: 'Raporlar',
    icon: Icons.bar_chart_outlined,
    route: '/raporlar',
  ),
  SidebarMenuItem(
    title: 'Ayarlar',
    icon: Icons.settings_outlined,
    route: '/ayarlar',
  ),
];
