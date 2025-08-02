// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) {
  return _RoleModel.fromJson(json);
}

/// @nodoc
mixin _$RoleModel {
  @JsonKey(name: 'role_id')
  String get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String get roleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_type')
  String get roleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_role_id')
  String? get parentRoleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deletable')
  bool get isDeletable => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleModelCopyWith<RoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleModelCopyWith<$Res> {
  factory $RoleModelCopyWith(RoleModel value, $Res Function(RoleModel) then) =
      _$RoleModelCopyWithImpl<$Res, RoleModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'role_id') String roleId,
      @JsonKey(name: 'role_name') String roleName,
      @JsonKey(name: 'role_type') String roleType,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'parent_role_id') String? parentRoleId,
      @JsonKey(name: 'is_deletable') bool isDeletable,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$RoleModelCopyWithImpl<$Res, $Val extends RoleModel>
    implements $RoleModelCopyWith<$Res> {
  _$RoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? roleName = null,
    Object? roleType = null,
    Object? companyId = null,
    Object? parentRoleId = freezed,
    Object? isDeletable = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      roleType: null == roleType
          ? _value.roleType
          : roleType // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      parentRoleId: freezed == parentRoleId
          ? _value.parentRoleId
          : parentRoleId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeletable: null == isDeletable
          ? _value.isDeletable
          : isDeletable // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleModelImplCopyWith<$Res>
    implements $RoleModelCopyWith<$Res> {
  factory _$$RoleModelImplCopyWith(
          _$RoleModelImpl value, $Res Function(_$RoleModelImpl) then) =
      __$$RoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'role_id') String roleId,
      @JsonKey(name: 'role_name') String roleName,
      @JsonKey(name: 'role_type') String roleType,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'parent_role_id') String? parentRoleId,
      @JsonKey(name: 'is_deletable') bool isDeletable,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$RoleModelImplCopyWithImpl<$Res>
    extends _$RoleModelCopyWithImpl<$Res, _$RoleModelImpl>
    implements _$$RoleModelImplCopyWith<$Res> {
  __$$RoleModelImplCopyWithImpl(
      _$RoleModelImpl _value, $Res Function(_$RoleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? roleName = null,
    Object? roleType = null,
    Object? companyId = null,
    Object? parentRoleId = freezed,
    Object? isDeletable = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$RoleModelImpl(
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      roleType: null == roleType
          ? _value.roleType
          : roleType // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      parentRoleId: freezed == parentRoleId
          ? _value.parentRoleId
          : parentRoleId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeletable: null == isDeletable
          ? _value.isDeletable
          : isDeletable // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoleModelImpl extends _RoleModel {
  const _$RoleModelImpl(
      {@JsonKey(name: 'role_id') required this.roleId,
      @JsonKey(name: 'role_name') required this.roleName,
      @JsonKey(name: 'role_type') required this.roleType,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'parent_role_id') this.parentRoleId,
      @JsonKey(name: 'is_deletable') this.isDeletable = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$RoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleModelImplFromJson(json);

  @override
  @JsonKey(name: 'role_id')
  final String roleId;
  @override
  @JsonKey(name: 'role_name')
  final String roleName;
  @override
  @JsonKey(name: 'role_type')
  final String roleType;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'parent_role_id')
  final String? parentRoleId;
  @override
  @JsonKey(name: 'is_deletable')
  final bool isDeletable;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RoleModel(roleId: $roleId, roleName: $roleName, roleType: $roleType, companyId: $companyId, parentRoleId: $parentRoleId, isDeletable: $isDeletable, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleModelImpl &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.roleType, roleType) ||
                other.roleType == roleType) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.parentRoleId, parentRoleId) ||
                other.parentRoleId == parentRoleId) &&
            (identical(other.isDeletable, isDeletable) ||
                other.isDeletable == isDeletable) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roleId, roleName, roleType,
      companyId, parentRoleId, isDeletable, createdAt, updatedAt);

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      __$$RoleModelImplCopyWithImpl<_$RoleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleModelImplToJson(
      this,
    );
  }
}

abstract class _RoleModel extends RoleModel {
  const factory _RoleModel(
          {@JsonKey(name: 'role_id') required final String roleId,
          @JsonKey(name: 'role_name') required final String roleName,
          @JsonKey(name: 'role_type') required final String roleType,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'parent_role_id') final String? parentRoleId,
          @JsonKey(name: 'is_deletable') final bool isDeletable,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$RoleModelImpl;
  const _RoleModel._() : super._();

  factory _RoleModel.fromJson(Map<String, dynamic> json) =
      _$RoleModelImpl.fromJson;

  @override
  @JsonKey(name: 'role_id')
  String get roleId;
  @override
  @JsonKey(name: 'role_name')
  String get roleName;
  @override
  @JsonKey(name: 'role_type')
  String get roleType;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'parent_role_id')
  String? get parentRoleId;
  @override
  @JsonKey(name: 'is_deletable')
  bool get isDeletable;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
