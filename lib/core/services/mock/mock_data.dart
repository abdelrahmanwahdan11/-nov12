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
        heroImageUrl: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
        description: 'Falsetto-rich R&B crooner with lush textures.',
        tags: <String>['rnb', 'falsetto', 'modern'],
        rangeKey: 'voice_range_tenor',
        licenseKey: 'voice_license_personal',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_intro',
            url:
                'https://cdn.pixabay.com/download/audio/2022/03/15/audio_05b464ee8a.mp3?filename=ambient-110997.mp3',
            duration: const Duration(seconds: 18),
          ),
          VoiceSample(
            titleKey: 'voice_sample_hook',
            url:
                'https://cdn.pixabay.com/download/audio/2023/02/21/audio_97ed986996.mp3?filename=synthwave-140860.mp3',
            duration: const Duration(seconds: 22),
          ),
        ],
      ),
      Voice(
        id: 'dojacat',
        name: 'Doja Cat',
        categoryKey: 'filter_musicians',
        avatarUrl: 'https://picsum.photos/seed/doja/400',
        heroImageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
        description: 'Playful pop-rap delivery with shimmering layers.',
        tags: <String>['pop', 'rap', 'energetic'],
        rangeKey: 'voice_range_mezzo',
        licenseKey: 'voice_license_personal',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_flow',
            url:
                'https://cdn.pixabay.com/download/audio/2022/10/11/audio_3d8bad3e7b.mp3?filename=glitch-future-bass-123003.mp3',
            duration: const Duration(seconds: 20),
          ),
          VoiceSample(
            titleKey: 'voice_sample_hook',
            url:
                'https://cdn.pixabay.com/download/audio/2021/09/01/audio_1f14204e52.mp3?filename=future-hip-hop-ambient-12259.mp3',
            duration: const Duration(seconds: 24),
          ),
        ],
      ),
      Voice(
        id: 'cartoon_01',
        name: 'Cartoon Star',
        categoryKey: 'filter_cartoons',
        avatarUrl: 'https://picsum.photos/seed/cartoon/400',
        heroImageUrl: 'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
        description: 'Animated hero tones for vibrant storytelling.',
        tags: <String>['cartoon', 'heroic', 'bright'],
        rangeKey: 'voice_range_character',
        licenseKey: 'voice_license_creative',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_intro',
            url:
                'https://cdn.pixabay.com/download/audio/2023/03/07/audio_bc9f8e87dd.mp3?filename=chiptune-adventure-141937.mp3',
            duration: const Duration(seconds: 16),
          ),
          VoiceSample(
            titleKey: 'voice_sample_outro',
            url:
                'https://cdn.pixabay.com/download/audio/2021/08/08/audio_2125f0ab7e.mp3?filename=retro-game-116475.mp3',
            duration: const Duration(seconds: 19),
          ),
        ],
      ),
      Voice(
        id: 'alt_01',
        name: 'Indie Muse',
        categoryKey: 'filter_hot',
        avatarUrl: 'https://picsum.photos/seed/indie/400',
        heroImageUrl: 'https://images.unsplash.com/photo-1485579149621-3123dd979885',
        description: 'Dreamy indie edges with echoing harmonies.',
        tags: <String>['indie', 'dream', 'ambient'],
        rangeKey: 'voice_range_alto',
        licenseKey: 'voice_license_mock',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_pad',
            url:
                'https://cdn.pixabay.com/download/audio/2021/11/30/audio_9c80740175.mp3?filename=ethereal-ambient-12670.mp3',
            duration: const Duration(seconds: 23),
          ),
        ],
      ),
      Voice(
        id: 'alt_02',
        name: 'Retro Legend',
        categoryKey: 'filter_hot',
        avatarUrl: 'https://picsum.photos/seed/retro/400',
        heroImageUrl: 'https://images.unsplash.com/photo-1506157786151-b8491531f063',
        description: 'Classic soul phrasing and analog warmth.',
        tags: <String>['retro', 'soul', 'warm'],
        rangeKey: 'voice_range_baritone',
        licenseKey: 'voice_license_mock',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_intro',
            url:
                'https://cdn.pixabay.com/download/audio/2022/04/08/audio_2b45da14ad.mp3?filename=lofi-study-112191.mp3',
            duration: const Duration(seconds: 21),
          ),
        ],
      ),
      Voice(
        id: 'alt_03',
        name: 'Studio Icon',
        categoryKey: 'filter_musicians',
        avatarUrl: 'https://picsum.photos/seed/icon/400',
        heroImageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
        description: 'Versatile powerhouse with radio-ready shine.',
        tags: <String>['studio', 'powerful', 'versatile'],
        rangeKey: 'voice_range_tenor',
        licenseKey: 'voice_license_personal',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_hook',
            url:
                'https://cdn.pixabay.com/download/audio/2022/08/10/audio_932651c01d.mp3?filename=summer-vibes-117459.mp3',
            duration: const Duration(seconds: 20),
          ),
          VoiceSample(
            titleKey: 'voice_sample_outro',
            url:
                'https://cdn.pixabay.com/download/audio/2023/02/14/audio_6442ddff2d.mp3?filename=future-drift-140575.mp3',
            duration: const Duration(seconds: 18),
          ),
        ],
      ),
      Voice(
        id: 'alt_04',
        name: 'Cinematic Halo',
        categoryKey: 'filter_hot',
        avatarUrl: 'https://picsum.photos/seed/cinematic/400',
        heroImageUrl: 'https://images.unsplash.com/photo-1487956382158-bb926046304a',
        description: 'Expansive cinematic layers with airy choirs.',
        tags: <String>['cinematic', 'choir', 'airy'],
        rangeKey: 'voice_range_soprano',
        licenseKey: 'voice_license_creative',
        sampleClips: <VoiceSample>[
          VoiceSample(
            titleKey: 'voice_sample_pad',
            url:
                'https://cdn.pixabay.com/download/audio/2023/04/11/audio_10e3b43259.mp3?filename=ethereal-vista-144103.mp3',
            duration: const Duration(seconds: 26),
          ),
        ],
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
