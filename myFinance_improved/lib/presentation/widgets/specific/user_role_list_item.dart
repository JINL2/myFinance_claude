// lib/presentation/widgets/specific/user_role_list_item.dart

import 'package:flutter/material.dart';
import '../../../domain/entities/user_role_info.dart';
import '../toss/toss_card.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/utils/role_color_utils.dart';

class UserRoleListItem extends StatelessWidget {
  final UserRoleInfo user;
  final bool canEdit;
  final bool isLoading;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const UserRoleListItem({
    super.key,
    required this.user,
    this.canEdit = false,
    this.isLoading = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: TossCard(
        onTap: canEdit && user.canEditRole && !isLoading ? onTap : null,
        backgroundColor: isSelected 
            ? TossColors.primary.withOpacity(0.05)
            : Colors.white,
        child: Row(
        children: [
          // Selection indicator
          if (isSelected)
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (isSelected) SizedBox(width: TossSpacing.space3),

          // User Avatar
          _buildAvatar(),
          SizedBox(width: TossSpacing.space3),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: TossSpacing.space1),
                Row(
                  children: [
                    // Role Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: RoleColorUtils.getRoleColor(user.roleName).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.roleName,
                        style: TossTextStyles.caption.copyWith(
                          color: RoleColorUtils.getRoleColor(user.roleName),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    // Email
                    Expanded(
                      child: Text(
                        user.email,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status indicators
          if (isLoading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
              ),
            )
          else if (canEdit && user.canEditRole)
            Icon(
              Icons.chevron_right,
              size: 24,
              color: TossColors.gray400,
            )
          else if (!user.canEditRole)
            Icon(
              Icons.lock_outline,
              size: 20,
              color: TossColors.gray300,
            ),
        ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (user.hasProfileImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          user.profileImage!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getAvatarColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: TossTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    // Generate consistent color based on user ID
    final hash = user.userId.hashCode;
    final colors = [
      TossColors.primary,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[hash % colors.length];
  }

}