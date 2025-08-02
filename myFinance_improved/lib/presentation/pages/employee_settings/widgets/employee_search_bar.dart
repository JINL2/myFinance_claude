// lib/presentation/pages/employee_settings/widgets/employee_search_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/employee_provider.dart';

class EmployeeSearchBar extends ConsumerStatefulWidget {
  const EmployeeSearchBar({super.key});

  @override
  ConsumerState<EmployeeSearchBar> createState() => _EmployeeSearchBarState();
}

class _EmployeeSearchBarState extends ConsumerState<EmployeeSearchBar> {
  late TextEditingController _searchController;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(employeeFilterProvider.notifier).updateSearchQuery(value);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(employeeFilterProvider.notifier).updateSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(employeeFilterProvider);
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
            child: Icon(
              Icons.search,
              color: TossColors.gray600,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name, email, or role...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (filter.searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: TossColors.gray600,
                size: 20,
              ),
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }
}