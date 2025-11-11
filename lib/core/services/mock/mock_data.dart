import 'dart:ui';

import '../../models/cover.dart';
import '../../models/download_task.dart';
import '../../models/explore.dart';
import '../../models/notification_message.dart';
import '../../models/project.dart';
import '../../models/vault_item.dart';
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

  static List<Project> projects() {
    final now = DateTime.now();
    return <Project>[
      Project(
        id: 'p1',
        name: 'Aurora EP',
        description: 'Bundle of neon-dream synth reinterpretations.',
        status: ProjectStatus.active,
        heroImageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
        updatedAt: now.subtract(const Duration(hours: 2)),
        entries: List<ProjectEntry>.unmodifiable(<ProjectEntry>[
          ProjectEntry(
            id: 'p1_track1',
            coverId: 'c1',
            title: 'Yellow (Aurora Mix)',
            voiceName: 'The Weeknd',
            artworkUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
            duration: const Duration(minutes: 3, seconds: 12),
            updatedAt: now.subtract(const Duration(hours: 6)),
            isCompleted: true,
          ),
          ProjectEntry(
            id: 'p1_track2',
            coverId: 'c4',
            title: 'Starlight Bloom',
            voiceName: 'Indie Muse',
            artworkUrl: 'https://images.unsplash.com/photo-1487412912498-0447578fcca8',
            duration: const Duration(minutes: 3, seconds: 40),
            updatedAt: now.subtract(const Duration(hours: 3)),
            isCompleted: false,
          ),
          ProjectEntry(
            id: 'p1_track3',
            coverId: 'c5',
            title: 'Neon Rivers',
            voiceName: 'Retro Legend',
            artworkUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
            duration: const Duration(minutes: 2, seconds: 58),
            updatedAt: now.subtract(const Duration(hours: 2)),
            isCompleted: false,
          ),
        ]),
        isPinned: true,
        notes: 'Finalize mix for track 02 and export WAV masters.',
        tags: const <String>['synthwave', 'night', 'neon'],
      ),
      Project(
        id: 'p2',
        name: 'Acoustic Sessions',
        description: 'Warm unplugged takes for licensing pitches.',
        status: ProjectStatus.ideation,
        heroImageUrl: 'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
        updatedAt: now.subtract(const Duration(days: 1, hours: 1)),
        entries: List<ProjectEntry>.unmodifiable(<ProjectEntry>[
          ProjectEntry(
            id: 'p2_track1',
            coverId: 'c6',
            title: 'Gravity Sketch',
            voiceName: 'Cartoon Star',
            artworkUrl: 'https://images.unsplash.com/photo-1526498460520-4c246339dccb',
            duration: const Duration(minutes: 2, seconds: 32),
            updatedAt: now.subtract(const Duration(days: 1, hours: 5)),
            isCompleted: false,
          ),
          ProjectEntry(
            id: 'p2_track2',
            coverId: 'c7',
            title: 'Paper Planes',
            voiceName: 'Doja Cat',
            artworkUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
            duration: const Duration(minutes: 3, seconds: 8),
            updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
            isCompleted: false,
          ),
        ]),
        isPinned: false,
        notes: 'Draft lyric sheet translations before final take.',
        tags: const <String>['acoustic', 'licensing'],
      ),
      Project(
        id: 'p3',
        name: 'Retro Remix Pack',
        description: 'High-energy throwbacks for creators club drop.',
        status: ProjectStatus.completed,
        heroImageUrl: 'https://images.unsplash.com/photo-1524680319990-3d25302c0531',
        updatedAt: now.subtract(const Duration(days: 3, hours: 4)),
        entries: List<ProjectEntry>.unmodifiable(<ProjectEntry>[
          ProjectEntry(
            id: 'p3_track1',
            coverId: 'c2',
            title: 'Levitating (Retro Flip)',
            voiceName: 'Doja Cat',
            artworkUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
            duration: const Duration(minutes: 2, seconds: 58),
            updatedAt: now.subtract(const Duration(days: 3, hours: 6)),
            isCompleted: true,
          ),
          ProjectEntry(
            id: 'p3_track2',
            coverId: 'c8',
            title: 'Night Runner',
            voiceName: 'Retro Legend',
            artworkUrl: 'https://images.unsplash.com/photo-1506157786151-b8491531f063',
            duration: const Duration(minutes: 3, seconds: 26),
            updatedAt: now.subtract(const Duration(days: 3, hours: 5)),
            isCompleted: true,
          ),
        ]),
        isPinned: false,
        notes: 'Packaged and shared with partners (mock).',
        tags: const <String>['retro', 'creator-pack'],
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

  static List<DownloadTask> downloads() {
    final now = DateTime.now();
    return <DownloadTask>[
      DownloadTask(
        id: 'download_aurora_mix',
        coverId: 'c1',
        title: 'Yellow (Aurora Mix)',
        artist: 'Coldplay',
        voiceName: 'The Weeknd',
        artworkUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        format: 'MP3',
        sizeMb: 8.4,
        duration: const Duration(minutes: 3, seconds: 12),
        progress: 0.72,
        status: DownloadStatus.downloading,
        requestedAt: now.subtract(const Duration(minutes: 8)),
        eta: const Duration(minutes: 1, seconds: 20),
      ),
      DownloadTask(
        id: 'download_midnight_drive',
        coverId: 'c2',
        title: 'Levitating (Night Drive)',
        artist: 'Dua Lipa',
        voiceName: 'Doja Cat',
        artworkUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        format: 'WAV',
        sizeMb: 24.6,
        duration: const Duration(minutes: 2, seconds: 58),
        progress: 1,
        status: DownloadStatus.completed,
        requestedAt: now.subtract(const Duration(hours: 2, minutes: 12)),
        eta: Duration.zero,
        completedAt: now.subtract(const Duration(hours: 1, minutes: 51)),
      ),
      DownloadTask(
        id: 'download_cosmic_fade',
        coverId: 'c3',
        title: 'Blinding Lights (Cosmic Fade)',
        artist: 'The Weeknd',
        voiceName: 'Studio Icon',
        artworkUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
        format: 'MP3',
        sizeMb: 9.1,
        duration: const Duration(minutes: 3, seconds: 20),
        progress: 0.18,
        status: DownloadStatus.queued,
        requestedAt: now.subtract(const Duration(minutes: 2)),
        eta: const Duration(minutes: 3),
      ),
      DownloadTask(
        id: 'download_retro_wave',
        coverId: 'c4',
        title: 'Retro Wave Skyline',
        artist: 'Future Nostalgia',
        voiceName: 'Retro Legend',
        artworkUrl: 'https://images.unsplash.com/photo-1506157786151-b8491531f063',
        format: 'MP3',
        sizeMb: 7.6,
        duration: const Duration(minutes: 3, seconds: 48),
        progress: 0.56,
        status: DownloadStatus.paused,
        requestedAt: now.subtract(const Duration(minutes: 15)),
        eta: const Duration(minutes: 2, seconds: 10),
      ),
      DownloadTask(
        id: 'download_stardust',
        coverId: 'c5',
        title: 'Stardust Echo',
        artist: 'Aurora Collective',
        voiceName: 'Cinematic Halo',
        artworkUrl: 'https://images.unsplash.com/photo-1487956382158-bb926046304a',
        format: 'WAV',
        sizeMb: 28.4,
        duration: const Duration(minutes: 4, seconds: 12),
        progress: 0.34,
        status: DownloadStatus.failed,
        requestedAt: now.subtract(const Duration(hours: 3, minutes: 27)),
        eta: const Duration(minutes: 4),
        failureReasonKey: 'download_error_storage',
      ),
    ];
  }

  static List<VaultItem> vaultItems() {
    final now = DateTime.now();
    return <VaultItem>[
      VaultItem(
        id: 'vault_midnight_drive',
        coverId: 'c2',
        title: 'Levitating (Night Drive)',
        artist: 'Dua Lipa',
        voiceName: 'Doja Cat',
        artworkUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        format: 'WAV',
        sizeMb: 24.6,
        duration: const Duration(minutes: 2, seconds: 58),
        downloadedAt: now.subtract(const Duration(hours: 2)),
      ),
      VaultItem(
        id: 'vault_aurora_mix',
        coverId: 'c1',
        title: 'Yellow (Aurora Mix)',
        artist: 'Coldplay',
        voiceName: 'The Weeknd',
        artworkUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        format: 'MP3',
        sizeMb: 8.4,
        duration: const Duration(minutes: 3, seconds: 12),
        downloadedAt: now.subtract(const Duration(days: 1, hours: 6)),
      ),
      VaultItem(
        id: 'vault_aurora_story',
        coverId: 'c5',
        title: 'Stardust Echo',
        artist: 'Aurora Collective',
        voiceName: 'Cinematic Halo',
        artworkUrl: 'https://images.unsplash.com/photo-1487956382158-bb926046304a',
        format: 'WAV',
        sizeMb: 28.4,
        duration: const Duration(minutes: 4, seconds: 12),
        downloadedAt: now.subtract(const Duration(days: 3, hours: 2)),
      ),
    ];
  }

  static List<NotificationMessage> notifications() {
    final now = DateTime.now();
    return <NotificationMessage>[
      NotificationMessage(
        id: 'notif_download_complete',
        titleKey: 'notification_download_complete_title',
        bodyKey: 'notification_download_complete_body',
        createdAt: now.subtract(const Duration(minutes: 5)),
        category: NotificationCategory.download,
        data: const <String, String>{
          'title': 'Levitating (Night Drive)',
          'format': 'WAV',
        },
      ),
      NotificationMessage(
        id: 'notif_queue_finished',
        titleKey: 'notification_queue_ready_title',
        bodyKey: 'notification_queue_ready_body',
        createdAt: now.subtract(const Duration(hours: 3, minutes: 12)),
        category: NotificationCategory.queue,
        data: const <String, String>{
          'voice': 'Studio Icon',
          'cover': 'Blinding Lights (Cosmic Fade)',
        },
      ),
      NotificationMessage(
        id: 'notif_announcement',
        titleKey: 'notification_new_feature_title',
        bodyKey: 'notification_new_feature_body',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        category: NotificationCategory.announcement,
      ),
    ];
  }
}
