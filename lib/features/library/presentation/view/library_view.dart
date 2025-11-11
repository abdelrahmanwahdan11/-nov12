import 'package:flutter/material.dart';

import '../../../../core/widgets/organisms/feature_placeholder.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FeaturePlaceholder(
        title: 'Library',
        subtitle: 'Browse your saved covers, history, and collections.',
      ),
    );
  }
}
