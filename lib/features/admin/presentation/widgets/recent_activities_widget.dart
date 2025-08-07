import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Replace with actual data
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getActivityColor(index).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getActivityIcon(index).icon,
                    color: _getActivityColor(index),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getActivityTitle(index),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getActivitySubtitle(index),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd, hh:mm a')
                      .format(DateTime.now().subtract(Duration(hours: index * 3))),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Icon _getActivityIcon(int index) {
    switch (index % 4) {
      case 0:
        return const Icon(Icons.person_add, color: AppColors.info);
      case 1:
        return const Icon(Icons.home_work, color: AppColors.secondary);
      case 2:
        return const Icon(Icons.book_online, color: AppColors.success);
      case 3:
        return const Icon(Icons.report_problem, color: AppColors.error);
      default:
        return const Icon(Icons.info_outline, color: AppColors.textSecondary);
    }
  }

  String _getActivityTitle(int index) {
    switch (index % 4) {
      case 0:
        return 'New user registered: John Doe';
      case 1:
        return 'Property \'Luxury Villa\' added by Host A';
      case 2:
        return 'New booking for \'Cozy Apartment\'';
      case 3:
        return 'Report: Payment issue for Booking #12345';
      default:
        return 'Activity update';
    }
  }

  String _getActivitySubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'User type: Guest';
      case 1:
        return 'Status: Pending approval';
      case 2:
        return 'Guest: Jane Smith, Dates: 10/03 - 15/03';
      case 3:
        return 'Affected user: John Doe';
      default:
        return 'Details about the activity';
    }
  }

  Color _getActivityColor(int index) {
    switch (index % 4) {
      case 0:
        return AppColors.deepBlue;
      case 1:
        return AppColors.terracotta;
      case 2:
        return AppColors.oliveGreen;
      case 3:
        return AppColors.goldenAmber;
      default:
        return AppColors.textSecondary;
    }
  }
}
