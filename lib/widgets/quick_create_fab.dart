import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'quick_create_modal.dart';

class QuickCreateFAB extends StatelessWidget {
  const QuickCreateFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickCreateModal(context),
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 6,
      child: const Icon(
        AppIcons.add,
        size: AppSizes.iconLarge,
      ),
    );
  }

  void _showQuickCreateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickCreateModal(),
    );
  }
}
