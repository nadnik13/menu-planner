import 'package:flutter/material.dart';
import '../utils/screen_utils.dart';

enum ButtonType {
  light(null, null),
  dark(Color(0xFF2B9B8F), Colors.white);

  final Color? backgroundColor;
  final Color? foregroundColor;

  const ButtonType(this.backgroundColor, this.foregroundColor);
}

class StyledButton extends StatelessWidget {
  final bool _isActive;
  final VoidCallback _onPressed;
  final String _text;
  final ButtonType _type;

  const StyledButton({
    super.key,
    required bool isActive,
    required void Function() onPress,
    required String text,
    required ButtonType type,
  }) : _type = type, _text = text, _onPressed = onPress, _isActive = isActive;

  @override
  Widget build(BuildContext context) {
    // Единая логика адаптации через ScreenUtils
    final fontSize = ScreenUtils.adaptiveFontSize(
      context,
      small: 14.0, // iPhone 12 mini
      medium: 18.0, // iPhone 12/13/14
      large: 18.0, // Pro Max
    );

    final padding = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      medium: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      large: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );

    return SizedBox(
      width: double.infinity, // Заполняем доступную ширину
      child: ElevatedButton(
        onPressed: () => _isActive ? _onPressed() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _type.backgroundColor,
          foregroundColor: _type.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding,
          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
        child: Text(
          _text,
          maxLines: 1, // Принудительно в одну строку
          overflow: TextOverflow.ellipsis, // Троеточие если не помещается
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
