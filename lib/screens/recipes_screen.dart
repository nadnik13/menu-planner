import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/providers/meal/meal_interactor.dart';
import 'package:my_recipe_app/providers/recipe/recipe_interactor.dart';
import 'package:my_recipe_app/screens/recipe_editor.dart';
import '../core/logger.dart';
import '../models/recipe.dart';
import '../providers/expandable_fab_interactor.dart';
import '../providers/recipe/recipe_notifier.dart';
import '../utils/emoji_utils.dart';
import '../widgets/common_header.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  final searchController = TextEditingController();
  String searchQuery = '';

  void _printRecipeBox() {
    final box = Hive.box<Recipe>('recipeBox');
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
    _printRecipeBox();
  }

  void _removeRecipe(Recipe recipe) {
    ref.watch(recipeInteractorProvider).removeRecipe(recipe);
  }

  void _editRecipe(Recipe? recipe) {
    showDialog(
      context: context,
      builder: (context) => RecipeEditor(recipe: recipe),
    );
  }

  void _addMeal(Recipe recipe) {
    ref.read(mealInteractorProvider).addMealByRecipe(recipe);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Блюдо ${recipe.title} добавлено')));
    logger.d('Добавлено блюдо ${recipe.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Container(
            //margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
                  child: //Text("_RecipeList")
                      _RecipeList(
                    onRemove: _removeRecipe,
                    onAdd: _addMeal,
                    onEdit: _editRecipe,
                    searchQuery: searchQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _editRecipe(null),
      //   tooltip: "Добавить блюдо",
      //   child: Icon(Icons.add),
      // )
      floatingActionButton: ExpandableFabInteractor.getExpandableFab(context),
    );
  }
}

class _RecipeList extends ConsumerWidget {
  final void Function(Recipe) onRemove;
  final void Function(Recipe) onEdit;
  final void Function(Recipe) onAdd;
  final String searchQuery;

  const _RecipeList({
    required this.onRemove,
    required this.onAdd,
    required this.onEdit,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeProvider);
    if (recipes.isEmpty) {
      return const Center(child: Text('Нет добавленных блюд'));
    }
    final filteredRecipes =
        recipes.where((recipe) {
          return recipe.title.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

    if (filteredRecipes.isEmpty) {
      return const Center(child: Text('Ничего не найдено'));
    }

    return ListView.builder(
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E5E5)),
            boxShadow: [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getEmojiForMeal(recipe.title),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'По умолчанию: ${recipe.portion} порции',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => onEdit(recipe),
                    icon: const Icon(Icons.edit, size: 20),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => onAdd(recipe),
                child: Text(
                  'Добавить в запасы >',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
