import 'package:flutter/material.dart';
import '../../core/constants.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Management Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.paddingLarge),
          
          _buildToolCategory(
            'Project Tools',
            [
              {'name': 'Gantt Chart', 'icon': Icons.timeline, 'color': AppColors.primary},
              {'name': 'WBS', 'icon': Icons.account_tree, 'color': AppColors.accent},
              {'name': 'Agile Board', 'icon': Icons.dashboard, 'color': AppColors.info},
              {'name': 'CPM', 'icon': Icons.route, 'color': AppColors.success},
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingLarge),
          
          _buildToolCategory(
            'Quality Tools',
            [
              {'name': 'Flowchart', 'icon': AppIcons.flow, 'color': AppColors.warning},
              {'name': 'Pareto Chart', 'icon': AppIcons.chart, 'color': AppColors.xp},
              {'name': 'Fishbone', 'icon': Icons.device_hub, 'color': AppColors.streak},
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingLarge),
          
          _buildToolCategory(
            'Risk Tools',
            [
              {'name': 'SWOT Analysis', 'icon': Icons.grid_view, 'color': AppColors.error},
              {'name': 'Impact Matrix', 'icon': Icons.scatter_plot, 'color': AppColors.badge},
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingLarge),
          
          _buildToolCategory(
            'Team Tools',
            [
              {'name': 'Delegation Matrix', 'icon': Icons.people, 'color': AppColors.primary},
              {'name': 'Feedback Board', 'icon': Icons.feedback, 'color': AppColors.accent},
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingLarge),
          
          _buildToolCategory(
            'Decision Tools',
            [
              {'name': 'Stakeholder Analysis', 'icon': Icons.groups, 'color': AppColors.info},
              {'name': 'Decision Tree', 'icon': Icons.account_tree, 'color': AppColors.success},
              {'name': 'Scrum Board', 'icon': Icons.view_kanban, 'color': AppColors.warning},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCategory(String title, List<Map<String, dynamic>> tools) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.paddingMedium,
            mainAxisSpacing: AppSizes.paddingMedium,
            childAspectRatio: 1.5,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return _buildToolCard(
              tool['name'] as String,
              tool['icon'] as IconData,
              tool['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildToolCard(String name, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to specific tool
        },
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppSizes.iconLarge,
                color: color,
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Text(
                'Coming soon in Step 6',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
