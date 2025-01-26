import 'package:challengeone/config/color.dart';
import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 버튼 크기를 정의하는 enum
enum CButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

/// 버튼 스타일을 관리하는 클래스
class CButtonStyle {
  final Color backgroundColor;
  final Color labelColor;
  final Color iconColor;
  final Border? border;

  const CButtonStyle({
    required this.backgroundColor,
    required this.labelColor,
    required this.iconColor,
    this.border,
  });

  /// Primary 스타일
  factory CButtonStyle.primary(bool isDarkMode) {
    return CButtonStyle(
      backgroundColor: ThemeModel.highlight(isDarkMode),
      labelColor: white,
      iconColor: white,
    );
  }

  /// Secondary 스타일
  factory CButtonStyle.secondary(bool isDarkMode) {
    return CButtonStyle(
      backgroundColor: isDarkMode ? grey70 : grey80,
      labelColor: white,
      iconColor: white,
    );
  }

  /// Tertiary 스타일
  factory CButtonStyle.tertiary(bool isDarkMode) {
    return CButtonStyle(
      backgroundColor: Colors.transparent,
      labelColor: isDarkMode ? grey10 : ThemeModel.highlight(isDarkMode),
      iconColor: isDarkMode ? grey10 : ThemeModel.highlight(isDarkMode),
      border: Border.all(
        color: isDarkMode ? grey10 : ThemeModel.highlight(isDarkMode),
        width: 1,
      ),
    );
  }

  /// Danger 스타일
  factory CButtonStyle.danger(bool isDarkMode) {
    return const CButtonStyle(
      backgroundColor: red60,
      labelColor: white,
      iconColor: white,
    );
  }

  /// Ghost 스타일
  factory CButtonStyle.ghost(bool isDarkMode) {
    return CButtonStyle(
      backgroundColor: Colors.transparent,
      labelColor: ThemeModel.highlight(isDarkMode),
      iconColor: ThemeModel.highlight(isDarkMode),
    );
  }
}

/// 버튼 크기를 관리하는 클래스
class CButtonSizes {
  static const Map<CButtonSize, EdgeInsets> sizes = {
    CButtonSize.small: EdgeInsets.all(8),
    CButtonSize.medium: EdgeInsets.all(12),
    CButtonSize.large: EdgeInsets.all(16),
    CButtonSize.extraLarge: EdgeInsets.fromLTRB(16, 16, 16, 24),
  };

  static const Map<CButtonSize, double> textSizes = {
    CButtonSize.small: 12,
    CButtonSize.medium: 14,
    CButtonSize.large: 16,
    CButtonSize.extraLarge: 16,
  };

  static const Map<CButtonSize, double> iconSizes = {
    CButtonSize.small: 16,
    CButtonSize.medium: 20,
    CButtonSize.large: 24,
    CButtonSize.extraLarge: 24,
  };
}

///
/// [CButton] 위젯
///
/// Parameter:
/// - [label]: 버튼에 표시될 텍스트
/// - [icon]: 버튼에 표시될 아이콘
/// - [size]: 버튼 크기 (CButtonSize.small, CButtonSize.large 등)
/// - [style]: 버튼의 스타일 (CButtonStyle.primary, CButtonStyle.tertiary 등)
/// - [width]: 버튼의 고정 너비
/// - [onTap]: 버튼을 눌렀을 때 실행되는 콜백 함수
///
class CButton extends ConsumerWidget {
  final String? label;
  final IconData? icon;
  final CButtonSize size;
  final CButtonStyle? style;
  final double? width;
  final VoidCallback? onTap;

  const CButton({
    super.key,
    this.label,
    this.icon,
    this.size = CButtonSize.large,
    this.style,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final bool isDisabled = onTap == null;

    final CButtonStyle effectiveStyle =
        style ?? CButtonStyle.primary(isDarkMode);

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: CInkWell(
        onTap: isDisabled ? null : onTap,
        child: Container(
          padding: CButtonSizes.sizes[size]!,
          width: width,
          decoration: BoxDecoration(
            color: effectiveStyle.backgroundColor,
            border: effectiveStyle.border,
          ),
          child: Row(
            mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    color: effectiveStyle.labelColor,
                    fontSize: CButtonSizes.textSizes[size],
                  ),
                ),
              if (icon != null) ...[
                if (label != null && width == null) const SizedBox(width: 8),
                if (width != null) const Spacer(),
                Icon(
                  icon,
                  color: effectiveStyle.iconColor,
                  size: CButtonSizes.iconSizes[size],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
