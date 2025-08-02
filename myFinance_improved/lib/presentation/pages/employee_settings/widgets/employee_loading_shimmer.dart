// lib/presentation/pages/employee_settings/widgets/employee_loading_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';

class EmployeeLoadingShimmer extends StatelessWidget {
  const EmployeeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: TossSpacing.space3),
          child: _buildShimmerCard(),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: TossColors.gray200,
      highlightColor: TossColors.gray100,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: TossSpacing.space4),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name
                    Container(
                      width: 180,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    
                    // Role
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Container(
                          width: 60,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TossSpacing.space2),
                    
                    // Salary
                    Container(
                      width: 120,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                  ],
                ),
              ),
              
              // More button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}