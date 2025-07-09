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
    // Единая логика адаптации через ScreenUtils
    final fontSize = ScreenUtils.adaptiveFontSize(
      context,
      small: 14.0,   // iPhone 12 mini
      medium: 18.0,  // iPhone 12/13/14  
      large: 18.0,   // Pro Max
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
        onPressed: () => isActive ? onPress() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: type.backgroundColor,
          foregroundColor: type.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding,
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(
          text,
          maxLines: 1, // Принудительно в одну строку
          overflow: TextOverflow.ellipsis, // Троеточие если не помещается
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
