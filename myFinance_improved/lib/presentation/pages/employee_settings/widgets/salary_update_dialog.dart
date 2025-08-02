// lib/presentation/pages/employee_settings/widgets/salary_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../domain/entities/employee_detail.dart';
import '../../../providers/employee_provider.dart';
import '../../../widgets/toss/toss_button.dart';
import '../../../widgets/toss/toss_snackbar.dart';

class SalaryUpdateDialog extends ConsumerStatefulWidget {
  final EmployeeDetail employee;

  const SalaryUpdateDialog({
    super.key,
    required this.employee,
  });

  @override
  ConsumerState<SalaryUpdateDialog> createState() => _SalaryUpdateDialogState();
}

class _SalaryUpdateDialogState extends ConsumerState<SalaryUpdateDialog> {
  late TextEditingController _amountController;
  late String _selectedType;
  late String _selectedCurrencyId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.employee.salaryAmount?.toStringAsFixed(0) ?? '',
    );
    _selectedType = widget.employee.salaryType ?? 'monthly';
    _selectedCurrencyId = widget.employee.currencyId ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _updateSalary() async {
    final amount = double.tryParse(_amountController.text);
    
    if (amount == null || amount <= 0) {
      TossSnackbar.error(
        context,
        'Please enter a valid salary amount',
      );
      return;
    }

    if (_selectedCurrencyId.isEmpty) {
      TossSnackbar.error(context, 'Please select a currency');
      return;
    }

    if (widget.employee.salaryId == null) {
      TossSnackbar.error(context, 'Cannot update salary - no salary record found');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(employeeRepositoryProvider);
      
      await repository.updateEmployeeSalary(
        salaryId: widget.employee.salaryId!,
        salaryAmount: amount,
        salaryType: _selectedType,
        currencyId: _selectedCurrencyId,
      );

      if (mounted) {
        TossSnackbar.success(context, 'Salary updated successfully');
        Navigator.of(context).pop();
        // Refresh employee data
        ref.invalidate(employeesStreamProvider);
      }
    } catch (e) {
      if (mounted) {
        TossSnackbar.error(context, 'Failed to update salary: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currenciesProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Update Salary',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Employee: ${widget.employee.fullName}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Text(
              'Current: ${widget.employee.displaySalary}',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
            SizedBox(height: TossSpacing.space6),

            // Amount input
            Text(
              'New Amount',
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TossTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                filled: true,
                fillColor: TossColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.gray300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.gray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.primary, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space4),

            // Salary type
            Text(
              'Type',
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Monthly', style: TossTextStyles.body),
                    value: 'monthly',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() => _selectedType = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: TossColors.primary,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Hourly', style: TossTextStyles.body),
                    value: 'hourly',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() => _selectedType = value!);
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: TossColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space4),

            // Currency dropdown
            Text(
              'Currency',
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            currenciesAsync.when(
              data: (currencies) => DropdownButtonFormField<String>(
                value: _selectedCurrencyId.isNotEmpty ? _selectedCurrencyId : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: TossColors.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    borderSide: BorderSide(color: TossColors.gray300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    borderSide: BorderSide(color: TossColors.gray300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    borderSide: BorderSide(color: TossColors.primary, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                ),
                hint: Text('Select currency', style: TossTextStyles.body),
                items: currencies.map((currency) {
                  return DropdownMenuItem<String>(
                    value: currency['currency_id'] as String,
                    child: Text(
                      '${currency['currency_code']} - ${currency['currency_name']}',
                      style: TossTextStyles.body,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCurrencyId = value!);
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(
                'Failed to load currencies',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space6),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.labelLarge.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                TossButton(
                  text: 'Update Salary',
                  onPressed: _isLoading ? null : _updateSalary,
                  isLoading: _isLoading,
                  size: TossButtonSize.medium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}