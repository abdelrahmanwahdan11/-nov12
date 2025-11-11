import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../models/cover.dart';

class PlayerViewState {
  const PlayerViewState({
    required this.activeCover,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isBuffering,
    required this.isRepeatEnabled,
  });

  final Cover? activeCover;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isBuffering;
  final bool isRepeatEnabled;

  PlayerViewState copyWith({
    Cover? activeCover,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBuffering,
    bool? isRepeatEnabled,
  }) {
    return PlayerViewState(
      activeCover: activeCover ?? this.activeCover,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      isRepeatEnabled: isRepeatEnabled ?? this.isRepeatEnabled,
    );
  }
}

final playerControllerProvider = StateNotifierProvider<PlayerController, PlayerViewState>((ref) {
  final controller = PlayerController();
  ref.onDispose(controller.dispose);
  return controller;
});

class PlayerController extends StateNotifier<PlayerViewState> {
  PlayerController()
      : _player = AudioPlayer(),
        super(
          const PlayerViewState(
            activeCover: null,
            position: Duration.zero,
            duration: Duration.zero,
            isPlaying: false,
            isBuffering: false,
            isRepeatEnabled: false,
          ),
        ) {
    _subscriptions.addAll(<StreamSubscription<dynamic>>[
      _player.positionStream.listen((position) {
        state = state.copyWith(position: position);
      }),
      _player.durationStream.listen((duration) {
        if (duration != null) {
          state = state.copyWith(duration: duration);
        }
      }),
      _player.playerStateStream.listen((playerState) {
        final processingState = playerState.processingState;
        final playing = playerState.playing;
        state = state.copyWith(
          isPlaying: playing,
          isBuffering: processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering,
        );
      }),
    ]);
  }

  final AudioPlayer _player;
  final List<StreamSubscription<dynamic>> _subscriptions = <StreamSubscription<dynamic>>[];

  static const Map<String, String> _voiceSamples = <String, String>{
    'the_weeknd':
        'https://cdn.pixabay.com/download/audio/2022/03/15/audio_05b464ee8a.mp3?filename=ambient-110997.mp3',
    'dojacat':
        'https://cdn.pixabay.com/download/audio/2022/10/11/audio_3d8bad3e7b.mp3?filename=glitch-future-bass-123003.mp3',
    'cartoon_01':
        'https://cdn.pixabay.com/download/audio/2023/03/07/audio_bc9f8e87dd.mp3?filename=chiptune-adventure-141937.mp3',
  };

  Future<void> playCover(Cover cover) async {
    final sampleUrl = _voiceSamples[cover.voiceId] ??
        'https://cdn.pixabay.com/download/audio/2021/09/01/audio_1f14204e52.mp3?filename=future-hip-hop-ambient-12259.mp3';
    state = state.copyWith(activeCover: cover, position: Duration.zero, duration: cover.duration);
    await _player.setUrl(sampleUrl);
    await _player.play();
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> toggleRepeat() async {
    final enabled = !state.isRepeatEnabled;
    state = state.copyWith(isRepeatEnabled: enabled);
    await _player.setLoopMode(enabled ? LoopMode.one : LoopMode.off);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(_player.dispose());
    super.dispose();
  }
}
