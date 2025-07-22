import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final List<PopupMenuEntry<String>> _menuItems;
  final void Function(String) _onMenuSelected;

  const MoreButton({
    super.key,
    required List<PopupMenuEntry<String>> menuItems,
    required void Function(String) onMenuSelected,
  }) : _onMenuSelected = onMenuSelected, _menuItems = menuItems;

  @override
  Widget build(BuildContext context) {
    return
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Colors.white, size: 30,),
          onSelected: _onMenuSelected,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) => _menuItems,
    );
  }
}
