import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint; // 힌트를 선택 사항으로 변경
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
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
            color: Colors.black87,
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
                color: Colors.black38,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
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
                  color: Colors.red,
                ),
              ),
            ],
          )
      ],
    );
  }

  Color _getErrorBorderColor() {
    return widget.errorText != null && widget.errorText!.isNotEmpty
        ? Colors.red
        : Colors.black54;
  }

  Color _getFocusBorderColor() {
    return _hasFocus ? Colors.blueAccent : Colors.black54;
  }
}
