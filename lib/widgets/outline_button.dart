import 'package:flutter/material.dart';

class OutlineTextButton extends StatelessWidget{
  final bool isActive;
  final VoidCallback onPress;
  final String text;

  const OutlineTextButton({super.key, required this.isActive, required this.onPress, required this.text});

  @override
  Widget build(BuildContext context)
    =>     Center(child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

        ),
        onPressed: onPress,
        child: Text(text, style: TextStyle(color: Colors.black87, fontSize: 16),)
    ));

}