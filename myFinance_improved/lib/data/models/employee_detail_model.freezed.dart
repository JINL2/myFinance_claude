// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmployeeDetailModel _$EmployeeDetailModelFromJson(Map<String, dynamic> json) {
  return _EmployeeDetailModel.fromJson(json);
}

/// @nodoc
mixin _$EmployeeDetailModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName =>
      throw _privateConstructorUsedError; // Note: email is not in v_user_salary view, making it optional
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage =>
      throw _privateConstructorUsedError; // Making these optional as they might be null in the database
  @JsonKey(name: 'role_id')
  String? get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String? get roleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_id')
  String? get salaryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_amount')
  double? get salaryAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_type')
  String? get salaryType =>
      throw _privateConstructorUsedError; // Note: currency_id is not in v_user_salary view
  @JsonKey(name: 'currency_id')
  String? get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'symbol')
  String? get currencySymbol =>
      throw _privateConstructorUsedError; // Note: hire_date is not in v_user_salary view
  @JsonKey(name: 'hire_date')
  DateTime? get hireDate =>
      throw _privateConstructorUsedError; // Note: is_active is not in v_user_salary view
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Note: updated_at is not in v_user_salary view
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName =>
      throw _privateConstructorUsedError; // Note: company_name is not in v_user_salary view
  @JsonKey(name: 'company_name')
  String? get companyName =>
      throw _privateConstructorUsedError; // Note: store_name is not in v_user_salary view
  @JsonKey(name: 'store_name')
  String? get storeName =>
      throw _privateConstructorUsedError; // Note: store_id is not in v_user_salary view
  @JsonKey(name: 'store_id')
  String? get storeId =>
      throw _privateConstructorUsedError; // Add fields that exist in v_user_salary
  @JsonKey(name: 'currency_name')
  String? get currencyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'bonus_amount')
  double? get bonusAmount => throw _privateConstructorUsedError;

  /// Serializes this EmployeeDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeDetailModelCopyWith<EmployeeDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeDetailModelCopyWith<$Res> {
  factory $EmployeeDetailModelCopyWith(
          EmployeeDetailModel value, $Res Function(EmployeeDetailModel) then) =
      _$EmployeeDetailModelCopyWithImpl<$Res, EmployeeDetailModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'role_id') String? roleId,
      @JsonKey(name: 'role_name') String? roleName,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'salary_id') String? salaryId,
      @JsonKey(name: 'salary_amount') double? salaryAmount,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'symbol') String? currencySymbol,
      @JsonKey(name: 'hire_date') DateTime? hireDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'currency_name') String? currencyName,
      @JsonKey(name: 'currency_code') String? currencyCode,
      @JsonKey(name: 'bonus_amount') double? bonusAmount});
}

/// @nodoc
class _$EmployeeDetailModelCopyWithImpl<$Res, $Val extends EmployeeDetailModel>
    implements $EmployeeDetailModelCopyWith<$Res> {
  _$EmployeeDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? profileImage = freezed,
    Object? roleId = freezed,
    Object? roleName = freezed,
    Object? companyId = null,
    Object? salaryId = freezed,
    Object? salaryAmount = freezed,
    Object? salaryType = freezed,
    Object? currencyId = freezed,
    Object? currencySymbol = freezed,
    Object? hireDate = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? companyName = freezed,
    Object? storeName = freezed,
    Object? storeId = freezed,
    Object? currencyName = freezed,
    Object? currencyCode = freezed,
    Object? bonusAmount = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: freezed == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      salaryId: freezed == salaryId
          ? _value.salaryId
          : salaryId // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeDetailModelImplCopyWith<$Res>
    implements $EmployeeDetailModelCopyWith<$Res> {
  factory _$$EmployeeDetailModelImplCopyWith(_$EmployeeDetailModelImpl value,
          $Res Function(_$EmployeeDetailModelImpl) then) =
      __$$EmployeeDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'role_id') String? roleId,
      @JsonKey(name: 'role_name') String? roleName,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'salary_id') String? salaryId,
      @JsonKey(name: 'salary_amount') double? salaryAmount,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'symbol') String? currencySymbol,
      @JsonKey(name: 'hire_date') DateTime? hireDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'currency_name') String? currencyName,
      @JsonKey(name: 'currency_code') String? currencyCode,
      @JsonKey(name: 'bonus_amount') double? bonusAmount});
}

