// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EmployeeFilter {
  String get searchQuery => throw _privateConstructorUsedError;
  bool get activeOnly => throw _privateConstructorUsedError;
  String? get selectedRoleId => throw _privateConstructorUsedError;
  String? get selectedStoreId => throw _privateConstructorUsedError;
  EmployeeSortBy get sortBy => throw _privateConstructorUsedError;
  bool get sortAscending => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeFilterCopyWith<EmployeeFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeFilterCopyWith<$Res> {
  factory $EmployeeFilterCopyWith(
          EmployeeFilter value, $Res Function(EmployeeFilter) then) =
      _$EmployeeFilterCopyWithImpl<$Res, EmployeeFilter>;
  @useResult
  $Res call(
      {String searchQuery,
      bool activeOnly,
      String? selectedRoleId,
      String? selectedStoreId,
      EmployeeSortBy sortBy,
      bool sortAscending});
}

/// @nodoc
class _$EmployeeFilterCopyWithImpl<$Res, $Val extends EmployeeFilter>
    implements $EmployeeFilterCopyWith<$Res> {
  _$EmployeeFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? activeOnly = null,
    Object? selectedRoleId = freezed,
    Object? selectedStoreId = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      activeOnly: null == activeOnly
          ? _value.activeOnly
          : activeOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedRoleId: freezed == selectedRoleId
          ? _value.selectedRoleId
          : selectedRoleId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as EmployeeSortBy,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeFilterImplCopyWith<$Res>
    implements $EmployeeFilterCopyWith<$Res> {
  factory _$$EmployeeFilterImplCopyWith(_$EmployeeFilterImpl value,
          $Res Function(_$EmployeeFilterImpl) then) =
      __$$EmployeeFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchQuery,
      bool activeOnly,
      String? selectedRoleId,
      String? selectedStoreId,
      EmployeeSortBy sortBy,
      bool sortAscending});
}

/// @nodoc
class __$$EmployeeFilterImplCopyWithImpl<$Res>
    extends _$EmployeeFilterCopyWithImpl<$Res, _$EmployeeFilterImpl>
    implements _$$EmployeeFilterImplCopyWith<$Res> {
  __$$EmployeeFilterImplCopyWithImpl(
      _$EmployeeFilterImpl _value, $Res Function(_$EmployeeFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? activeOnly = null,
    Object? selectedRoleId = freezed,
    Object? selectedStoreId = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
  }) {
    return _then(_$EmployeeFilterImpl(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      activeOnly: null == activeOnly
          ? _value.activeOnly
          : activeOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedRoleId: freezed == selectedRoleId
          ? _value.selectedRoleId
          : selectedRoleId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStoreId: freezed == selectedStoreId
          ? _value.selectedStoreId
          : selectedStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as EmployeeSortBy,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$EmployeeFilterImpl implements _EmployeeFilter {
  const _$EmployeeFilterImpl(
      {this.searchQuery = '',
      this.activeOnly = true,
      this.selectedRoleId,
      this.selectedStoreId,
      this.sortBy = EmployeeSortBy.name,
      this.sortAscending = true});

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool activeOnly;
  @override
  final String? selectedRoleId;
  @override
  final String? selectedStoreId;
  @override
  @JsonKey()
  final EmployeeSortBy sortBy;
  @override
  @JsonKey()
  final bool sortAscending;

  @override
  String toString() {
    return 'EmployeeFilter(searchQuery: $searchQuery, activeOnly: $activeOnly, selectedRoleId: $selectedRoleId, selectedStoreId: $selectedStoreId, sortBy: $sortBy, sortAscending: $sortAscending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeFilterImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.activeOnly, activeOnly) ||
                other.activeOnly == activeOnly) &&
            (identical(other.selectedRoleId, selectedRoleId) ||
                other.selectedRoleId == selectedRoleId) &&
            (identical(other.selectedStoreId, selectedStoreId) ||
                other.selectedStoreId == selectedStoreId) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchQuery, activeOnly,
      selectedRoleId, selectedStoreId, sortBy, sortAscending);

  /// Create a copy of EmployeeFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeFilterImplCopyWith<_$EmployeeFilterImpl> get copyWith =>
      __$$EmployeeFilterImplCopyWithImpl<_$EmployeeFilterImpl>(
          this, _$identity);
}

abstract class _EmployeeFilter implements EmployeeFilter {
  const factory _EmployeeFilter(
      {final String searchQuery,
      final bool activeOnly,
      final String? selectedRoleId,
      final String? selectedStoreId,
      final EmployeeSortBy sortBy,
      final bool sortAscending}) = _$EmployeeFilterImpl;

  @override
  String get searchQuery;
  @override
  bool get activeOnly;
  @override
  String? get selectedRoleId;
  @override
  String? get selectedStoreId;
  @override
  EmployeeSortBy get sortBy;
  @override
  bool get sortAscending;

  /// Create a copy of EmployeeFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeFilterImplCopyWith<_$EmployeeFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
