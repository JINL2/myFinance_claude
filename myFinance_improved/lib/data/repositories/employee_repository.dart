// lib/data/repositories/employee_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_detail_model.dart';
import '../../domain/entities/employee_detail.dart';
import '../../core/error/exceptions.dart';

class EmployeeRepository {
  final SupabaseClient _supabase;

  EmployeeRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // Fetch all employees for a company
  Future<List<EmployeeDetail>> getEmployees(String companyId) async {
    try {
      final response = await _supabase
          .from('v_user_salary')
          .select('*')
          .eq('company_id', companyId)
          .order('full_name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      
      return data
          .map((json) => EmployeeDetailModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch employees: ${e.toString()}');
    }
  }

  // Fetch single employee details
  Future<EmployeeDetail> getEmployeeDetail(String userId) async {
    try {
      final response = await _supabase
          .from('v_user_salary')
          .select('*')
          .eq('user_id', userId)
          .single();

      return EmployeeDetailModel.fromJson(response as Map<String, dynamic>)
          .toEntity();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch employee detail: ${e.toString()}');
    }
  }

  // Update employee salary using RPC function
  Future<void> updateEmployeeSalary({
    required String salaryId,
    required double salaryAmount,
    required String salaryType,
    required String currencyId,
  }) async {
    try {
      await _supabase.rpc('update_user_salary', params: {
        'p_salary_id': salaryId,
        'p_salary_amount': salaryAmount,
        'p_salary_type': salaryType,
        'p_currency_id': currencyId,
      });
    } catch (e) {
      throw ServerException(message: 'Failed to update salary: ${e.toString()}');
    }
  }

  // Get available currencies
  Future<List<Map<String, dynamic>>> getCurrencies() async {
    try {
      final response = await _supabase
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol')
          .order('currency_code', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch currencies: ${e.toString()}');
    }
  }

  // Get employee attendance summary (last 30 days)
  Future<Map<String, dynamic>> getEmployeeAttendance(String userId) async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      
      final response = await _supabase
          .from('shift_requests')
          .select('is_late, is_approved, overtime_amount, is_extratime')
          .eq('user_id', userId)
          .gte('request_date', thirtyDaysAgo.toIso8601String());

      final List<dynamic> data = response as List<dynamic>;
      
      // Calculate attendance metrics
      int totalShifts = data.length;
      int lateCount = data.where((shift) => shift['is_late'] == true).length;
      double totalOvertime = data.fold(0.0, (sum, shift) => 
          sum + (shift['overtime_amount'] ?? 0.0));
      int approvedShifts = data.where((shift) => shift['is_approved'] == true).length;
      
      return {
        'totalShifts': totalShifts,
        'lateCount': lateCount,
        'attendanceRate': totalShifts > 0 
            ? ((totalShifts - lateCount) / totalShifts * 100).round() 
            : 100,
        'overtimeHours': totalOvertime,
        'approvedShifts': approvedShifts,
      };
    } catch (e) {
      throw ServerException(message: 'Failed to fetch attendance: ${e.toString()}');
    }
  }

  // Stream employees for real-time updates
  Stream<List<EmployeeDetail>> streamEmployees(String companyId) {
    return _supabase
        .from('v_user_salary')
        .stream(primaryKey: ['user_id'])
        .eq('company_id', companyId)
        .order('full_name', ascending: true)
        .map((data) {
          print('Employee Repository - Raw data from Supabase:');
          if (data.isNotEmpty) {
            print('First employee data: ${data.first}');
          }
          
          return data.map((json) {
            try {
              return EmployeeDetailModel.fromJson(json).toEntity();
            } catch (e) {
              print('Error parsing employee data: $e');
              print('JSON data: $json');
              rethrow;
            }
          }).toList();
        });
  }

  // Update employee role
  Future<void> updateEmployeeRole({
    required String userId,
    required String newRoleId,
  }) async {
    try {
      // First deactivate current role
      await _supabase
          .from('user_roles')
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('is_deleted', false);

      // Then create new role assignment
      await _supabase.from('user_roles').insert({
        'user_id': userId,
        'role_id': newRoleId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException(message: 'Failed to update role: ${e.toString()}');
    }
  }

  // Get all roles for a company
  Future<List<Map<String, dynamic>>> getCompanyRoles(String companyId) async {
    try {
      final response = await _supabase
          .from('roles')
          .select('role_id, role_name, description')
          .eq('company_id', companyId)
          .order('role_name', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch roles: ${e.toString()}');
    }
  }

  // Get stores for filtering
  Future<List<Map<String, dynamic>>> getCompanyStores(String companyId) async {
    try {
      final response = await _supabase
          .from('stores')
          .select('store_id, store_name')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('store_name', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch stores: ${e.toString()}');
    }
  }
}