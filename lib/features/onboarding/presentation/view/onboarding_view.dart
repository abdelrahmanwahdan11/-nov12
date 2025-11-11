import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/onboarding_provider.dart';
import '../../../../core/theme/animations.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.titleKey,
    required this.subtitleKey,
    required this.lottieUrl,
    required this.cta,
  });

  final String titleKey;
  final String subtitleKey;
  final String lottieUrl;
  final String cta;
}

final _slides = <OnboardingSlide>[
  const OnboardingSlide(
    titleKey: 'Create AI Covers',
    subtitleKey: 'Paste a link, pick a voice, get magic.',
    lottieUrl: 'https://assets10.lottiefiles.com/packages/lf20_music_wave.json',
    cta: 'Get Started',
  ),
  const OnboardingSlide(
    titleKey: 'Huge Voice Library',
    subtitleKey: 'Musicians, characters, cartoons.',
    lottieUrl: 'https://assets3.lottiefiles.com/packages/lf20_voice_ai.json',
    cta: 'Next',
  ),
  const OnboardingSlide(
    titleKey: 'Smooth Playback',
    subtitleKey: 'Save, share, and enjoy.',
    lottieUrl: 'https://assets1.lottiefiles.com/temp/player.json',
    cta: 'Continue',
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
    _timer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      final nextIndex = (_currentIndex + 1) % _slides.length;
      _controller.animateToPage(
        nextIndex,
        duration: AppAnimations.medium,
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
    final localization = AppLocalizations.of(context);
    final media = MediaQuery.of(context);

    return Directionality(
      textDirection: localization.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _onFinish(context),
                  child: Text(localization.translate('guest_mode')),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _currentIndex = value),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.08),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network(slide.lottieUrl, height: media.size.height * 0.32),
                          const SizedBox(height: 24),
                          Text(
                            slide.titleKey,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ).animate().fade(duration: AppAnimations.medium).slide(begin: const Offset(0, 0.05)),
                          const SizedBox(height: 12),
                          Text(
                            slide.subtitleKey,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 32),
                          FilledButton(
                            onPressed: () {
                              if (index == _slides.length - 1) {
                                _onFinish(context);
                              } else {
                                _controller.nextPage(duration: AppAnimations.medium, curve: AppAnimations.defaultCurve);
                              }
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            ),
                            child: Text(slide.cta),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: AppAnimations.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 24),
                    height: 8,
                    width: _currentIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFinish(BuildContext context) {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.go('/create');
  }
}
