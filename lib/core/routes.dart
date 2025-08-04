import 'package:flutter/material.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/mind/mind_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/work/work_screen.dart';
import '../screens/ai/ai_chat_screen.dart';
import '../screens/workspace/workspace_screen.dart';
import '../screens/project/project_screen.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String mind = '/mind';
  static const String calendar = '/calendar';
  static const String work = '/work';
  static const String aiChat = '/ai-chat';
  static const String workspace = '/workspace';
  static const String project = '/project';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case mind:
        return MaterialPageRoute(builder: (_) => const MindScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case work:
        return MaterialPageRoute(builder: (_) => const WorkScreen());
      case aiChat:
        return MaterialPageRoute(builder: (_) => const AIChatScreen());
      case workspace:
        return MaterialPageRoute(builder: (_) => const WorkspaceScreen());
      case project:
        return MaterialPageRoute(builder: (_) => const ProjectScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
