import 'package:flutter/material.dart';
import '../../core/constants.dart';

class BadgeWidget extends StatelessWidget {
  final String badgeName;
  final IconData badgeIcon;
  final Color badgeColor;
  final bool isUnlocked;
  final String description;

  const BadgeWidget({
    super.key,
    required this.badgeName,
    required this.badgeIcon,
    required this.badgeColor,
    required this.isUnlocked,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(AppSizes.paddingSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? LinearGradient(
                      colors: [badgeColor, badgeColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [AppColors.textLight, AppColors.textLight.withOpacity(0.5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: badgeColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              badgeIcon,
              color: Colors.white,
              size: AppSizes.iconLarge,
            ),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(
            badgeName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
