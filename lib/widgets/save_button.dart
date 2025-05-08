import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final DateTime selectedDate;
  final bool isActive;
  final VoidCallback onSave;

  const SaveButton({super.key,
    required this.selectedDate,
    required this.isActive,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
      isActive ? onSave : null,
      child: const Text('Сохранить'),
    );
  }
}