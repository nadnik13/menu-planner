import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:food_planner/screens/dish_template/dish_template_editor.dart';
import '../../core/logger.dart';
import '../../models/dish_template/dish_template.dart';
import '../../providers/core_providers.dart';
import '../../providers/dish_stock/dish_stock_providers.dart';
import '../../providers/dish_template/dish_template_providers.dart';
import '../../widgets/common_header.dart';
import '../../widgets/template_list.dart';
import '../../utils/screen_utils.dart';

class DishTemplateScreen extends ConsumerStatefulWidget {
  const DishTemplateScreen({super.key});

  @override
  ConsumerState<DishTemplateScreen> createState() => _DishTemplateScreenState();
}

class _DishTemplateScreenState extends ConsumerState<DishTemplateScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

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
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _printBox();
  }

  void _removeTemplate(DishTemplate template) {
    ref.watch(DishTemplateProviders.interactor).remove(template.id);
  }

  void _editTemplate(DishTemplate? recipe) {
    showDialog(
      context: context,
      builder: (context) => DishTemplateEditor(template: recipe),
    );
  }

  void _addDishStock(DishTemplate template) {
    ref.read(DishStockProviders.interactor).addByDishTemplate(template);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Блюдо ${template.title} добавлено')),
    );
    logger.d('Добавлено блюдо ${template.title}');
  }

  @override
  Widget build(BuildContext context) {
    // Адаптивные отступы для экрана
    final screenPadding = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),   // iPhone 12 mini - меньше
      medium: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // iPhone 12/13/14
      large: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),  // Pro Max
    );
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Container(
            padding: screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonHeader(title: 'Еда'),
                const SizedBox(height: 8), // Фиксированный отступ между заголовком и поиском
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск...',
                    hintStyle: TextStyle(
                      color: Colors.white, 
                      fontSize: ScreenUtils.adaptiveFontSize(
                        context,
                        small: 16.0,   // iPhone 12 mini
                        medium: 20.0,  // iPhone 12/13/14
                        large: 22.0,   // Pro Max
                      ),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtils.adaptiveFontSize(
                        context,
                        small: 16.0,   // iPhone 12 mini
                        medium: 20.0,  // iPhone 12/13/14
                        large: 22.0,   // Pro Max
                      ),
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
                const SizedBox(height: 8), // Фиксированный отступ между поиском и списком
                Expanded(
                  child: TemplateList(
                    onRemove: _removeTemplate,
                    onAdd: _addDishStock,
                    onEdit: _editTemplate,
                    searchQuery: _searchQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ref.read(CoreProviders.expandableFabInteractor).getExpandableFab(type:2, context: context),
    );
  }
}
