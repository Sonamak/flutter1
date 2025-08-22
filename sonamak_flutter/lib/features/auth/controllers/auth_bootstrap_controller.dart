
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonamak_flutter/data/models/auth_models.dart';
import 'package:sonamak_flutter/data/repositories/auth_repository.dart';

class AuthBootstrapState {
  final bool loading;
  final MePayload? me;
  final Object? error;

  const AuthBootstrapState({required this.loading, this.me, this.error});

  AuthBootstrapState copyWith({bool? loading, MePayload? me, Object? error}) {
    return AuthBootstrapState(
      loading: loading ?? this.loading,
      me: me ?? this.me,
      error: error,
    );
  }

  factory AuthBootstrapState.initial() => const AuthBootstrapState(loading: false);
}

class AuthBootstrapController extends StateNotifier<AuthBootstrapState> {
  AuthBootstrapController(this._repo) : super(AuthBootstrapState.initial());

  final AuthRepository _repo;

  Future<void> bootstrap() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final me = await _repo.bootstrap();
      state = state.copyWith(loading: false, me: me);
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((_) => AuthRepository());
final authBootstrapProvider = StateNotifierProvider<AuthBootstrapController, AuthBootstrapState>(
  (ref) => AuthBootstrapController(ref.read(authRepositoryProvider)),
);
