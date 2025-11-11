import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/voice.dart';
import '../../../../core/providers/voices_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class VoiceCatalogView extends ConsumerStatefulWidget {
  const VoiceCatalogView({super.key});

  @override
  ConsumerState<VoiceCatalogView> createState() => _VoiceCatalogViewState();
}

class _VoiceCatalogViewState extends ConsumerState<VoiceCatalogView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categoryKeys = <String>['filter_all', 'filter_hot', 'filter_musicians', 'filter_cartoons'];
  String _selectedCategory = 'filter_all';

  Future<void> _openVoiceDetails(BuildContext context, Voice voice) async {
    final selected = await context.push<String>('/voice/${voice.id}');
    if (!mounted) {
      return;
    }
    if (selected != null && Navigator.of(context).canPop()) {
      context.pop(selected);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Voice> _filtered(List<Voice> voices, Set<String> favorites) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = voices.where((voice) {
      final matchesCategory = _selectedCategory == 'filter_all' || voice.categoryKey == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          voice.name.toLowerCase().contains(query) ||
          voice.tags.any((tag) => tag.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();

    filtered.sort((a, b) {
      final aFav = favorites.contains(a.id);
      final bFav = favorites.contains(b.id);
      if (aFav && !bFav) {
        return -1;
      }
      if (!aFav && bFav) {
        return 1;
      }
      return a.name.compareTo(b.name);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final isRtl = localization.isRtl;
    final voices = ref.watch(voicesProvider);
    final favorites = ref.watch(favoriteVoicesProvider);

    final filteredVoices = _filtered(voices, favorites);
    final theme = Theme.of(context);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 24,
          title: Text(localization.translate('voice_catalog_title')),
          actions: [
            IconButton(
              tooltip: localization.translate('voice_catalog_filters_reset'),
              onPressed: () {
                setState(() {
                  _selectedCategory = 'filter_all';
                  _searchController.clear();
                });
              },
              icon: const Icon(IconlyLight.filter),
            ),
            const SizedBox(width: 12),
          ],
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassContainer(
                        borderRadius: AppRadiusTokens.lg,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: localization.translate('voice_catalog_search_hint'),
                            border: InputBorder.none,
                            prefixIcon: const Icon(IconlyLight.search),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(IconlyLight.close_square),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: Row(
                          children: _categoryKeys.map((key) {
                            final isSelected = _selectedCategory == key;
                            return Padding(
                              padding: const EdgeInsetsDirectional.only(end: 12),
                              child: ChoiceChip(
                                label: Text(localization.translate(key)),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() => _selectedCategory = key);
                                },
                                avatar: Icon(
                                  key == 'filter_hot'
                                      ? IconlyBold.star
                                      : key == 'filter_musicians'
                                          ? IconlyBold.voice
                                          : key == 'filter_cartoons'
                                              ? IconlyBold.paper
                                              : IconlyBold.discovery,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localization
                            .translate('voice_catalog_results_format')
                            .replaceFirst('{count}', filteredVoices.length.toString()),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (filteredVoices.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconlyLight.voice, size: 56, color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        Text(
                          localization.translate('voice_catalog_empty_title'),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localization.translate('voice_catalog_empty_subtitle'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: AppAnimations.medium),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.82,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final voice = filteredVoices[index];
                        final isFavorite = favorites.contains(voice.id);
                        return _CatalogCard(
                          voice: voice,
                          isFavorite: isFavorite,
                          onTap: () => _openVoiceDetails(context, voice),
                          onToggleFavorite: () {
                            unawaited(ref.read(favoriteVoicesProvider.notifier).toggle(voice.id));
                          },
                        ).animate().fadeIn(duration: AppAnimations.medium);
                      },
                      childCount: filteredVoices.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.voice,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Voice voice;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'voice_${voice.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadiusTokens.lg)),
                child: CachedNetworkImage(
                  imageUrl: voice.heroImageUrl ?? voice.avatarUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          voice.name,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: localization.translate('voice_catalog_favorite'),
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          isFavorite ? IconlyBold.heart : IconlyLight.heart,
                          color: isFavorite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    voice.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      GlassContainer(
                        borderRadius: AppRadiusTokens.xs,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(IconlyLight.chart, size: 16),
                            const SizedBox(width: 6),
                            Text(localization.translate(voice.rangeKey), style: theme.textTheme.labelSmall),
                          ],
                        ),
                      ),
                      ...voice.tags.take(2).map(
                        (tag) => GlassContainer(
                          borderRadius: AppRadiusTokens.xs,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Text(
                            '#$tag',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
