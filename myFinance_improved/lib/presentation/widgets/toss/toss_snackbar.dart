import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Snackbar types
enum SnackbarType {
  success,
  error,
  warning,
  info,
}

/// Toss-style snackbar utility
class TossSnackbar {
  /// Show a Toss-style snackbar
  static void show(
    BuildContext context,
    String message, {
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          _getIcon(type),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              message,
              style: TossTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      margin: EdgeInsets.all(TossSpacing.space4),
    );
    
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
  
  /// Get icon for snackbar type
  static Widget _getIcon(SnackbarType type) {
    IconData iconData;
    Color iconColor;
    
    switch (type) {
      case SnackbarType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.white;
        break;
      case SnackbarType.error:
        iconData = Icons.error;
        iconColor = Colors.white;
        break;
      case SnackbarType.warning:
        iconData = Icons.warning;
        iconColor = Colors.white;
        break;
      case SnackbarType.info:
        iconData = Icons.info;
        iconColor = Colors.white;
        break;
    }
    
    return Icon(
      iconData,
      color: iconColor,
      size: 20,
    );
  }
  
  /// Get background color for snackbar type
  static Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return TossColors.success;
      case SnackbarType.error:
        return TossColors.error;
      case SnackbarType.warning:
        return TossColors.warning;
      case SnackbarType.info:
        return TossColors.primary;
    }
  }
  
  /// Show success snackbar
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message,
      type: SnackbarType.success,
      duration: duration,
      action: action,
    );
  }
  
  /// Show error snackbar
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    show(
      context,
      message,
      type: SnackbarType.error,
      duration: duration,
      action: action,
    );
  }
  
  /// Show warning snackbar
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message,
      type: SnackbarType.warning,
      duration: duration,
      action: action,
    );
  }
  
  /// Show info snackbar
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message,
      type: SnackbarType.info,
      duration: duration,
      action: action,
    );
  }
}