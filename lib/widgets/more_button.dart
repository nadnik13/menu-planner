import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final List<PopupMenuEntry<String>> menuItems;
  final void Function(String) onMenuSelected;

  const MoreButton({
    super.key,
    required this.menuItems,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Colors.white, size: 30,),
          onSelected: onMenuSelected,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) => menuItems,
    );
  }
}
