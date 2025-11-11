import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/explore.dart';
import '../services/mock/mock_data.dart';

final exploreSectionsProvider = Provider<List<ExploreSection>>((ref) {
  return MockData.exploreSections();
});
