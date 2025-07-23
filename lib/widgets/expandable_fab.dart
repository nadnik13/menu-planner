import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ExpandableFab extends StatelessWidget {
  final List<Icon> _icons;
  final List<String> _labels;
  final List<VoidCallback> _callbacks;

  const ExpandableFab({
    super.key,
    required List<Icon> icons,
    required List<String> labels,
    required List<void Function()> callbacks,
  }) : _callbacks = callbacks, _labels = labels, _icons = icons;

  @override
  Widget build(BuildContext context) {
    if (_icons.length != _labels.length && _icons.length != _callbacks.length) {
      throw Exception('ExpandableFab arguments have wrong length');
    }
    final n = _icons.length;
    final items = List.generate(
      n,
      (i) => SpeedDialChild(
        child: _icons[i],
        label: _labels[i],
        onTap: _callbacks[i],
      ),
    );
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: const Color(0xFF2B9B8F),
      foregroundColor: Colors.white,
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      spacing: 12,
      spaceBetweenChildren: 8,
      elevation: 8,
      shape: const CircleBorder(),

      children: items,
    );
  }
}
