// lib/presentation/pages/employee_settings/widgets/tabs/history_tab.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../core/themes/toss_shadows.dart';
import '../../../../../domain/entities/employee_detail.dart';

class HistoryTab extends StatelessWidget {
  final EmployeeDetail employee;

  const HistoryTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    // Mock history data - in real app, fetch from database
    final historyItems = [
      {
        'date': DateTime.now().subtract(Duration(days: 5)),
        'type': 'salary_update',
        'description': 'Salary updated from \$4,500 to \$5,000',
        'updatedBy': 'John Admin',
      },
      {
        'date': DateTime.now().subtract(Duration(days: 30)),
        'type': 'role_change',
        'description': 'Role changed from Cashier to Manager',
        'updatedBy': 'Sarah HR',
      },
      {
        'date': DateTime.now().subtract(Duration(days: 90)),
        'type': 'store_transfer',
        'description': 'Transferred from Store A to Store B',
        'updatedBy': 'System',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: TossShadows.shadow2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change History',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space4),
                
                if (historyItems.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space8),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: TossColors.gray400,
                          ),
                          SizedBox(height: TossSpacing.space3),
                          Text(
                            'No history available',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...historyItems.map((item) => _buildHistoryItem(
                    item['date'] as DateTime,
                    item['type'] as String,
                    item['description'] as String,
                    item['updatedBy'] as String,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    DateTime date,
    String type,
    String description,
    String updatedBy,
  ) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'salary_update':
        icon = Icons.attach_money;
        color = TossColors.success;
        break;
      case 'role_change':
        icon = Icons.swap_horiz;
        color = TossColors.primary;
        break;
      case 'store_transfer':
        icon = Icons.store;
        color = TossColors.warning;
        break;
      default:
        icon = Icons.info_outline;
        color = TossColors.gray600;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          SizedBox(width: TossSpacing.space3),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Row(
                  children: [
                    Text(
                      _formatDate(date),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    Text(
                      'by $updatedBy',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}