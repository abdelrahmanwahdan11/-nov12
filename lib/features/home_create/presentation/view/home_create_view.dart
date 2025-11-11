import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/animations.dart';

class HomeCreateView extends ConsumerStatefulWidget {
  const HomeCreateView({super.key});

  @override
  ConsumerState<HomeCreateView> createState() => _HomeCreateViewState();
}

class _HomeCreateViewState extends ConsumerState<HomeCreateView> {
  final TextEditingController _linkController = TextEditingController();
  String _selectedCategory = 'All';
  final _categories = const ['All', 'Hot', 'Musicians', 'Cartoons'];
  final _voices = const [
    (
      'The Weeknd',
      'https://images.unsplash.com/photo-1521312705-6cb0b1f1b9f4',
      'Musicians',
    ),
    (
      'Doja Cat',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
      'Musicians',
    ),
    (
      'Cartoon Star',
      'https://images.unsplash.com/photo-1521312705-6cb0b1f1b9f4',
      'Cartoons',
    ),
  ];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredVoices = _voices.where((voice) {
      if (_selectedCategory == 'All') {
        return true;
      }
      return voice.$3 == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                hintText: 'Paste YouTube link',
                suffixIcon: IconButton(
                  onPressed: () => _linkController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = category),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredVoices.length,
                itemBuilder: (context, index) {
                  final voice = filteredVoices[index];
                  return _VoiceCard(
                    name: voice.$1,
                    imageUrl: voice.$2,
                    onPreview: () async {
                      await _audioPlayer.setUrl('https://samplelib.com/lib/preview/mp3/sample-3s.mp3');
                      await _audioPlayer.play();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Create new cover'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceCard extends StatefulWidget {
  const _VoiceCard({required this.name, required this.imageUrl, required this.onPreview});

  final String name;
  final String imageUrl;
  final Future<void> Function() onPreview;

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
        child: AnimatedScale(
          duration: AppAnimations.fast,
          scale: _isHovering ? 1.03 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
