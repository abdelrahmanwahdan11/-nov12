import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/explore.dart';
import '../../../../core/providers/explore_provider.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  final Map<String, PageController> _controllers = <String, PageController>{};
  final Map<String, double> _pagePositions = <String, double>{};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleQueryChanged);
  }

  void _handleQueryChanged() {
    setState(() {
      _query = _searchController.text.trim();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleQueryChanged);
    _searchController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  PageController _controllerFor(String sectionId) {
    if (_controllers.containsKey(sectionId)) {
      return _controllers[sectionId]!;
    }
    final controller = PageController(viewportFraction: 0.78);
    controller.addListener(() {
      setState(() {
        _pagePositions[sectionId] = controller.page ?? controller.initialPage.toDouble();
      });
    });
    _controllers[sectionId] = controller;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;
    final sections = ref.watch(exploreSectionsProvider);

    final List<_ExploreSectionBundle> bundles = <_ExploreSectionBundle>[];
    final query = _query.toLowerCase();
    for (final section in sections) {
      final List<ExploreItem> items = section.items.where((ExploreItem item) {
        if (query.isEmpty) {
          return true;
        }
        final title = localization.translate(item.titleKey).toLowerCase();
        final subtitle = localization.translate(item.subtitleKey).toLowerCase();
        return title.contains(query) || subtitle.contains(query);
      }).toList();
      if (items.isNotEmpty) {
        bundles.add(_ExploreSectionBundle(section: section, items: items));
      }
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.background(theme.brightness),
          ),
          child: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 180,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: DecoratedBox(
                    decoration: const BoxDecoration(gradient: AppGradients.aurora),
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.translate('explore_title'),
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localization.translate('explore_subtitle'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child: GlassContainer(
                      borderRadius: AppRadiusTokens.lg,
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(IconlyLight.search),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: localization.translate('explore_search_hint'),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_query.isNotEmpty)
                            IconButton(
                              onPressed: () => _searchController.clear(),
                              icon: const Icon(IconlyLight.close_square),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (bundles.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(IconlyBold.search, size: 64, color: theme.colorScheme.secondary),
                          const SizedBox(height: 20),
                          Text(
                            localization.translate('explore_empty_title'),
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              localization.translate('explore_empty_message'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: AppAnimations.slow),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final bundle = bundles[index];
                        final controller = _controllerFor(bundle.section.id);
                        final position = _pagePositions[bundle.section.id] ?? 0;
                        final translatedTitle = localization.translate(bundle.section.titleKey);
                        final translatedSubtitle = localization.translate(bundle.section.subtitleKey);

                        return Padding(
                          padding: EdgeInsets.fromLTRB(24, index == 0 ? 12 : 32, 24, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translatedTitle,
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                translatedSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 360,
                                child: PageView.builder(
                                  controller: controller,
                                  itemCount: bundle.items.length,
                                  padEnds: false,
                                  itemBuilder: (BuildContext context, int cardIndex) {
                                    final item = bundle.items[cardIndex];
                                    return Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        end: isRtl ? 0 : 18,
                                        start: isRtl ? 18 : 0,
                                      ),
                                      child: _ExploreCard(
                                        item: item,
                                        localization: localization,
                                        onUseVoice: () => _handleUseVoice(item.voiceId),
                                        onOpenVoice: () => _handleOpenVoice(item.voiceId),
                                      ),
                                    ).animate().fadeIn(duration: AppAnimations.medium);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _ExploreIndicators(
                                count: bundle.items.length,
                                position: position,
                                accentColor: bundle.items[math.min(position.round(), bundle.items.length - 1)].accentColor,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: bundles.length,
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: AppCtaButton(
                      label: localization.translate('explore_back_to_create'),
                      leading: const Icon(IconlyLight.arrow_left_2, size: 20),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUseVoice(String? voiceId) async {
    if (voiceId == null) {
      return;
    }
    final storage = ref.read(storageServiceProvider);
    await storage.writeString(StorageService.lastVoiceIdKey, voiceId);
    if (!mounted) {
      return;
    }
    context.go('/create');
  }

  Future<void> _handleOpenVoice(String? voiceId) async {
    if (voiceId == null) {
      return;
    }
    await context.push('/voice/$voiceId');
  }
}

class _ExploreSectionBundle {
  const _ExploreSectionBundle({required this.section, required this.items});

  final ExploreSection section;
  final List<ExploreItem> items;
}

class _ExploreIndicators extends StatelessWidget {
  const _ExploreIndicators({
    required this.count,
    required this.position,
    this.accentColor,
  });

  final int count;
  final double position;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int index) {
        final distance = (position - index).abs();
        final t = (1 - math.min(distance, 1)).clamp(0, 1).toDouble();
        final width = 12 + (24 * t);
        final opacity = 0.3 + (0.5 * t);
        return AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.defaultCurve,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: width,
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: AppRadiusTokens.sm,
          ),
        );
      }),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.item,
    required this.localization,
    required this.onUseVoice,
    required this.onOpenVoice,
  });

  final ExploreItem item;
  final AppLocalizations localization;
  final VoidCallback onUseVoice;
  final VoidCallback onOpenVoice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightChips = item.highlightKeys
        .map(localization.translate)
        .where((value) => value.isNotEmpty)
        .toList();

    return Hero(
      tag: 'explore_${item.id}',
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: AppRadiusTokens.xl,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadiusTokens.xl,
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.65),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: GlassContainer(
              borderRadius: AppRadiusTokens.xl,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: highlightChips
                        .map((label) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: (item.accentColor ?? theme.colorScheme.primary).withOpacity(0.25),
                                borderRadius: AppRadiusTokens.sm,
                                border: Border.all(
                                  color: (item.accentColor ?? theme.colorScheme.primary).withOpacity(0.6),
                                ),
                              ),
                              child: Text(
                                label,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const Spacer(),
                  Text(
                    localization.translate(item.titleKey),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.translate(item.subtitleKey),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: (item.accentColor ?? theme.colorScheme.primary).withOpacity(0.9),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          onPressed: onUseVoice,
                          icon: const Icon(IconlyLight.voice, size: 20),
                          label: Text(localization.translate('explore_use_voice')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: onOpenVoice,
                        tooltip: localization.translate('explore_view_voice'),
                        icon: const Icon(IconlyLight.info_square, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
