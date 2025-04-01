import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedRecipeProvider = StateProvider<Recipe?>((ref) => null);