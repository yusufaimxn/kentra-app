import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Accent Colors
  static const Color accent = Color(0xFF10B981);
  static const Color accentLight = Color(0xFF34D399);
  static const Color accentDark = Color(0xFF059669);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  
  // Background Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Gamification Colors
  static const Color streak = Color(0xFFFF6B35);
  static const Color badge = Color(0xFFFFD700);
  static const Color xp = Color(0xFF8B5CF6);
}

class AppSizes {
  // Padding & Margins
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double borderRadius = 12.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 16.0;
  
  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  
  // Button Heights
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  
  // App Bar
  static const double appBarHeight = 56.0;
  
  // Bottom Navigation
  static const double bottomNavHeight = 60.0;
  
  // FAB
  static const double fabSize = 56.0;
}

class AppIcons {
  // Bottom Navigation Icons
  static const IconData home = Icons.home_outlined;
  static const IconData homeSelected = Icons.home;
  static const IconData mind = Icons.psychology_outlined;
  static const IconData mindSelected = Icons.psychology;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData calendarSelected = Icons.calendar_today;
  static const IconData work = Icons.work_outline;
  static const IconData workSelected = Icons.work;
  static const IconData aiChat = Icons.smart_toy_outlined;
  static const IconData aiChatSelected = Icons.smart_toy;
  
  // Quick Create Icons
  static const IconData document = Icons.description_outlined;
  static const IconData table = Icons.table_chart_outlined;
  static const IconData flow = Icons.account_tree_outlined;
  static const IconData checklist = Icons.checklist_outlined;
  static const IconData pomodoro = Icons.timer_outlined;
  static const IconData mindmap = Icons.hub_outlined;
  static const IconData chart = Icons.bar_chart_outlined;
  static const IconData brainDump = Icons.lightbulb_outlined;
  
  // Common Icons
  static const IconData add = Icons.add;
  static const IconData menu = Icons.menu;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData settings = Icons.settings_outlined;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData more = Icons.more_vert;
  
  // Gamification Icons
  static const IconData streak = Icons.local_fire_department;
  static const IconData badge = Icons.military_tech;
  static const IconData xp = Icons.stars;
  static const IconData level = Icons.trending_up;
}

class AppStrings {
  // App
  static const String appName = 'Kentra MVP';
  
  // Bottom Navigation
  static const String homeTab = 'Home';
  static const String mindTab = 'Mind';
  static const String calendarTab = 'Calendar';
  static const String workTab = 'Work';
  static const String aiChatTab = 'AI Chat';
  
  // Quick Create
  static const String quickCreate = 'Quick Create';
  static const String document = 'Document';
  static const String table = 'Table';
  static const String flow = 'Flow';
  static const String checklist = 'Checklist';
  static const String pomodoro = 'Pomodoro';
  static const String mindmap = 'Mindmap';
  static const String chart = 'Chart';
  static const String brainDump = 'Brain Dump';
  
  // Common
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String create = 'Create';
  static const String update = 'Update';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
}
