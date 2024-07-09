import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final bool isEnabled;
  final VoidCallback? onTap;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(color: Colors.black87, fontSize: 16),
    this.borderColor = Colors.black12,
    this.borderWidth = 1.0,
    this.backgroundColor = Colors.transparent,
    this.isEnabled = true,
    this.onTap,
    this.height = 48,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isEnabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: widget.isEnabled ? widget.onTap : null,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: widget.textStyle.copyWith(
              color: widget.isEnabled ? widget.textStyle.color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
