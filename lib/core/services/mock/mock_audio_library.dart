import '../../models/voice.dart';
import 'mock_data.dart';

class MockAudioLibrary {
  const MockAudioLibrary._();

  static const String _fallbackSample =
      'https://cdn.pixabay.com/download/audio/2021/09/01/audio_1f14204e52.mp3?filename=future-hip-hop-ambient-12259.mp3';

  static String sampleUrlFromVoice(Voice voice) {
    if (voice.sampleClips.isNotEmpty) {
      return voice.sampleClips.first.url;
    }
    return _fallbackSample;
  }

  static String sampleUrlForVoiceId(String voiceId) {
    for (final voice in MockData.voices()) {
      if (voice.id == voiceId) {
        return sampleUrlFromVoice(voice);
      }
    }
    return _fallbackSample;
  }
}
