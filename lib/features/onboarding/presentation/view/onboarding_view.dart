import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/onboarding_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.titleKey,
    required this.subtitleKey,
    required this.lottieUrl,
  });

  final String titleKey;
  final String subtitleKey;
  final String lottieUrl;
}

final _slides = <OnboardingSlide>[
  const OnboardingSlide(
    titleKey: 'onboarding_slide_create_title',
    subtitleKey: 'onboarding_slide_create_subtitle',
    lottieUrl: 'https://assets10.lottiefiles.com/packages/lf20_music_wave.json',
  ),
  const OnboardingSlide(
    titleKey: 'onboarding_slide_library_title',
    subtitleKey: 'onboarding_slide_library_subtitle',
    lottieUrl: 'https://assets3.lottiefiles.com/packages/lf20_voice_ai.json',
  ),
  const OnboardingSlide(
    titleKey: 'onboarding_slide_playback_title',
    subtitleKey: 'onboarding_slide_playback_subtitle',
    lottieUrl: 'https://assets1.lottiefiles.com/temp/player.json',
  ),
];

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late final PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      final nextIndex = (_currentIndex + 1) % _slides.length;
      if (mounted) {
        _controller.animateToPage(
          nextIndex,
          duration: AppAnimations.medium,
          curve: AppAnimations.defaultCurve,
        );
      }
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
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppGradients.aurora),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassContainer(
                        borderRadius: AppRadiusTokens.sm,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(IconlyLight.shield_done, color: theme.colorScheme.onPrimary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              localization.translate('cta_enable_notifications'),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _complete(context),
                        child: Text(
                          localization.translate('guest_mode'),
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                      _startAutoPlay();
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            double offset = 0;
                            if (_controller.hasClients && _controller.page != null) {
                              offset = (_controller.page! - index) * 36;
                            }
                            return Transform.translate(
                              offset: Offset(0, offset),
                              child: child,
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Lottie.network(
                                  slide.lottieUrl,
                                  height: 220,
                                  repeat: true,
                                ).animate().fade(duration: AppAnimations.slow).scale(
                                      begin: const Offset(0.92, 0.92),
                                      end: const Offset(1, 1),
                                      curve: AppAnimations.defaultCurve,
                                    ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                localization.translate(slide.titleKey),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ).animate().fadeIn(duration: AppAnimations.medium).slideY(begin: 0.08),
                              const SizedBox(height: 12),
                              Text(
                                localization.translate(slide.subtitleKey),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 36),
                              AppCtaButton(
                                label: localization.translate(
                                  index == _slides.length - 1 ? 'cta_continue' : 'cta_next',
                                ),
                                leading: const Icon(IconlyBold.play, size: 20, color: Colors.black87),
                                onPressed: () {
                                  if (index == _slides.length - 1) {
                                    _complete(context);
                                  } else {
                                    _controller.nextPage(
                                      duration: AppAnimations.medium,
                                      curve: AppAnimations.defaultCurve,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        _slides.length,
                        (index) {
                          final isActive = index == _currentIndex;
                          return AnimatedContainer(
                            duration: AppAnimations.fast,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: 8,
                            width: isActive ? 28 : 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isActive
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onPrimary.withOpacity(0.35),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () => _complete(context),
                        child: Text(
                          localization.translate('action_skip'),
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _complete(BuildContext context) {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.go('/create');
  }
}
