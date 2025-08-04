import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Grid'),
              Tab(text: 'Kanban'),
              Tab(text: 'Priority'),
              Tab(text: 'Focus'),
              Tab(text: 'Analytics'),
              Tab(text: 'Automation'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildGridView(),
                _buildKanbanView(),
                _buildPriorityView(),
                _buildFocusView(),
                _buildAnalyticsView(),
                _buildAutomationView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.calendar,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Calendar Grid View',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 5',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.view_column,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Kanban Board',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 5',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.priority_high,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Priority Matrix',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 5',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.center_focus_strong,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Focus Planner',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 5',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.chart,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Analytics Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 5',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Automation Rules',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 5',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
