import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/mind_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/work_provider.dart';
import 'providers/ai_provider.dart';

class KentraApp extends StatelessWidget {
  const KentraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MindProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => WorkProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Kentra MVP',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: authProvider.isAuthenticated ? '/home' : '/auth',
            onGenerateRoute: AppRoutes.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
