import 'package:flutter/material.dart';
import '../utils/screen_utils.dart';

class OutlineButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPress;

  const OutlineButton({
    super.key,
    required String text,
    required void Function() onPress,
  }) : _onPress = onPress, _text = text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(
          _text,
          style: TextStyle(
            color: Colors.black87, 
            fontSize: ScreenUtils.adaptiveFontSize(
              context,
              small: 14.0,   // iPhone 12 mini
              medium: 16.0,  // iPhone 12/13/14
              large: 17.0,   // Pro Max
            ),
          ),
        ),
      ),
    );
  }
}