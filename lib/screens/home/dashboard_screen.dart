import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/mind_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../widgets/gamification/streak_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MindProvider>().loadStreaks();
      context.read<CalendarProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          _buildWelcomeSection(),
          const SizedBox(height: AppSizes.paddingLarge),
          
          // Mindspace highlight card
          _buildMindspaceHighlight(),
          const SizedBox(height: AppSizes.paddingLarge),
          
          // Quick create bar
          _buildQuickCreateBar(),
          const SizedBox(height: AppSizes.paddingLarge),
          
          // Recent projects section
          _buildRecentProjects(),
          const SizedBox(height: AppSizes.paddingLarge),
          
          // CTA buttons
          _buildCTAButtons(),
          const SizedBox(height: AppSizes.paddingLarge),
          
          // Achievement banners
          _buildAchievementBanners(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final displayName = user?.displayName ?? 'there';
        final timeOfDay = _getTimeOfDay();
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$timeOfDay, $displayName!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              const Text(
                'Ready to make today productive?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMindspaceHighlight() {
    return Consumer2<MindProvider, CalendarProvider>(
      builder: (context, mindProvider, calendarProvider, child) {
        final journalStreak = mindProvider.streaks['journal'] ?? 0;
        final todayTasks = calendarProvider.todayTasks;
        final completedTasks = todayTasks.where((task) => task.isCompleted).length;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(AppIcons.mind, color: AppColors.primary),
                    const SizedBox(width: AppSizes.paddingSmall),
                    const Text(
                      'Mindspace Highlight',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    StreakWidget(
                      streakCount: journalStreak,
                      streakType: 'Journal',
                      isActive: journalStreak > 0,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Today\'s Tasks',
                        '$completedTasks/${todayTasks.length}',
                        AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingMedium),
                    Expanded(
                      child: _buildStatCard(
                        'Journal Entries',
                        '${mindProvider.journalEntries.length}',
                        AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCreateBar() {
    final quickCreateItems = [
      {'icon': AppIcons.document, 'label': AppStrings.document, 'color': AppColors.primary},
      {'icon': AppIcons.table, 'label': AppStrings.table, 'color': AppColors.accent},
      {'icon': AppIcons.flow, 'label': AppStrings.flow, 'color': AppColors.info},
      {'icon': AppIcons.checklist, 'label': AppStrings.checklist, 'color': AppColors.success},
      {'icon': AppIcons.pomodoro, 'label': AppStrings.pomodoro, 'color': AppColors.warning},
      {'icon': AppIcons.mindmap, 'label': AppStrings.mindmap, 'color': AppColors.xp},
      {'icon': AppIcons.chart, 'label': AppStrings.chart, 'color': AppColors.streak},
      {'icon': AppIcons.brainDump, 'label': AppStrings.brainDump, 'color': AppColors.badge},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Create',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickCreateItems.length,
            itemBuilder: (context, index) {
              final item = quickCreateItems[index];
              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: AppSizes.paddingMedium),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Creating ${item['label']}...')),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          border: Border.all(
                            color: (item['color'] as Color).withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingSmall),
                      Text(
                        item['label'] as String,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Projects',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3, // Placeholder count
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: AppSizes.paddingMedium),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingSmall),
                        const Text(
                          'Project description goes here...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        LinearProgressIndicator(
                          value: (index + 1) * 0.3,
                          backgroundColor: AppColors.textLight.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Project feature coming soon!')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ),
        const SizedBox(width: AppSizes.paddingMedium),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Workspace feature coming soon!')),
              );
            },
            icon: const Icon(Icons.folder_outlined),
            label: const Text('Create Workspace'),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBanners() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.badge.withOpacity(0.2), AppColors.badge.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(color: AppColors.badge.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                AppIcons.badge,
                color: AppColors.badge,
                size: AppSizes.iconLarge,
              ),
              const SizedBox(width: AppSizes.paddingMedium),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Steps Badge',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.badge,
                      ),
                    ),
                    Text(
                      'Welcome to Kentra! You\'ve taken your first step.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
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

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
