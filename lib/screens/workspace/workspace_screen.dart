import 'package:flutter/material.dart';
import '../../core/constants.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Workspace Feature',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              'Coming soon in Step 8',
              style: TextStyle(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