/// @nodoc
class __$$EmployeeDetailModelImplCopyWithImpl<$Res>
    extends _$EmployeeDetailModelCopyWithImpl<$Res, _$EmployeeDetailModelImpl>
    implements _$$EmployeeDetailModelImplCopyWith<$Res> {
  __$$EmployeeDetailModelImplCopyWithImpl(_$EmployeeDetailModelImpl _value,
      $Res Function(_$EmployeeDetailModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? profileImage = freezed,
    Object? roleId = freezed,
    Object? roleName = freezed,
    Object? companyId = null,
    Object? salaryId = freezed,
    Object? salaryAmount = freezed,
    Object? salaryType = freezed,
    Object? currencyId = freezed,
    Object? currencySymbol = freezed,
    Object? hireDate = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? companyName = freezed,
    Object? storeName = freezed,
    Object? storeId = freezed,
    Object? currencyName = freezed,
    Object? currencyCode = freezed,
    Object? bonusAmount = freezed,
  }) {
    return _then(_$EmployeeDetailModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: freezed == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      salaryId: freezed == salaryId
          ? _value.salaryId
          : salaryId // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeDetailModelImpl extends _EmployeeDetailModel {
  const _$EmployeeDetailModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'full_name') required this.fullName,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'role_id') this.roleId,
      @JsonKey(name: 'role_name') this.roleName,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'salary_id') this.salaryId,
      @JsonKey(name: 'salary_amount') this.salaryAmount,
      @JsonKey(name: 'salary_type') this.salaryType,
      @JsonKey(name: 'currency_id') this.currencyId,
      @JsonKey(name: 'symbol') this.currencySymbol,
      @JsonKey(name: 'hire_date') this.hireDate,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'company_name') this.companyName,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'currency_name') this.currencyName,
      @JsonKey(name: 'currency_code') this.currencyCode,
      @JsonKey(name: 'bonus_amount') this.bonusAmount})
      : super._();

  factory _$EmployeeDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeDetailModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
// Note: email is not in v_user_salary view, making it optional
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
// Making these optional as they might be null in the database
  @override
  @JsonKey(name: 'role_id')
  final String? roleId;
  @override
  @JsonKey(name: 'role_name')
  final String? roleName;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'salary_id')
  final String? salaryId;
  @override
  @JsonKey(name: 'salary_amount')
  final double? salaryAmount;
  @override
  @JsonKey(name: 'salary_type')
  final String? salaryType;
// Note: currency_id is not in v_user_salary view
  @override
  @JsonKey(name: 'currency_id')
  final String? currencyId;
  @override
  @JsonKey(name: 'symbol')
  final String? currencySymbol;
// Note: hire_date is not in v_user_salary view
  @override
  @JsonKey(name: 'hire_date')
  final DateTime? hireDate;
// Note: is_active is not in v_user_salary view
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// Note: updated_at is not in v_user_salary view
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
// Note: company_name is not in v_user_salary view
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
// Note: store_name is not in v_user_salary view
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
// Note: store_id is not in v_user_salary view
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
// Add fields that exist in v_user_salary
  @override
  @JsonKey(name: 'currency_name')
  final String? currencyName;
  @override
  @JsonKey(name: 'currency_code')
  final String? currencyCode;
  @override
  @JsonKey(name: 'bonus_amount')
  final double? bonusAmount;

  @override
  String toString() {
    return 'EmployeeDetailModel(userId: $userId, fullName: $fullName, email: $email, profileImage: $profileImage, roleId: $roleId, roleName: $roleName, companyId: $companyId, salaryId: $salaryId, salaryAmount: $salaryAmount, salaryType: $salaryType, currencyId: $currencyId, currencySymbol: $currencySymbol, hireDate: $hireDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, firstName: $firstName, lastName: $lastName, companyName: $companyName, storeName: $storeName, storeId: $storeId, currencyName: $currencyName, currencyCode: $currencyCode, bonusAmount: $bonusAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeDetailModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.salaryId, salaryId) ||
                other.salaryId == salaryId) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        fullName,
        email,
        profileImage,
        roleId,
        roleName,
        companyId,
        salaryId,
        salaryAmount,
        salaryType,
        currencyId,
        currencySymbol,
        hireDate,
        isActive,
        createdAt,
        updatedAt,
        firstName,
        lastName,
        companyName,
        storeName,
        storeId,
        currencyName,
        currencyCode,
        bonusAmount
      ]);

  /// Create a copy of EmployeeDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeDetailModelImplCopyWith<_$EmployeeDetailModelImpl> get copyWith =>
      __$$EmployeeDetailModelImplCopyWithImpl<_$EmployeeDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeDetailModelImplToJson(
      this,
    );
  }
}

