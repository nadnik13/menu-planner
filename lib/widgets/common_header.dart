import 'package:flutter/material.dart';
import '../utils/screen_utils.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const CommonHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtils.adaptiveFontSize(
              context,
              small: 20.0,   // iPhone 12 mini
              medium: 24.0,  // iPhone 12/13/14
              large: 26.0,   // Pro Max
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
