import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserListItem({
    super.key,
    required this.user,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getUserTypeColor(user['userType']),
          child: Text(
            user['name'][0].toUpperCase(),
            style: AppTextStyles.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user['name'],
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (user['isVerified'])
              const Icon(Icons.verified, size: 16, color: AppColors.success),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'], style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getUserTypeColor(user['userType']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user['userType'].toString().toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _getUserTypeColor(user['userType']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Joined ${_formatDate(user['joinDate'])}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                onTap();
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: ListTile(
                leading: Icon(Icons.visibility),
                title: Text('View Details'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: AppColors.error),
                title: Text('Delete', style: TextStyle(color: AppColors.error)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getUserTypeColor(String userType) {
    switch (userType) {
      case 'admin':
        return AppColors.error;
      case 'host':
        return AppColors.secondary;
      case 'guest':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 30) {
      return '$difference days ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}
