// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EmployeeDetail {
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get email =>
      throw _privateConstructorUsedError; // Making optional as it's not in v_user_salary
  String? get profileImage => throw _privateConstructorUsedError;
  String? get roleId =>
      throw _privateConstructorUsedError; // Making optional as it might be null
  String? get roleName =>
      throw _privateConstructorUsedError; // Making optional as it might be null
  String get companyId => throw _privateConstructorUsedError;
  String? get salaryId => throw _privateConstructorUsedError;
  double? get salaryAmount => throw _privateConstructorUsedError;
  String? get salaryType => throw _privateConstructorUsedError;
  String? get currencyId => throw _privateConstructorUsedError;
  String? get currencySymbol => throw _privateConstructorUsedError;
  DateTime? get hireDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Additional fields from v_user_salary view
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get companyName => throw _privateConstructorUsedError;
  String? get storeName => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get currencyName => throw _privateConstructorUsedError;
  String? get currencyCode => throw _privateConstructorUsedError;
  double? get bonusAmount => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeDetailCopyWith<EmployeeDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeDetailCopyWith<$Res> {
  factory $EmployeeDetailCopyWith(
          EmployeeDetail value, $Res Function(EmployeeDetail) then) =
      _$EmployeeDetailCopyWithImpl<$Res, EmployeeDetail>;
  @useResult
  $Res call(
      {String userId,
      String fullName,
      String? email,
      String? profileImage,
      String? roleId,
      String? roleName,
      String companyId,
      String? salaryId,
      double? salaryAmount,
      String? salaryType,
      String? currencyId,
      String? currencySymbol,
      DateTime? hireDate,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? firstName,
      String? lastName,
      String? companyName,
      String? storeName,
      String? storeId,
      String? currencyName,
      String? currencyCode,
      double? bonusAmount});
}

/// @nodoc
class _$EmployeeDetailCopyWithImpl<$Res, $Val extends EmployeeDetail>
    implements $EmployeeDetailCopyWith<$Res> {
  _$EmployeeDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeDetail
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
abstract class _$$EmployeeDetailImplCopyWith<$Res>
    implements $EmployeeDetailCopyWith<$Res> {
  factory _$$EmployeeDetailImplCopyWith(_$EmployeeDetailImpl value,
          $Res Function(_$EmployeeDetailImpl) then) =
      __$$EmployeeDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String fullName,
      String? email,
      String? profileImage,
      String? roleId,
      String? roleName,
      String companyId,
      String? salaryId,
      double? salaryAmount,
      String? salaryType,
      String? currencyId,
      String? currencySymbol,
      DateTime? hireDate,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? firstName,
      String? lastName,
      String? companyName,
      String? storeName,
      String? storeId,
      String? currencyName,
      String? currencyCode,
      double? bonusAmount});
}

/// @nodoc
class __$$EmployeeDetailImplCopyWithImpl<$Res>
    extends _$EmployeeDetailCopyWithImpl<$Res, _$EmployeeDetailImpl>
    implements _$$EmployeeDetailImplCopyWith<$Res> {
  __$$EmployeeDetailImplCopyWithImpl(
      _$EmployeeDetailImpl _value, $Res Function(_$EmployeeDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeDetail
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
    return _then(_$EmployeeDetailImpl(
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

class _$EmployeeDetailImpl extends _EmployeeDetail {
  const _$EmployeeDetailImpl(
      {required this.userId,
      required this.fullName,
      this.email,
      this.profileImage,
      this.roleId,
      this.roleName,
      required this.companyId,
      this.salaryId,
      this.salaryAmount,
      this.salaryType,
      this.currencyId,
      this.currencySymbol,
      this.hireDate,
      this.isActive = true,
      this.createdAt,
      this.updatedAt,
      this.firstName,
      this.lastName,
      this.companyName,
      this.storeName,
      this.storeId,
      this.currencyName,
      this.currencyCode,
      this.bonusAmount})
      : super._();

  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String? email;
// Making optional as it's not in v_user_salary
  @override
  final String? profileImage;
  @override
  final String? roleId;
// Making optional as it might be null
  @override
  final String? roleName;
// Making optional as it might be null
  @override
  final String companyId;
  @override
  final String? salaryId;
  @override
  final double? salaryAmount;
  @override
  final String? salaryType;
  @override
  final String? currencyId;
  @override
  final String? currencySymbol;
  @override
  final DateTime? hireDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Additional fields from v_user_salary view
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? companyName;
  @override
  final String? storeName;
  @override
  final String? storeId;
  @override
  final String? currencyName;
  @override
  final String? currencyCode;
  @override
  final double? bonusAmount;

  @override
  String toString() {
    return 'EmployeeDetail(userId: $userId, fullName: $fullName, email: $email, profileImage: $profileImage, roleId: $roleId, roleName: $roleName, companyId: $companyId, salaryId: $salaryId, salaryAmount: $salaryAmount, salaryType: $salaryType, currencyId: $currencyId, currencySymbol: $currencySymbol, hireDate: $hireDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, firstName: $firstName, lastName: $lastName, companyName: $companyName, storeName: $storeName, storeId: $storeId, currencyName: $currencyName, currencyCode: $currencyCode, bonusAmount: $bonusAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeDetailImpl &&
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

  /// Create a copy of EmployeeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeDetailImplCopyWith<_$EmployeeDetailImpl> get copyWith =>
      __$$EmployeeDetailImplCopyWithImpl<_$EmployeeDetailImpl>(
          this, _$identity);
}

abstract class _EmployeeDetail extends EmployeeDetail {
  const factory _EmployeeDetail(
      {required final String userId,
      required final String fullName,
      final String? email,
      final String? profileImage,
      final String? roleId,
      final String? roleName,
      required final String companyId,
      final String? salaryId,
      final double? salaryAmount,
      final String? salaryType,
      final String? currencyId,
      final String? currencySymbol,
      final DateTime? hireDate,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? firstName,
      final String? lastName,
      final String? companyName,
      final String? storeName,
      final String? storeId,
      final String? currencyName,
      final String? currencyCode,
      final double? bonusAmount}) = _$EmployeeDetailImpl;
  const _EmployeeDetail._() : super._();

  @override
  String get userId;
  @override
  String get fullName;
  @override
  String? get email; // Making optional as it's not in v_user_salary
  @override
  String? get profileImage;
  @override
  String? get roleId; // Making optional as it might be null
  @override
  String? get roleName; // Making optional as it might be null
  @override
  String get companyId;
  @override
  String? get salaryId;
  @override
  double? get salaryAmount;
  @override
  String? get salaryType;
  @override
  String? get currencyId;
  @override
  String? get currencySymbol;
  @override
  DateTime? get hireDate;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Additional fields from v_user_salary view
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get companyName;
  @override
  String? get storeName;
  @override
  String? get storeId;
  @override
  String? get currencyName;
  @override
  String? get currencyCode;
  @override
  double? get bonusAmount;

  /// Create a copy of EmployeeDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeDetailImplCopyWith<_$EmployeeDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
