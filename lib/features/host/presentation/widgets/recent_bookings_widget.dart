import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';

class RecentBookingsWidget extends StatelessWidget {
  const RecentBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.book_online, color: AppColors.primary),
            ),
            title: Text(
              'Booking for Property ${index + 1}',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Guest: John Doe - ${DateFormat('MMM dd, yyyy').format(DateTime.now().add(Duration(days: index * 5)))}',
              style: AppTextStyles.bodySmall,
            ),
            trailing: Text(
              '\$${(index + 1) * 100}.00',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}


