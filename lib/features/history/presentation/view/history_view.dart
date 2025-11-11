import 'package:flutter/material.dart';

import '../../../../core/widgets/organisms/feature_placeholder.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FeaturePlaceholder(
        title: 'History',
        subtitle: 'Review your playback activity and recently generated covers.',
      ),
    );
  }
}
