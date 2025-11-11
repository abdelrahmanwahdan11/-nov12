import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';

enum AuthSessionType { anonymous, guest, authenticated }

class AuthSessionState {
  const AuthSessionState({
    required this.type,
    required this.displayName,
    required this.avatarUrl,
    this.email,
  });

  final AuthSessionType type;
  final String displayName;
  final String avatarUrl;
  final String? email;

  bool get isLoggedIn => type != AuthSessionType.anonymous;
  bool get isGuest => type == AuthSessionType.guest;
  bool get isAuthenticated => type == AuthSessionType.authenticated;

  AuthSessionState copyWith({
    AuthSessionType? type,
    String? displayName,
    String? avatarUrl,
    String? email,
  }) {
    return AuthSessionState(
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
    );
  }

  static AuthSessionState initial() {
    return const AuthSessionState(
      type: AuthSessionType.anonymous,
      displayName: 'Explorer',
      avatarUrl: 'https://images.unsplash.com/photo-1521312705-6cb0b1f1b9f4',
    );
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionNotifier, AuthSessionState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final storedType = storage.readString(StorageService.authTypeKey);
  final type = AuthSessionType.values.firstWhere(
    (value) => value.name == storedType,
    orElse: () => AuthSessionType.anonymous,
  );
  final displayName =
      storage.readString(StorageService.authDisplayNameKey) ?? 'Explorer';
  final email = storage.readString(StorageService.authEmailKey);
  final avatarUrl = storage.readString(StorageService.authAvatarKey) ??
      _avatarForSeed(displayName);

  return AuthSessionNotifier(
    storage,
    AuthSessionState(
      type: type,
      displayName: displayName,
      email: email,
      avatarUrl: avatarUrl,
    ),
  );
});

class AuthSessionNotifier extends StateNotifier<AuthSessionState> {
  AuthSessionNotifier(this._storage, super.state);

  final StorageService _storage;

  Future<void> signIn({required String email}) async {
    final displayName = _displayNameFromEmail(email);
    final avatar = _avatarForSeed(email);
    final nextState = AuthSessionState(
      type: AuthSessionType.authenticated,
      displayName: displayName,
      email: email,
      avatarUrl: avatar,
    );
    await _persist(nextState);
  }

  Future<void> signUp({required String email}) async {
    await signIn(email: email);
  }

  Future<void> startGuestSession() async {
    const displayName = 'Guest Explorer';
    final nextState = AuthSessionState(
      type: AuthSessionType.guest,
      displayName: displayName,
      email: null,
      avatarUrl: _avatarForSeed(displayName),
    );
    await _persist(nextState);
  }

  Future<void> updateDisplayName(String displayName) async {
    if (displayName.isEmpty) {
      return;
    }
    final avatar = _avatarForSeed(displayName);
    final nextState = state.copyWith(
      displayName: displayName,
      avatarUrl: avatar,
    );
    await _persist(nextState);
  }

  Future<void> logout() async {
    state = AuthSessionState.initial();
    await Future.wait([
      _storage.remove(StorageService.authTypeKey),
      _storage.remove(StorageService.authDisplayNameKey),
      _storage.remove(StorageService.authEmailKey),
      _storage.remove(StorageService.authAvatarKey),
    ]);
  }

  Future<void> _persist(AuthSessionState nextState) async {
    state = nextState;
    await Future.wait([
      _storage.writeString(StorageService.authTypeKey, nextState.type.name),
      _storage.writeString(
        StorageService.authDisplayNameKey,
        nextState.displayName,
      ),
      if (nextState.email != null)
        _storage.writeString(StorageService.authEmailKey, nextState.email!)
      else
        _storage.remove(StorageService.authEmailKey),
      _storage.writeString(StorageService.authAvatarKey, nextState.avatarUrl),
    ]);
  }
}

String _displayNameFromEmail(String email) {
  final prefix = email.split('@').first;
  if (prefix.isEmpty) {
    return 'Creator';
  }
  final segments = prefix
      .split(RegExp('[._-]+'))
      .where((segment) => segment.trim().isNotEmpty)
      .map((segment) =>
          segment[0].toUpperCase() + segment.substring(1).toLowerCase())
      .toList();
  return segments.isEmpty ? 'Creator' : segments.join(' ');
}

String _avatarForSeed(String seed) {
  const avatarPool = <String>[
    'https://images.unsplash.com/photo-1545239351-1141bd82e8a6',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df',
    'https://images.unsplash.com/photo-1521312705-6cb0b1f1b9f4',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
  ];
  final index = seed.hashCode.abs() % avatarPool.length;
  return avatarPool[index];
}
