// import 'package:flutter/material.dart';
//
// class ExpandableFab extends StatefulWidget {
//   final Function()? onAddDish;
//   final Function()? onAddDay;
//   final Function()? onAddFood;
//
//   const ExpandableFab({
//     super.key,
//     this.onAddDish,
//     this.onAddDay,
//     this.onAddFood,
//   });
//
//   @override
//   State<ExpandableFab> createState() => _ExpandableFabState();
// }
//
// class _ExpandableFabState extends State<ExpandableFab>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _controller;
//   late Animation<double> _expandAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _expandAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );
//   }
//
//   void _toggle() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }
//
//   Widget _buildOption({
//     required IconData icon,
//     required String label,
//     Function()? onPressed,
//   }) {
//     return ScaleTransition(
//       scale: _expandAnimation,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black87,
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           icon: Icon(icon),
//           label: Text(label),
//           onPressed: () {
//             onPressed?.call();
//             _toggle(); // свернуть меню после нажатия
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//      Column(
//        crossAxisAlignment: CrossAxisAlignment.end,
//        children: [
//         _buildOption(
//           icon: Icons.calendar_today,
//           label: 'Добавить план на день',
//           onPressed: widget.onAddDay,
//         ),
//         _buildOption(
//           icon: Icons.kitchen,
//           label: 'Добавить блюдо в запасы',
//           onPressed: widget.onAddDish,
//         ),
//         _buildOption(
//           icon: Icons.fastfood,
//           label: 'Добавить новую еду',
//           onPressed: widget.onAddFood,
//         ),
//
//         FloatingActionButton(
//           onPressed: _toggle,
//           backgroundColor: const Color(0xFF2B9B8F),
//           child: Icon(
//             _isExpanded ? Icons.close : Icons.add,
//             color: Colors.white,
//           ),
//          ),
//        ],
//      );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ExpandableFab extends StatelessWidget {
  final VoidCallback? onAddDay;
  final VoidCallback? onAddDish;
  final VoidCallback? onAddFood;

  const ExpandableFab({
    super.key,
    this.onAddDay,
    this.onAddDish,
    this.onAddFood,
  });

  @override
  Widget build(BuildContext context) {
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

      children: [
        SpeedDialChild(
          child: const Icon(Icons.calendar_today),
          label: 'План на день',
          onTap: onAddDay,
        ),
        SpeedDialChild(
          child: const Icon(Icons.cookie),
          label: 'Блюдо в запасы',
          onTap: onAddDish,
        ),
        SpeedDialChild(
          child: const Icon(Icons.fastfood),
          label: 'Новую еду',
          onTap: onAddFood,
        ),
      ],
    );
  }
}