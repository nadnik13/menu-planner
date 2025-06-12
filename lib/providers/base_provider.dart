import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseProvider<T> extends StateNotifier<T> {
  BaseProvider(T initialState) : super(initialState);

  void handleError(dynamic error) {
    // TODO: Implement error handling
    print('Error: $error');
  }

  void handleLoading(bool isLoading) {
    // TODO: Implement loading state
  }
} 