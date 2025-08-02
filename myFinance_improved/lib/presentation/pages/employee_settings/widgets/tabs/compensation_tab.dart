// lib/presentation/pages/employee_settings/widgets/tabs/compensation_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../core/themes/toss_shadows.dart';
import '../../../../../domain/entities/employee_detail.dart';
import '../../../../providers/employee_provider.dart';
import '../salary_update_dialog.dart';

class CompensationTab extends ConsumerWidget {
  final EmployeeDetail employee;

  const CompensationTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Salary Section
          _buildSalaryCard(context, ref),
          SizedBox(height: TossSpacing.space4),
          
          // Total Compensation Breakdown
          _buildCompensationBreakdown(context),
          SizedBox(height: TossSpacing.space4),
          
          // Salary History
          _buildSalaryHistory(context),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.shadow2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Salary',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.edit, size: 18),
                label: Text('Edit'),
                onPressed: () => _showSalaryEditDialog(context, ref),
                style: TextButton.styleFrom(
                  foregroundColor: TossColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          
          // Salary amount
          Text(
            employee.displaySalary,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
              fontFamily: 'JetBrains Mono',
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          
          // Additional info
          if (employee.updatedAt != null)
            Text(
              'Last updated: ${_formatDate(employee.updatedAt!)}',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompensationBreakdown(BuildContext context) {
    // This is mock data - in real app, fetch from attendance/bonus data
    final baseSalary = employee.salaryAmount ?? 0;
    final overtime = 750.0;
    final bonus = 500.0;
    final deductions = 50.0;
    final total = baseSalary + overtime + bonus - deductions;

    return Container(
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
            'Total Compensation (This Month)',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          _buildCompensationRow(
            'Base Salary',
            baseSalary,
            employee.currencySymbol ?? '\$',
          ),
          _buildCompensationRow(
            'Overtime',
            overtime,
            employee.currencySymbol ?? '\$',
            isAddition: true,
          ),
          _buildCompensationRow(
            'Performance Bonus',
            bonus,
            employee.currencySymbol ?? '\$',
            isAddition: true,
          ),
          _buildCompensationRow(
            'Late Deductions',
            deductions,
            employee.currencySymbol ?? '\$',
            isDeduction: true,
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Divider(color: TossColors.gray200),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                '${employee.currencySymbol ?? '\$'}${total.toStringAsFixed(2)}',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompensationRow(
    String label,
    double amount,
    String currency, {
    bool isAddition = false,
    bool isDeduction = false,
  }) {
    final prefix = isAddition ? '+ ' : (isDeduction ? '- ' : '');
    final color = isDeduction ? TossColors.error : TossColors.gray700;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          Text(
            '$prefix$currency${amount.toStringAsFixed(2)}',
            style: TossTextStyles.body.copyWith(
              color: color,
              fontFamily: 'JetBrains Mono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryHistory(BuildContext context) {
    // Mock salary history - in real app, fetch from database
    final history = [
      {'date': DateTime(2024, 1, 1), 'from': 4500.0, 'to': 5000.0},
      {'date': DateTime(2023, 7, 1), 'from': 4000.0, 'to': 4500.0},
      {'date': DateTime(2023, 1, 1), 'from': 0.0, 'to': 4000.0},
    ];

    return Container(
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
            'Salary History',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          ...history.map((item) => _buildHistoryItem(
            item['date'] as DateTime,
            item['from'] as double,
            item['to'] as double,
            employee.currencySymbol ?? '\$',
          )),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    DateTime date,
    double fromAmount,
    double toAmount,
    String currency,
  ) {
    final percentage = fromAmount > 0 
      ? ((toAmount - fromAmount) / fromAmount * 100).toStringAsFixed(1)
      : '100';
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: TossColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Row(
                  children: [
                    Text(
                      fromAmount > 0 
                        ? '$currency${fromAmount.toStringAsFixed(0)} → $currency${toAmount.toStringAsFixed(0)}'
                        : 'Hired at $currency${toAmount.toStringAsFixed(0)}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                    if (fromAmount > 0) ...[
                      SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space1,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          '+$percentage%',
                          style: TossTextStyles.labelSmall.copyWith(
                            color: TossColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSalaryEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SalaryUpdateDialog(employee: employee),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}