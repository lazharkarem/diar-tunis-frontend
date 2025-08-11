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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minLeadingWidth: 40,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getUserTypeColor(user['userType']),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              user['name'].isNotEmpty ? user['name'][0].toUpperCase() : '?',
              style: AppTextStyles.h5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'],
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user['email'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (user['isVerified'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 12, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getUserTypeColor(
                    user['userType'],
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getUserTypeColor(
                      user['userType'],
                    ).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  user['userType'].toString().toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getUserTypeColor(user['userType']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Joined ${_formatDate(user['joinDate'])}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 40,
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert, size: 20),
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
                height: 40,
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 18),
                    SizedBox(width: 8),
                    Text('View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                height: 40,
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                height: 40,
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getUserTypeColor(String userType) {
    switch (userType) {
      case 'admin':
        return AppColors.terracotta;
      case 'host':
        return AppColors.deepBlue;
      case 'guest':
        return AppColors.goldenAmber;
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
