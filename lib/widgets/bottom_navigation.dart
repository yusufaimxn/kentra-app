import 'package:flutter/material.dart';
import '../core/constants.dart';

class KentraBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KentraBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.bottomNavHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home),
            activeIcon: Icon(AppIcons.homeSelected),
            label: AppStrings.homeTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.mind),
            activeIcon: Icon(AppIcons.mindSelected),
            label: AppStrings.mindTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.calendar),
            activeIcon: Icon(AppIcons.calendarSelected),
            label: AppStrings.calendarTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.work),
            activeIcon: Icon(AppIcons.workSelected),
            label: AppStrings.workTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.aiChat),
            activeIcon: Icon(AppIcons.aiChatSelected),
            label: AppStrings.aiChatTab,
          ),
        ],
      ),
    );
  }
}
