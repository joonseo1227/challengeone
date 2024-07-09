import 'package:challengeone/config/font.dart';
import 'package:flutter/material.dart';

class DialogUI extends StatefulWidget {
  final String title;
  final String content;
  final List<DialogButtonData> buttons;
  final Axis buttonAxis;

  const DialogUI({
    super.key,
    required this.title,
    required this.content,
    required this.buttons,
    this.buttonAxis = Axis.horizontal,
  });

  @override
  State<DialogUI> createState() => _DialogUIState();
}

class _DialogUIState extends State<DialogUI> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(32, 32, 32, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: Fonts.title,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.content,
                    style: Fonts.subtitle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            widget.buttonAxis == Axis.horizontal
                ? Row(
                    children: widget.buttons
                        .map((buttonData) => Expanded(
                              child: DialogButton(
                                text: buttonData.text,
                                onTap: buttonData.onTap,
                              ),
                            ))
                        .toList(),
                  )
                : Column(
                    children: widget.buttons
                        .map((buttonData) => DialogButton(
                              text: buttonData.text,
                              onTap: buttonData.onTap,
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final BoxBorder? border;

  const DialogButton({
    Key? key,
    required this.text,
    this.onTap,
    this.textColor = Colors.black87,
    this.textSize = 16.0,
    this.textWeight = FontWeight.bold,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.fromLTRB(32, 16, 32, 16),
    this.borderRadius = 0.0,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
              fontWeight: textWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class DialogButtonData {
  final String text;
  final VoidCallback? onTap;

  DialogButtonData({required this.text, this.onTap});
}
