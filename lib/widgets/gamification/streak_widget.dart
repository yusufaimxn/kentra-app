import 'package:flutter/material.dart';
import '../../core/constants.dart';

class StreakWidget extends StatelessWidget {
  final int streakCount;
  final String streakType;
  final bool isActive;

  const StreakWidget({
    super.key,
    required this.streakCount,
    required this.streakType,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [AppColors.streak, AppColors.streak.withOpacity(0.8)]
              : [AppColors.textLight, AppColors.textLight.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: (isActive ? AppColors.streak : AppColors.textLight)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.streak,
            color: Colors.white,
            size: AppSizes.iconMedium,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streakCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                streakType,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
