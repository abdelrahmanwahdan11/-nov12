import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/services/storage_service.dart';

Future<void> bootstrap() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final storageService = StorageService(sharedPreferences: sharedPreferences);

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const App(),
    ),
  );
}
