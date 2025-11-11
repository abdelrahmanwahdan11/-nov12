import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/cover.dart';
import '../../../../core/providers/covers_provider.dart';
import '../../../../core/providers/voices_provider.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({super.key});

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    ref.read(coversProvider.notifier).updateQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final voices = ref.watch(voicesProvider);
    final coversState = ref.watch(coversProvider);
    final covers = coversState.filtered;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(localization.translate('library_title')),
        flexibleSpace: Opacity(
          opacity: 0.9,
          child: Container(
            decoration: const BoxDecoration(gradient: AppGradients.aurora),
          ),
        ),
        actions: [
          PopupMenuButton<CoverSortOption>(
            icon: const Icon(IconlyLight.filter),
            onSelected: (option) => ref.read(coversProvider.notifier).updateSort(option),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: CoverSortOption.newest,
                child: Text(localization.translate('sort_newest')),
              ),
              PopupMenuItem(
                value: CoverSortOption.longest,
                child: Text(localization.translate('sort_longest')),
              ),
              PopupMenuItem(
                value: CoverSortOption.alphabetical,
                child: Text(localization.translate('sort_alpha')),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: localization.translate('library_search_hint'),
                    prefixIcon: const Icon(IconlyLight.search),
                    suffixIcon: IconButton(
                      icon: const Icon(IconlyLight.close_square),
                      onPressed: _searchController.clear,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: covers.isEmpty
                    ? _EmptyLibrary(localization: localization)
                    : ListView.builder(
                        itemCount: covers.length,
                        itemBuilder: (context, index) {
                          final cover = covers[index];
                          return _CoverTile(cover: cover).padding(const EdgeInsets.only(bottom: 16));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverTile extends ConsumerWidget {
  const _CoverTile({required this.cover});

  final Cover cover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final voices = ref.watch(voicesProvider);
    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Hero(
            tag: 'cover_${cover.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadiusTokens.md),
              child: CachedNetworkImage(
                imageUrl: cover.artworkUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cover.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cover.originalArtist} • ${_formatDuration(cover.duration)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(
                  localization.translate('library_voice_label').replaceFirst('{voice}', voices.firstWhere((voice) => voice.id == cover.voiceId, orElse: () => voices.first).name),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(IconlyLight.play),
            onPressed: () {
              context.push('/player/${cover.id}');
            },
          ),
          IconButton(
            icon: const Icon(IconlyLight.share),
            onPressed: () {
              Share.share('${cover.title} • ${cover.originalArtist}');
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconlyLight.folder, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(localization.translate('library_empty_title'), style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            localization.translate('library_empty_subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

extension on Widget {
  Widget padding([EdgeInsetsGeometry value = EdgeInsets.zero]) {
    return Padding(padding: value, child: this);
  }
}
