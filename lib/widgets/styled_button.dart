import 'package:flutter/material.dart';

enum ButtonType {
  light(null, null),
  dark(Color(0xFF2B9B8F), Colors.white);

  final Color? backgroundColor;
  final Color? foregroundColor;

  const ButtonType(this.backgroundColor, this.foregroundColor);
}

class StyledButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPress;
  final String text;
  final ButtonType type;

  const StyledButton({
    super.key,
    required this.isActive,
    required this.onPress,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => isActive ? onPress() : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: type.backgroundColor,
        foregroundColor: type.foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      child: Text(text),
    );
  }
}
