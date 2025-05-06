// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../models/recipe.dart';
//
// class AddRecipeScreen extends ConsumerWidget{
//   final Recipe? recipe;
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();
//
//   AddRecipeScreen({super.key, this.recipe});
//
//   void _addRecipe(){
//     final title = _titleController.text.trim();
//     final description = _descController.text.trim();
//
//     if (title.isEmpty){
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Введите название')))
//     }
//   }
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Pецепт"),),
//       body: Column(
//         children: [
//           Expanded(child: TextField(
//             controller: _titleController,
//               decoration: InputDecoration(hintText: 'Введите название'),
//           )),
//           Expanded(child: TextField(
//               controller: _descController,
//               decoration: InputDecoration(hintText: 'Введите описание')
//           )),
//           IconButton(onPressed: _addRecipe, icon: Icon(Icons.save))
//         ],
//       ),
//     )
//   }
//
// }