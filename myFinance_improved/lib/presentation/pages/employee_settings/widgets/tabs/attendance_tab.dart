// lib/presentation/pages/employee_settings/widgets/tabs/attendance_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../core/themes/toss_shadows.dart';
import '../../../../../domain/entities/employee_detail.dart';
import '../../../../providers/employee_provider.dart';

class AttendanceTab extends ConsumerWidget {
  final EmployeeDetail employee;

  const AttendanceTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(
      employeeAttendanceProvider(employee.userId),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attendance Summary
          attendanceAsync.when(
            data: (attendance) => _buildAttendanceSummary(attendance),
            loading: () => _buildLoadingCard(),
            error: (error, _) => _buildErrorCard(error.toString()),
          ),
          SizedBox(height: TossSpacing.space4),

          // Monthly Calendar View
          _buildMonthlyCalendar(),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary(Map<String, dynamic> attendance) {
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
            'Last 30 Days Summary',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space4),

          // Metrics grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Attendance Rate',
                  '${attendance['attendanceRate']}%',
                  Icons.check_circle_outline,
                  TossColors.success,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMetricCard(
                  'Late Arrivals',
                  '${attendance['lateCount']}',
                  Icons.schedule,
                  TossColors.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Overtime Hours',
                  '${attendance['overtimeHours']}h',
                  Icons.timer,
                  TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMetricCard(
                  'Total Shifts',
                  '${attendance['totalShifts']}',
                  Icons.event_available,
                  TossColors.gray600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            value,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCalendar() {
    // Simplified calendar view - in real app, use table_calendar package
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
            'Monthly View',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          Center(
            child: Text(
              'Calendar view coming soon',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.shadow2,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: TossColors.error),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              'Failed to load attendance data',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}