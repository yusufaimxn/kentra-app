import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/quick_create_fab.dart';
import '../../widgets/app_drawer.dart';
import '../mind/mind_screen.dart';
import '../calendar/calendar_screen.dart';
import '../work/work_screen.dart';
import '../ai/ai_chat_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const MindScreen(),
    const CalendarScreen(),
    const WorkScreen(),
    const AIChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: KentraBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: const QuickCreateFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return AppStrings.homeTab;
      case 1:
        return AppStrings.mindTab;
      case 2:
        return AppStrings.calendarTab;
      case 3:
        return AppStrings.workTab;
      case 4:
        return AppStrings.aiChatTab;
      default:
        return AppStrings.appName;
    }
  }
}
