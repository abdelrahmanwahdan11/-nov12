import 'dart:ui';

import '../../models/cover.dart';
import '../../models/explore.dart';
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

  static List<ExploreSection> exploreSections() {
    return <ExploreSection>[
      ExploreSection(
        id: 'trending',
        titleKey: 'explore_section_trending',
        subtitleKey: 'explore_section_trending_description',
        items: <ExploreItem>[
          ExploreItem(
            id: 'trend_midnight_wave',
            titleKey: 'explore_item_midnight_wave_title',
            subtitleKey: 'explore_item_midnight_wave_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1524680319990-3d25302c0531',
            voiceId: 'alt_03',
            accentColor: const Color(0xFF6A3CFF),
            highlightKeys: <String>['explore_badge_trending', 'explore_badge_energy'],
          ),
          ExploreItem(
            id: 'trend_glass_reverb',
            titleKey: 'explore_item_glass_reverb_title',
            subtitleKey: 'explore_item_glass_reverb_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
            voiceId: 'the_weeknd',
            accentColor: const Color(0xFF00D1FF),
            highlightKeys: <String>['explore_badge_trending', 'explore_badge_glass'],
          ),
          ExploreItem(
            id: 'trend_cartoon_hype',
            titleKey: 'explore_item_cartoon_hype_title',
            subtitleKey: 'explore_item_cartoon_hype_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1526498460520-4c246339dccb',
            voiceId: 'cartoon_01',
            accentColor: const Color(0xFFF6FF7A),
            highlightKeys: <String>['explore_badge_trending', 'explore_badge_story'],
          ),
        ],
      ),
      ExploreSection(
        id: 'fresh',
        titleKey: 'explore_section_new',
        subtitleKey: 'explore_section_new_description',
        items: <ExploreItem>[
          ExploreItem(
            id: 'fresh_sunrise_drive',
            titleKey: 'explore_item_sunrise_drive_title',
            subtitleKey: 'explore_item_sunrise_drive_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
            voiceId: 'dojacat',
            accentColor: const Color(0xFFFF8E8E),
            highlightKeys: <String>['explore_badge_new', 'explore_badge_mood'],
          ),
          ExploreItem(
            id: 'fresh_future_blossom',
            titleKey: 'explore_item_future_blossom_title',
            subtitleKey: 'explore_item_future_blossom_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f',
            voiceId: 'alt_01',
            accentColor: const Color(0xFF8EDBFF),
            highlightKeys: <String>['explore_badge_new', 'explore_badge_dream'],
          ),
          ExploreItem(
            id: 'fresh_radiant_steps',
            titleKey: 'explore_item_radiant_steps_title',
            subtitleKey: 'explore_item_radiant_steps_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1487412912498-0447578fcca8',
            voiceId: 'alt_04',
            accentColor: const Color(0xFFFFB86C),
            highlightKeys: <String>['explore_badge_new', 'explore_badge_cinematic'],
          ),
        ],
      ),
      ExploreSection(
        id: 'moods',
        titleKey: 'explore_section_moods',
        subtitleKey: 'explore_section_moods_description',
        items: <ExploreItem>[
          ExploreItem(
            id: 'mood_midnight_relax',
            titleKey: 'explore_item_midnight_relax_title',
            subtitleKey: 'explore_item_midnight_relax_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1526948128573-703ee1aeb6fa',
            voiceId: 'alt_02',
            accentColor: const Color(0xFFFFD27F),
            highlightKeys: <String>['explore_badge_mood', 'explore_badge_throwback'],
          ),
          ExploreItem(
            id: 'mood_cosmic_focus',
            titleKey: 'explore_item_cosmic_focus_title',
            subtitleKey: 'explore_item_cosmic_focus_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format',
            voiceId: 'alt_03',
            accentColor: const Color(0xFF9D84FF),
            highlightKeys: <String>['explore_badge_focus', 'explore_badge_mood'],
          ),
          ExploreItem(
            id: 'mood_aurora_glow',
            titleKey: 'explore_item_aurora_glow_title',
            subtitleKey: 'explore_item_aurora_glow_subtitle',
            imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
            voiceId: 'alt_04',
            accentColor: const Color(0xFF4CCBFF),
            highlightKeys: <String>['explore_badge_mood', 'explore_badge_energy'],
          ),
        ],
      ),
    ];
  }
}
