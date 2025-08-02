import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_spacing.dart';

/// Button types for TossButton
enum TossButtonType {
  filled,
  outlined,
  text,
}

/// Button sizes for TossButton
enum TossButtonSize {
  small,
  medium,
  large,
}

/// Toss-style button with multiple variants
class TossButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final TossButtonType type;
  final TossButtonSize size;
  
  const TossButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.type = TossButtonType.filled,
    this.size = TossButtonSize.medium,
  });
  
  @override
  State<TossButton> createState() => _TossButtonState();
}

class _TossButtonState extends State<TossButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  bool get _isDisabled => !widget.isEnabled || widget.isLoading || widget.onPressed == null;
  
  double get _height {
    switch (widget.size) {
      case TossButtonSize.small:
        return 36;
      case TossButtonSize.medium:
        return 44;
      case TossButtonSize.large:
        return 56;
    }
  }
  
  EdgeInsets get _padding {
    switch (widget.size) {
      case TossButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        );
      case TossButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        );
      case TossButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        );
    }
  }
  
  TextStyle get _textStyle {
    switch (widget.size) {
      case TossButtonSize.small:
        return TossTextStyles.label;
      case TossButtonSize.medium:
        return TossTextStyles.labelLarge;
      case TossButtonSize.large:
        return TossTextStyles.body;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: !_isDisabled ? (_) => _controller.forward() : null,
      onTapUp: !_isDisabled ? (_) => _controller.reverse() : null,
      onTapCancel: !_isDisabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(),
        ),
      ),
    );
  }
  
  Widget _buildButton() {
    switch (widget.type) {
      case TossButtonType.filled:
        return _buildFilledButton();
      case TossButtonType.outlined:
        return _buildOutlinedButton();
      case TossButtonType.text:
        return _buildTextButton();
    }
  }
  
  Widget _buildFilledButton() {
    return Container(
      height: _height,
      child: ElevatedButton(
        onPressed: _isDisabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isDisabled 
              ? TossColors.gray200 
              : TossColors.primary,
          foregroundColor: _isDisabled 
              ? TossColors.gray400 
              : Colors.white,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        child: _buildButtonContent(
          textColor: _isDisabled ? TossColors.gray400 : Colors.white,
        ),
      ),
    );
  }
  
  Widget _buildOutlinedButton() {
    return Container(
      height: _height,
      child: OutlinedButton(
        onPressed: _isDisabled ? null : widget.onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _isDisabled 
              ? TossColors.gray400 
              : TossColors.gray700,
          elevation: 0,
          padding: _padding,
          side: BorderSide(
            color: _isDisabled 
                ? TossColors.gray200 
                : TossColors.gray300,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        child: _buildButtonContent(
          textColor: _isDisabled ? TossColors.gray400 : TossColors.gray700,
        ),
      ),
    );
  }
  
  Widget _buildTextButton() {
    return Container(
      height: _height,
      child: TextButton(
        onPressed: _isDisabled ? null : widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: _isDisabled 
              ? TossColors.gray400 
              : TossColors.primary,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        child: _buildButtonContent(
          textColor: _isDisabled ? TossColors.gray400 : TossColors.primary,
        ),
      ),
    );
  }
  
  Widget _buildButtonContent({required Color textColor}) {
    if (widget.isLoading) {
      return SizedBox(
        width: widget.size == TossButtonSize.small ? 16 : 20,
        height: widget.size == TossButtonSize.small ? 16 : 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor.withOpacity(0.8),
          ),
        ),
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leadingIcon != null) ...[
          widget.leadingIcon!,
          SizedBox(width: TossSpacing.space2),
        ],
        Text(
          widget.text,
          style: _textStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}