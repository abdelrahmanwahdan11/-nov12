import '../../models/cover.dart';
import '../../models/voice.dart';

class MockData {
  const MockData._();

  static List<Voice> voices() {
    return const <Voice>[
      Voice(
        id: 'the_weeknd',
        name: 'The Weeknd',
        categoryKey: 'filter_musicians',
        avatarUrl: 'https://picsum.photos/seed/weeknd/400',
        description: 'Falsetto-rich R&B crooner with lush textures.',
        tags: <String>['rnb', 'falsetto', 'modern'],
      ),
      Voice(
        id: 'dojacat',
        name: 'Doja Cat',
        categoryKey: 'filter_musicians',
        avatarUrl: 'https://picsum.photos/seed/doja/400',
        description: 'Playful pop-rap delivery with shimmering layers.',
        tags: <String>['pop', 'rap', 'energetic'],
      ),
      Voice(
        id: 'cartoon_01',
        name: 'Cartoon Star',
        categoryKey: 'filter_cartoons',
        avatarUrl: 'https://picsum.photos/seed/cartoon/400',
        description: 'Animated hero tones for vibrant storytelling.',
        tags: <String>['cartoon', 'heroic', 'bright'],
      ),
      Voice(
        id: 'alt_01',
        name: 'Indie Muse',
        categoryKey: 'filter_hot',
        avatarUrl: 'https://picsum.photos/seed/indie/400',
        description: 'Dreamy indie edges with echoing harmonies.',
        tags: <String>['indie', 'dream', 'ambient'],
      ),
      Voice(
        id: 'alt_02',
        name: 'Retro Legend',
        categoryKey: 'filter_hot',
        avatarUrl: 'https://picsum.photos/seed/retro/400',
        description: 'Classic soul phrasing and analog warmth.',
        tags: <String>['retro', 'soul', 'warm'],
      ),
      Voice(
        id: 'alt_03',
        name: 'Studio Icon',
        categoryKey: 'filter_musicians',
        avatarUrl: 'https://picsum.photos/seed/icon/400',
        description: 'Versatile powerhouse with radio-ready shine.',
        tags: <String>['studio', 'powerful', 'versatile'],
      ),
    ];
  }

  static List<Cover> covers() {
    final now = DateTime.now();
    return <Cover>[
      Cover(
        id: 'c1',
        title: 'Yellow',
        originalArtist: 'Coldplay',
        voiceId: 'the_weeknd',
        duration: const Duration(minutes: 3, seconds: 12),
        artworkUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        isFavorite: true,
      ),
      Cover(
        id: 'c2',
        title: 'Levitating',
        originalArtist: 'Dua Lipa',
        voiceId: 'dojacat',
        duration: const Duration(minutes: 2, seconds: 58),
        artworkUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        createdAt: now.subtract(const Duration(days: 2, hours: 5)),
        isFavorite: false,
      ),
      Cover(
        id: 'c3',
        title: 'Blinding Lights',
        originalArtist: 'The Weeknd',
        voiceId: 'alt_03',
        duration: const Duration(minutes: 3, seconds: 20),
        artworkUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
        createdAt: now.subtract(const Duration(days: 4)),
        isFavorite: false,
      ),
    ];
  }
}
