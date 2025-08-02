// lib/presentation/pages/employee_settings/widgets/tabs/profile_tab.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../core/themes/toss_shadows.dart';
import '../../../../../domain/entities/employee_detail.dart';

class ProfileTab extends StatelessWidget {
  final EmployeeDetail employee;

  const ProfileTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Information
          _buildSection(
            title: 'Personal Information',
            children: [
              _buildInfoRow('Full Name', employee.fullName),
              _buildInfoRow('Email', employee.email ?? 'No email' ?? 'No email'),
              _buildInfoRow('Employee ID', employee.userId),
              if (employee.firstName != null)
                _buildInfoRow('First Name', employee.firstName!),
              if (employee.lastName != null)
                _buildInfoRow('Last Name', employee.lastName!),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Employment Details
          _buildSection(
            title: 'Employment Details',
            children: [
              _buildInfoRow('Role', employee.roleName ?? 'Unknown'),
              _buildInfoRow('Company', employee.companyName ?? 'N/A'),
              _buildInfoRow('Store', employee.storeName ?? 'N/A'),
              _buildInfoRow('Status', employee.status),
              if (employee.createdAt != null)
                _buildInfoRow('Join Date', _formatDate(employee.createdAt!)),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Contact Information
          _buildSection(
            title: 'Contact Information',
            children: [
              _buildInfoRow('Primary Email', employee.email ?? 'No email' ?? 'No email'),
              _buildInfoRow('Phone', 'Not available'),
              _buildInfoRow('Emergency Contact', 'Not available'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
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
            title,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}