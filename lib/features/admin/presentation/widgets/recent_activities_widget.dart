import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: _getActivityIcon(index),
            ),
            title: Text(
              _getActivityTitle(index),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              _getActivitySubtitle(index),
              style: AppTextStyles.bodySmall,
            ),
            trailing: Text(
              DateFormat(
                'MMM dd, hh:mm a',
              ).format(DateTime.now().subtract(Duration(hours: index * 3))),
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
          ),
        );
      },
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
}
