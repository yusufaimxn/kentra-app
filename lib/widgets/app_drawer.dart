import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingMedium),
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingSmall),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Text(
                          authProvider.user?.email ?? 'user@kentra.app',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  AppIcons.notifications,
                  'Notifications',
                  () => _handleNotifications(context),
                ),
                _buildDrawerItem(
                  context,
                  AppIcons.settings,
                  'Settings',
                  () => _handleSettings(context),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  AppIcons.streak,
                  'Streaks & Badges',
                  () => _handleStreaks(context),
                ),
                _buildDrawerItem(
                  context,
                  Icons.help_outline,
                  'Help & Support',
                  () => _handleHelp(context),
                ),
                _buildDrawerItem(
                  context,
                  Icons.info_outline,
                  'About',
                  () => _handleAbout(context),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  'Sign Out',
                  () => _handleSignOut(context),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _handleNotifications(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications feature coming soon!')),
    );
  }

  void _handleSettings(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings feature coming soon!')),
    );
  }

  void _handleStreaks(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to streaks screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Streaks & Badges feature coming soon!')),
    );
  }

  void _handleHelp(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to help screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & Support feature coming soon!')),
    );
  }

  void _handleAbout(BuildContext context) {
    Navigator.pop(context);
    // TODO: Show about dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Kentra MVP'),
        content: const Text('Version 1.0.0\nBuilt with Flutter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSignOut(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
