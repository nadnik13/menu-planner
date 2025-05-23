import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/screens/startup_screen.dart';

import 'core/extensions/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.tealAccent, // или любой другой основной цвет
        shape: const CircleBorder(),  // 👈 Возвращает стандартную круглую форму
    ),
      ),
      home: const StartupScreen(),
    );
  }
}
