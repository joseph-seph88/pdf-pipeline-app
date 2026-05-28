import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import 'token_storage.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> initialize(TokenStorage tokenStorage) async {
    final token = await tokenStorage.getAccessToken();
    state = AuthState(
      status: (token != null && token.isNotEmpty)
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  void setAuthenticated() =>
      state = const AuthState(status: AuthStatus.authenticated);

  void setUnauthenticated() =>
      state = const AuthState(status: AuthStatus.unauthenticated);

  void setTokenExpired() =>
      state = const AuthState(status: AuthStatus.tokenExpired);

  Future<void> logout(TokenStorage tokenStorage) async {
    await tokenStorage.clearAccessToken();
    await tokenStorage.clearUserEmail();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