abstract class _EmployeeDetailModel extends EmployeeDetailModel {
  const factory _EmployeeDetailModel(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'full_name') required final String fullName,
          @JsonKey(name: 'email') final String? email,
          @JsonKey(name: 'profile_image') final String? profileImage,
          @JsonKey(name: 'role_id') final String? roleId,
          @JsonKey(name: 'role_name') final String? roleName,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'salary_id') final String? salaryId,
          @JsonKey(name: 'salary_amount') final double? salaryAmount,
          @JsonKey(name: 'salary_type') final String? salaryType,
          @JsonKey(name: 'currency_id') final String? currencyId,
          @JsonKey(name: 'symbol') final String? currencySymbol,
          @JsonKey(name: 'hire_date') final DateTime? hireDate,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          @JsonKey(name: 'company_name') final String? companyName,
          @JsonKey(name: 'store_name') final String? storeName,
          @JsonKey(name: 'store_id') final String? storeId,
          @JsonKey(name: 'currency_name') final String? currencyName,
          @JsonKey(name: 'currency_code') final String? currencyCode,
          @JsonKey(name: 'bonus_amount') final double? bonusAmount}) =
      _$EmployeeDetailModelImpl;
  const _EmployeeDetailModel._() : super._();

  factory _EmployeeDetailModel.fromJson(Map<String, dynamic> json) =
      _$EmployeeDetailModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'full_name')
  String
      get fullName; // Note: email is not in v_user_salary view, making it optional
  @override
  @JsonKey(name: 'email')
  String? get email;
  @override
  @JsonKey(name: 'profile_image')
  String?
      get profileImage; // Making these optional as they might be null in the database
  @override
  @JsonKey(name: 'role_id')
  String? get roleId;
  @override
  @JsonKey(name: 'role_name')
  String? get roleName;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'salary_id')
  String? get salaryId;
  @override
  @JsonKey(name: 'salary_amount')
  double? get salaryAmount;
  @override
  @JsonKey(name: 'salary_type')
  String? get salaryType; // Note: currency_id is not in v_user_salary view
  @override
  @JsonKey(name: 'currency_id')
  String? get currencyId;
  @override
  @JsonKey(name: 'symbol')
  String? get currencySymbol; // Note: hire_date is not in v_user_salary view
  @override
  @JsonKey(name: 'hire_date')
  DateTime? get hireDate; // Note: is_active is not in v_user_salary view
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Note: updated_at is not in v_user_salary view
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName; // Note: company_name is not in v_user_salary view
  @override
  @JsonKey(name: 'company_name')
  String? get companyName; // Note: store_name is not in v_user_salary view
  @override
  @JsonKey(name: 'store_name')
  String? get storeName; // Note: store_id is not in v_user_salary view
  @override
  @JsonKey(name: 'store_id')
  String? get storeId; // Add fields that exist in v_user_salary
  @override
  @JsonKey(name: 'currency_name')
  String? get currencyName;
  @override
  @JsonKey(name: 'currency_code')
  String? get currencyCode;
  @override
  @JsonKey(name: 'bonus_amount')
  double? get bonusAmount;

  /// Create a copy of EmployeeDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeDetailModelImplCopyWith<_$EmployeeDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
