import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class _Voice {
  const _Voice({
    required this.id,
    required this.name,
    required this.categoryKey,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String categoryKey;
  final String avatarUrl;
}

const _mockVoices = <_Voice>[
  _Voice(
    id: 'the_weeknd',
    name: 'The Weeknd',
    categoryKey: 'filter_musicians',
    avatarUrl: 'https://picsum.photos/seed/weeknd/400',
  ),
  _Voice(
    id: 'dojacat',
    name: 'Doja Cat',
    categoryKey: 'filter_musicians',
    avatarUrl: 'https://picsum.photos/seed/doja/400',
  ),
  _Voice(
    id: 'cartoon_01',
    name: 'Cartoon Star',
    categoryKey: 'filter_cartoons',
    avatarUrl: 'https://picsum.photos/seed/cartoon/400',
  ),
  _Voice(
    id: 'alt_01',
    name: 'Indie Muse',
    categoryKey: 'filter_hot',
    avatarUrl: 'https://picsum.photos/seed/indie/400',
  ),
  _Voice(
    id: 'alt_02',
    name: 'Retro Legend',
    categoryKey: 'filter_hot',
    avatarUrl: 'https://picsum.photos/seed/retro/400',
  ),
  _Voice(
    id: 'alt_03',
    name: 'Studio Icon',
    categoryKey: 'filter_musicians',
    avatarUrl: 'https://picsum.photos/seed/icon/400',
  ),
];

class HomeCreateView extends ConsumerStatefulWidget {
  const HomeCreateView({super.key});

  @override
  ConsumerState<HomeCreateView> createState() => _HomeCreateViewState();
}

class _HomeCreateViewState extends ConsumerState<HomeCreateView> {
  final TextEditingController _linkController = TextEditingController();
  late final AudioPlayer _audioPlayer;
  late final List<String> _categoryKeys;

  String _selectedCategoryKey = 'filter_all';
  String? _previewingVoiceId;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _categoryKeys = const [
      'filter_all',
      'filter_hot',
      'filter_musicians',
      'filter_cartoons',
    ];
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _linkController.dispose();
    super.dispose();
  }

  List<_Voice> get _filteredVoices {
    if (_selectedCategoryKey == 'filter_all') {
      return _mockVoices;
    }
    return _mockVoices.where((voice) => voice.categoryKey == _selectedCategoryKey).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    final chips = _categoryKeys.map((key) {
      final isSelected = key == _selectedCategoryKey;
      final label = localization.translate(key);
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: 12),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedCategoryKey = key),
          showCheckmark: false,
        ),
      );
    }).toList();

    final voices = _filteredVoices;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 24,
          toolbarHeight: 88,
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
                    decoration: InputDecoration(
                      hintText: localization.translate('search_hint'),
                      prefixIcon: const Icon(IconlyLight.paper_plus),
                      suffixIcon: IconButton(
                        onPressed: _linkController.clear,
                        icon: const Icon(IconlyLight.close_square),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: isRtl ? chips.reversed.toList() : chips),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: voices.length,
                    itemBuilder: (context, index) {
                      final voice = voices[index];
                      final isPreviewing = voice.id == _previewingVoiceId;
                      return _VoiceCard(
                        voice: voice,
                        isPreviewing: isPreviewing,
                        onPreview: () => _handlePreview(voice),
                      );
                    },
                  ).animate().fadeIn(duration: AppAnimations.medium).slideY(begin: 0.08, curve: AppAnimations.defaultCurve),
                ),
                AppCtaButton(
                  label: localization.translate('create_new_cover'),
                  leading: const Icon(IconlyBold.edit_square, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePreview(_Voice voice) async {
    setState(() => _previewingVoiceId = voice.id);
    await _audioPlayer.stop();
    await _audioPlayer.setUrl('https://samplelib.com/lib/preview/mp3/sample-3s.mp3');
    await _audioPlayer.play();
    if (mounted) {
      setState(() => _previewingVoiceId = null);
    }
  }
}

class _VoiceCard extends StatefulWidget {
  const _VoiceCard({
    required this.voice,
    required this.onPreview,
    required this.isPreviewing,
  });

  final _Voice voice;
  final VoidCallback onPreview;
  final bool isPreviewing;

  @override
  State<_VoiceCard> createState() => _VoiceCardState();
}

class _VoiceCardState extends State<_VoiceCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPreview,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          transform: Matrix4.identity()..scale(_isHovering ? 1.02 : 1),
          child: GlassContainer(
            borderRadius: AppRadiusTokens.md,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadiusTokens.md,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.voice.avatarUrl,
                          fit: BoxFit.cover,
                        ),
                        if (widget.isPreviewing)
                          Container(
                            color: Colors.black.withOpacity(0.45),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.voice.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).translate(widget.voice.categoryKey),
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                GlassContainer(
                  borderRadius: AppRadiusTokens.sm,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  borderOpacity: 0.2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(IconlyLight.play, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).translate('label_preview'),
                        style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
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
}
