import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/voice.dart';
import '../../../../core/providers/queue_provider.dart';
import '../../../../core/providers/voices_provider.dart';
import '../../../../core/services/mock/mock_audio_library.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class HomeCreateView extends ConsumerStatefulWidget {
  const HomeCreateView({super.key});

  @override
  ConsumerState<HomeCreateView> createState() => _HomeCreateViewState();
}

class _HomeCreateViewState extends ConsumerState<HomeCreateView> {
  final TextEditingController _linkController = TextEditingController();
  final AudioPlayer _previewPlayer = AudioPlayer();
  final FocusNode _linkFocusNode = FocusNode();

  final List<String> _categoryKeys = <String>[
    'filter_all',
    'filter_hot',
    'filter_musicians',
    'filter_cartoons',
  ];

  String _selectedCategoryKey = 'filter_all';
  String? _selectedVoiceId;
  String? _previewingVoiceId;
  Timer? _previewTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storage = ref.read(storageServiceProvider);
      final storedVoice = storage.readString(StorageService.lastVoiceIdKey);
      if (storedVoice != null && mounted) {
        setState(() => _selectedVoiceId = storedVoice);
      }
    });
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _previewPlayer.dispose();
    _linkController.dispose();
    _linkFocusNode.dispose();
    super.dispose();
  }

  Future<void> _playPreview(Voice voice) async {
    final sampleUrl = MockAudioLibrary.sampleUrlFromVoice(voice);
    await _previewPlayer.setUrl(sampleUrl);
    setState(() => _previewingVoiceId = voice.id);
    await _previewPlayer.play();
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(seconds: 5), () {
      _previewPlayer.stop();
      if (mounted && _previewingVoiceId == voice.id) {
        setState(() => _previewingVoiceId = null);
      }
    });
  }

  List<Voice> _filteredVoices(List<Voice> voices) {
    if (_selectedCategoryKey == 'filter_all') {
      return voices;
    }
    return voices.where((voice) => voice.categoryKey == _selectedCategoryKey).toList();
  }

  Future<void> _submitJob(AppLocalizations localization) async {
    final storage = ref.read(storageServiceProvider);
    final storedVoice = storage.readString(StorageService.lastVoiceIdKey);
    final voiceId = _selectedVoiceId ??
        ref.read(voicesProvider).firstOrNull?.id ?? storedVoice;

    if (voiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate('error_select_voice'))),
      );
      return;
    }

    final link = _linkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate('error_link_required'))),
      );
      _linkFocusNode.requestFocus();
      return;
    }

    ref.read(queueProvider.notifier).enqueue(voiceId: voiceId, source: link);
    if (!mounted) {
      return;
    }
    context.push('/queue');
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;
    final voices = ref.watch(voicesProvider);
    final favorites = ref.watch(favoriteVoicesProvider);

    final filteredVoices = _filteredVoices(voices);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 24,
          toolbarHeight: 92,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localization.translate('create_new_cover'),
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                localization.translate('header_discover_voices'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          flexibleSpace: Opacity(
            opacity: 0.85,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 24),
              child: GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconlyBold.star, color: theme.colorScheme.tertiary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      localization.translate('label_favorites'),
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: _linkController,
                    focusNode: _linkFocusNode,
                    decoration: InputDecoration(
                      hintText: localization.translate('search_hint'),
                      prefixIcon: const Icon(IconlyLight.paper_plus),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _linkController.clear();
                        },
                        icon: const Icon(IconlyLight.close_square),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  padding: const EdgeInsetsDirectional.only(end: 12),
                  child: Row(
                    children: _categoryKeys.map((key) {
                      final isSelected = key == _selectedCategoryKey;
                      final label = localization.translate(key);
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedCategoryKey = key);
                          },
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => context.push('/voices'),
                    icon: const Icon(IconlyLight.discovery),
                    label: Text(localization.translate('voice_catalog_open')),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.88,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                    ),
                    itemCount: filteredVoices.length,
                    itemBuilder: (context, index) {
                      final voice = filteredVoices[index];
                      final isSelected = voice.id == _selectedVoiceId;
                      final isFavorite = favorites.contains(voice.id);
                      final isPreviewing = voice.id == _previewingVoiceId;
                      return _VoiceCard(
                        voice: voice,
                        isSelected: isSelected,
                        isFavorite: isFavorite,
                        isPreviewing: isPreviewing,
                        onPreview: () => _playPreview(voice),
                        onTap: () {
                          setState(() => _selectedVoiceId = voice.id);
                        },
                        onToggleFavorite: () {
                          unawaited(ref.read(favoriteVoicesProvider.notifier).toggle(voice.id));
                        },
                        onOpenDetails: () async {
                          final selectedVoiceId = await context.push<String>('/voice/${voice.id}');
                          if (!mounted) {
                            return;
                          }
                          if (selectedVoiceId != null) {
                            setState(() => _selectedVoiceId = selectedVoiceId);
                            final storage = ref.read(storageServiceProvider);
                            await storage.writeString(StorageService.lastVoiceIdKey, selectedVoiceId);
                          }
                        },
                      ).animate().fadeIn(duration: AppAnimations.medium);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                AppCtaButton(
                  label: localization.translate('create_new_cover'),
                  onPressed: () => _submitJob(localization),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VoiceCard extends StatelessWidget {
  const _VoiceCard({
    required this.voice,
    required this.isSelected,
    required this.isFavorite,
    required this.isPreviewing,
    required this.onPreview,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onOpenDetails,
  });

  final Voice voice;
  final bool isSelected;
  final bool isFavorite;
  final bool isPreviewing;
  final VoidCallback onPreview;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: EdgeInsets.zero,
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.6)
              : theme.colorScheme.outlineVariant.withOpacity(0.4),
          width: 1.2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadiusTokens.lg)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'voice_${voice.id}',
                      child: CachedNetworkImage(
                        imageUrl: voice.avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 12,
                      end: 12,
                      child: IconButton(
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          isFavorite ? IconlyBold.heart : IconlyLight.heart,
                          color: isFavorite ? theme.colorScheme.tertiary : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: GlassContainer(
                        borderRadius: AppRadiusTokens.sm,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localization.translate(
                                isPreviewing ? 'voice_preview_live' : 'voice_preview_ready',
                              ),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              iconSize: 18,
                              icon: Icon(isPreviewing ? IconlyBold.voice : IconlyLight.voice),
                              onPressed: onPreview,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          voice.name,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      AnimatedContainer(
                        duration: AppAnimations.medium,
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    voice.description,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: voice.tags
                        .map(
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
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: onOpenDetails,
                      child: Text(localization.translate('voice_catalog_view_details')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().scale(
            begin: const Offset(0.98, 0.98),
            duration: AppAnimations.medium,
            curve: AppAnimations.curve,
          ),
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

