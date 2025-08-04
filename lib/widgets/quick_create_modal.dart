import 'package:flutter/material.dart';
import '../core/constants.dart';

class QuickCreateModal extends StatelessWidget {
  const QuickCreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderRadiusLarge),
          topRight: Radius.circular(AppSizes.borderRadiusLarge),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.textLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Row(
              children: [
                const Text(
                  AppStrings.quickCreate,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Quick create options grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.paddingMedium,
                mainAxisSpacing: AppSizes.paddingMedium,
                childAspectRatio: 1.2,
                children: [
                  _buildQuickCreateItem(
                    context,
                    AppIcons.document,
                    AppStrings.document,
                    AppColors.primary,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.table,
                    AppStrings.table,
                    AppColors.accent,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.flow,
                    AppStrings.flow,
                    AppColors.info,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.checklist,
                    AppStrings.checklist,
                    AppColors.success,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.pomodoro,
                    AppStrings.pomodoro,
                    AppColors.warning,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.mindmap,
                    AppStrings.mindmap,
                    AppColors.xp,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.chart,
                    AppStrings.chart,
                    AppColors.streak,
                  ),
                  _buildQuickCreateItem(
                    context,
                    AppIcons.brainDump,
                    AppStrings.brainDump,
                    AppColors.badge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCreateItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // TODO: Handle quick create action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Creating $label...')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
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
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
