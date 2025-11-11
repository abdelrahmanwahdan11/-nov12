import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/animations.dart';
import '../../../../../core/theme/tokens.dart';
import '../../../../../core/widgets/atoms/glass_container.dart';

class AuthVisualPanel extends StatefulWidget {
  const AuthVisualPanel({
    super.key,
    required this.localization,
    required this.isRtl,
  });

  final AppLocalizations localization;
  final bool isRtl;

  @override
  State<AuthVisualPanel> createState() => _AuthVisualPanelState();
}

class _AuthVisualItem {
  const _AuthVisualItem({
    required this.imageUrl,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String imageUrl;
  final String titleKey;
  final String subtitleKey;
}

const List<_AuthVisualItem> _heroItems = <_AuthVisualItem>[
  _AuthVisualItem(
    imageUrl: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
    titleKey: 'auth_hero_slide_1_title',
    subtitleKey: 'auth_hero_slide_1_subtitle',
  ),
  _AuthVisualItem(
    imageUrl: 'https://images.unsplash.com/photo-1525182008055-f88b95ff7980',
    titleKey: 'auth_hero_slide_2_title',
    subtitleKey: 'auth_hero_slide_2_subtitle',
  ),
  _AuthVisualItem(
    imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
    titleKey: 'auth_hero_slide_3_title',
    subtitleKey: 'auth_hero_slide_3_subtitle',
  ),
];

const List<String> _highlightKeys = <String>[
  'auth_hero_highlight_offline',
  'auth_hero_highlight_queue',
  'auth_hero_highlight_library',
];

class _AuthVisualPanelState extends State<AuthVisualPanel> {
  late final PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;

  String get _indicatorSemanticLabel {
    final template = widget.localization.translate('auth_hero_indicator_format');
    return template
        .replaceAll('{current}', '${_currentIndex + 1}')
        .replaceAll('{total}', '${_heroItems.length}');
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      final nextIndex = (_currentIndex + 1) % _heroItems.length;
      if (!mounted) {
        return;
      }
      _controller.animateToPage(
        nextIndex,
        duration: AppAnimations.slow,
        curve: AppAnimations.defaultCurve,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crossAxis = widget.isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textAlign = widget.isRtl ? TextAlign.right : TextAlign.left;

    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: AppRadiusTokens.xl,
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                reverse: widget.isRtl,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _startAutoPlay();
                },
                itemCount: _heroItems.length,
                itemBuilder: (context, index) {
                  final item = _heroItems[index];
                  return CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surface.withOpacity(0.16),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                child: Column(
                  crossAxisAlignment: crossAxis,
                  children: [
                    GlassContainer(
                      borderRadius: AppRadiusTokens.sm,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      borderOpacity: 0.2,
                      child: Text(
                        widget.localization.translate('app_title'),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0.6,
                        ),
                        textAlign: textAlign,
                      ),
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: AppAnimations.medium,
                      switchInCurve: AppAnimations.defaultCurve,
                      switchOutCurve: AppAnimations.defaultCurve,
                      child: Column(
                        key: ValueKey<int>(_currentIndex),
                        crossAxisAlignment: crossAxis,
                        children: [
                          Text(
                            widget.localization.translate(_heroItems[_currentIndex].titleKey),
                            textAlign: textAlign,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.localization.translate(_heroItems[_currentIndex].subtitleKey),
                            textAlign: textAlign,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      alignment: widget.isRtl ? WrapAlignment.end : WrapAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      children: _highlightKeys
                          .map(
                            (key) => GlassContainer(
                              borderRadius: AppRadiusTokens.sm,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              borderOpacity: 0.18,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 240),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(IconlyBold.tick_square, size: 18, color: Colors.white70),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        widget.localization.translate(key),
                                        style: theme.textTheme.labelMedium?.copyWith(color: Colors.white),
                                        textAlign: textAlign,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 36),
                    Align(
                      alignment: widget.isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Semantics(
                        label: _indicatorSemanticLabel,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
                          children: List.generate(
                            _heroItems.length,
                            (index) => AnimatedContainer(
                              duration: AppAnimations.fast,
                              width: index == _currentIndex ? 26 : 10,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: index == _currentIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.32),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: widget.isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        widget.localization.translate('auth_hero_swipe_hint'),
                        textAlign: textAlign,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
