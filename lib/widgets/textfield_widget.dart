import 'package:challengeone/config/color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? backgroundColor; // 백그라운드 컬러 추가

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor, // 백그라운드 컬러 초기화
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            color: grey100,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 48,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: grey40,
              ),
              filled: true,
              fillColor: widget.backgroundColor ?? grey10, // 백그라운드 컬러 적용
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: _getErrorBorderColor(),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: _getFocusBorderColor(),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Column(
            children: [
              SizedBox(
                height: 4,
              ),
              Text(
                widget.errorText!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: red60,
                ),
              ),
            ],
          )
      ],
    );
  }

  Color _getErrorBorderColor() {
    return widget.errorText != null && widget.errorText!.isNotEmpty
        ? red60
        : grey60;
  }

  Color _getFocusBorderColor() {
    return _hasFocus ? blue50 : grey60;
  }
}
