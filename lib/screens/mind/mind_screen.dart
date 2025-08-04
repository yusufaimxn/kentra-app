import 'package:flutter/material.dart';
import '../../core/constants.dart';

class MindScreen extends StatelessWidget {
  const MindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Journal'),
              Tab(text: 'Mind Dump'),
              Tab(text: 'Goals'),
              Tab(text: 'Progress'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildJournalTab(),
                _buildMindDumpTab(),
                _buildGoalsTab(),
                _buildProgressTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.mind,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Journal Feature',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 4',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMindDumpTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.brainDump,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Mind Dump Feature',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 4',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Goals Feature',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 4',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Progress Tracker',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Coming soon in Step 4',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
