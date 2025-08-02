// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRoleInfoModel _$UserRoleInfoModelFromJson(Map<String, dynamic> json) {
  return _UserRoleInfoModel.fromJson(json);
}

/// @nodoc
mixin _$UserRoleInfoModel {
  @JsonKey(name: 'user_role_id')
  String get userRoleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_id')
  String get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String get roleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this UserRoleInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRoleInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRoleInfoModelCopyWith<UserRoleInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleInfoModelCopyWith<$Res> {
  factory $UserRoleInfoModelCopyWith(
          UserRoleInfoModel value, $Res Function(UserRoleInfoModel) then) =
      _$UserRoleInfoModelCopyWithImpl<$Res, UserRoleInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_role_id') String userRoleId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'role_id') String roleId,
      @JsonKey(name: 'role_name') String roleName,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class _$UserRoleInfoModelCopyWithImpl<$Res, $Val extends UserRoleInfoModel>
    implements $UserRoleInfoModelCopyWith<$Res> {
  _$UserRoleInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRoleInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRoleId = null,
    Object? userId = null,
    Object? roleId = null,
    Object? roleName = null,
    Object? companyId = null,
    Object? fullName = null,
    Object? email = null,
    Object? profileImage = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      userRoleId: null == userRoleId
          ? _value.userRoleId
          : userRoleId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRoleInfoModelImplCopyWith<$Res>
    implements $UserRoleInfoModelCopyWith<$Res> {
  factory _$$UserRoleInfoModelImplCopyWith(_$UserRoleInfoModelImpl value,
          $Res Function(_$UserRoleInfoModelImpl) then) =
      __$$UserRoleInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_role_id') String userRoleId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'role_id') String roleId,
      @JsonKey(name: 'role_name') String roleName,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class __$$UserRoleInfoModelImplCopyWithImpl<$Res>
    extends _$UserRoleInfoModelCopyWithImpl<$Res, _$UserRoleInfoModelImpl>
    implements _$$UserRoleInfoModelImplCopyWith<$Res> {
  __$$UserRoleInfoModelImplCopyWithImpl(_$UserRoleInfoModelImpl _value,
      $Res Function(_$UserRoleInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRoleInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRoleId = null,
    Object? userId = null,
    Object? roleId = null,
    Object? roleName = null,
    Object? companyId = null,
    Object? fullName = null,
    Object? email = null,
    Object? profileImage = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_$UserRoleInfoModelImpl(
      userRoleId: null == userRoleId
          ? _value.userRoleId
          : userRoleId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRoleInfoModelImpl extends _UserRoleInfoModel {
  const _$UserRoleInfoModelImpl(
      {@JsonKey(name: 'user_role_id') required this.userRoleId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'role_id') required this.roleId,
      @JsonKey(name: 'role_name') required this.roleName,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'full_name') required this.fullName,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'is_deleted') this.isDeleted = false})
      : super._();

  factory _$UserRoleInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRoleInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_role_id')
  final String userRoleId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'role_id')
  final String roleId;
  @override
  @JsonKey(name: 'role_name')
  final String roleName;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @override
  String toString() {
    return 'UserRoleInfoModel(userRoleId: $userRoleId, userId: $userId, roleId: $roleId, roleName: $roleName, companyId: $companyId, fullName: $fullName, email: $email, profileImage: $profileImage, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleInfoModelImpl &&
            (identical(other.userRoleId, userRoleId) ||
                other.userRoleId == userRoleId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userRoleId,
      userId,
      roleId,
      roleName,
      companyId,
      fullName,
      email,
      profileImage,
      createdAt,
      updatedAt,
      isDeleted);

  /// Create a copy of UserRoleInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleInfoModelImplCopyWith<_$UserRoleInfoModelImpl> get copyWith =>
      __$$UserRoleInfoModelImplCopyWithImpl<_$UserRoleInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRoleInfoModelImplToJson(
      this,
    );
  }
}

abstract class _UserRoleInfoModel extends UserRoleInfoModel {
  const factory _UserRoleInfoModel(
          {@JsonKey(name: 'user_role_id') required final String userRoleId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'role_id') required final String roleId,
          @JsonKey(name: 'role_name') required final String roleName,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'full_name') required final String fullName,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'profile_image') final String? profileImage,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt,
          @JsonKey(name: 'is_deleted') final bool isDeleted}) =
      _$UserRoleInfoModelImpl;
  const _UserRoleInfoModel._() : super._();

  factory _UserRoleInfoModel.fromJson(Map<String, dynamic> json) =
      _$UserRoleInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_role_id')
  String get userRoleId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'role_id')
  String get roleId;
  @override
  @JsonKey(name: 'role_name')
  String get roleName;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;

  /// Create a copy of UserRoleInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRoleInfoModelImplCopyWith<_$UserRoleInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
