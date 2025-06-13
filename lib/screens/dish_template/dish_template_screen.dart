import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_interactor.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_interactor.dart';
import 'package:my_recipe_app/screens/dish_template/dish_template_editor.dart';
import '../../core/logger.dart';
import '../../models/dish_template/dish_template.dart';
import '../../providers/expandable_fab_interactor.dart';
import '../../widgets/common_header.dart';
import '../../widgets/template_list.dart';

class DishTemplateScreen extends ConsumerStatefulWidget {
  const DishTemplateScreen({super.key});

  @override
  ConsumerState<DishTemplateScreen> createState() => _DishTemplateScreenState();
}

class _DishTemplateScreenState extends ConsumerState<DishTemplateScreen> {
  final searchController = TextEditingController();
  String searchQuery = '';

  void _printBox() {
    final box = Hive.box<DishTemplate>('dishTemplateBox');
    logger.d('📦 Всего рецептов: ${box.length}');
    box.toMap().forEach((key, value) {
      logger.d('🔑 $key → ${value.title}');
    });
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
    _printBox();
  }

  void _removeTemplate(DishTemplate template) {
    ref.watch(dishTemplateInteractorProvider).remove(template.id);
  }

  void _editTemplate(DishTemplate? recipe) {
    showDialog(
      context: context,
      builder: (context) => DishTemplateEditor(template: recipe),
    );
  }

  void _addDishStock(DishTemplate template) {
    ref.read(dishStockInteractorProvider).addByDishTemplate(template);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Блюдо ${template.title} добавлено')),
    );
    logger.d('Добавлено блюдо ${template.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonHeader(title: 'Еда'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                      floatingLabelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: const Color(0xFF2B9B8F),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child:
                      TemplateList(
                    onRemove: _removeTemplate,
                    onAdd: _addDishStock,
                    onEdit: _editTemplate,
                    searchQuery: searchQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: ExpandableFabInteractor.getExpandableFab(type:2, context: context),
    );
  }
}
