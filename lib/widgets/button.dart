import 'package:challengeone/config/color.dart';
import 'package:flutter/material.dart';

class BasicButton extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final bool isEnabled;
  final VoidCallback? onTap;
  final double height;

  const BasicButton({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(color: grey100, fontSize: 16),
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.backgroundColor = Colors.transparent,
    this.isEnabled = true,
    this.onTap,
    this.height = 48,
  });

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isEnabled ? widget.onTap : null,
      child: Ink(
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.isEnabled
              ? widget.backgroundColor
              : widget.backgroundColor.withOpacity(0.5),
          border: widget.borderWidth > 0
              ? Border.all(
                  color: widget.isEnabled
                      ? widget.borderColor
                      : widget.borderColor.withOpacity(0.5),
                  width: widget.borderWidth,
                )
              : null,
        ),
        child: Center(
          child: Opacity(
            opacity: widget.isEnabled ? 1.0 : 0.5,
            child: Text(
              widget.text,
              style: widget.textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final bool isEnabled;
  final VoidCallback? onTap;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.isEnabled = true,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BasicButton(
      text: text,
      textStyle: textStyle ?? const TextStyle(color: white, fontSize: 16),
      borderColor: borderColor ?? Colors.transparent,
      borderWidth: borderWidth ?? 0,
      backgroundColor: backgroundColor ?? blue50,
      isEnabled: isEnabled,
      onTap: onTap,
      height: height ?? 48,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final bool isEnabled;
  final VoidCallback? onTap;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.isEnabled = true,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BasicButton(
      text: text,
      textStyle: textStyle ?? const TextStyle(color: grey100, fontSize: 16),
      borderColor: borderColor ?? grey30,
      borderWidth: borderWidth ?? 1.0,
      backgroundColor: backgroundColor ?? white,
      isEnabled: isEnabled,
      onTap: onTap,
      height: height ?? 48,
    );
  }
}

class GhostButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final bool isEnabled;
  final VoidCallback? onTap;
  final double? height;

  const GhostButton({
    super.key,
    required this.text,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.isEnabled = true,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BasicButton(
      text: text,
      textStyle: textStyle ?? const TextStyle(color: blue50, fontSize: 16),
      borderColor: borderColor ?? Colors.transparent,
      borderWidth: borderWidth ?? 0.0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      isEnabled: isEnabled,
      onTap: onTap,
      height: height ?? 48,
    );
  }
}
